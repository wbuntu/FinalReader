//
//  SearchVC.m
//  wenku8Reader
//
//  Created by wbuntu on 15/4/13.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "SearchVC.h"
#import "indexTableViewCell.h"
#import "articleViewController.h"
#import "CAWBook.h"
@interface SearchVC ()<UISearchBarDelegate>
@property(nonatomic,strong) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;
@property(nonatomic,strong) NSArray *bookArray;
@property(nonatomic,strong) NSMutableDictionary *imageArray;
@end

@implementation SearchVC
static NSString *identifier = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    _imageArray = [NSMutableDictionary dictionary];
    [self.tableView registerNib:[UINib nibWithNibName:@"indexTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
//    [self.tableView registerClass:[indexTableViewCell class] forCellReuseIdentifier:identifier];
    self.tableView.rowHeight=101;
    self.tableView.sectionHeaderHeight=44;
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    [_searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [_searchBar setPlaceholder:@"请尽量简写关键词，以降低错误率"];
    _searchBar.delegate=self;
//    self.navigationController.hidesBarsOnSwipe=YES;
    _indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-40, CGRectGetMidY(self.view.frame)-40, 80, 80)];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_indicator];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _searchBar;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _bookArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    CAWBook *tempBook = [[CAWBook alloc] initWithDictionary:_bookArray[indexPath.row]];
    bookElement *book = [[bookElement alloc] init];
    book.bookId = tempBook.bookId.intValue;
    book.bookTitle = tempBook.title;
    cell.title.text = book.bookTitle;
    //    UIImage *cellImage =
    cell.cover.image = [_imageArray objectForKey:[NSNumber numberWithInt:book.bookId]];
    if (cell.cover.image == nil) {
        int bookId = book.bookId;
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"cover/%ds.jpg",bookId]];
        if ([manager fileExistsAtPath:path]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *im = [UIImage imageWithContentsOfFile:path];
                //opaque：NO 不透明
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(60, 90), NO, 0.0);
                [im drawInRect:CGRectMake(0, 0, 60, 90)];
                UIImage *other = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.cover.image = other;
                    [_imageArray setObject:other forKey:[NSNumber numberWithInt:book.bookId]];
                });
            });
        }
        else
        {
            NSString *bookImage = [NSString stringWithFormat:CAWImageUrl,bookId];
            [[CAWNetwork defaultManager] dataTaskWithString:bookImage completionHandler:^(NSData *data) {
                [data writeToFile:path atomically:YES];
                UIImage *im = [UIImage imageWithContentsOfFile:path];
                //opaque：NO 不透明
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(60, 90), NO, 0.0);
                [im drawInRect:CGRectMake(0, 0, 60, 90)];
                UIImage *other = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //                NSLog(@"xiazai");
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.cover.image = other;
                    [_imageArray setObject:other forKey:[NSNumber numberWithInt:book.bookId]];
                });

            }];
        }
    }
    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *currentKey = [_searchBar text];
    NSString *baseUrl = nil;
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            baseUrl = CAWTitleUrl;
            break;
        case 1:
            baseUrl = CAWAuthorUrl;
        default:
            break;
    }
    [searchBar resignFirstResponder];
    [_indicator startAnimating];
    NSString *urlString = [baseUrl stringByAppendingString:currentKey];
    [[CAWNetwork defaultManager] dataTaskWithString:urlString completionHandler:^(NSData *data) {
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        _bookArray = temp[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_indicator stopAnimating];
            [self.tableView reloadData];
            if (_bookArray.count==0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"木有结果" message:@"请简写关键词，比如搜索“妹”即可" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        });
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    articleViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"articleViewController"];
    CAWBook *tempBook = [[CAWBook alloc] initWithDictionary:_bookArray[indexPath.row]];
    bookElement *book = [[bookElement alloc] init];
    book.bookId = tempBook.bookId.intValue;
    book.bookTitle = tempBook.title;
    [vc setWithObject:book];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
