//
//  SearchVC.m
//  wenku8Reader
//
//  Created by 武鸿帅 on 15/4/13.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "SearchVC.h"
#import "indexTableViewCell.h"
#import "parserSearchView.h"
#import "articleViewController.h"
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:@"searchViewParseCompleted" object:nil];
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

-(void)loadData:(NSNotification*)notification
{
    _bookArray = [notification object];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_indicator stopAnimating];
        [self.tableView reloadData];
        if (_bookArray.count==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"木有结果" message:@"请简写关键词，比如搜索“妹”即可" delegate:nil cancelButtonTitle:@"确定 " otherButtonTitles:nil, nil];
            [alert show];
        }
    });
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
    bookElement *book = [_bookArray objectAtIndex:indexPath.row];
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
            NSString *bookImage = [NSString stringWithFormat:@"http://img.wenku8.cn/image/%d/%d/%ds.jpg",bookId/1000,bookId,bookId];
            NSURL *url = [NSURL URLWithString:bookImage];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                [data writeToFile:path atomically:NO];
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
    NSString *currentKey = [NSString stringWithFormat:@"action=search&searchkey=%@&searchtype=",[_searchBar text]];
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            currentKey = [currentKey stringByAppendingString:@"articlename"];
            break;
        case 1:
            currentKey = [currentKey stringByAppendingString:@"author"];
        default:
            break;
    }
    [searchBar resignFirstResponder];
    [_indicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [currentKey dataUsingEncoding:NSUTF8StringEncoding];
        NSString *urlString = @"http://www.wenku8.cn/wap/article/search.php";
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil    error:nil];
       // NSLog(@"%@",[[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding]);
        parserSearchView *delegate = [[parserSearchView alloc] init];
        delegate.isSearchView=YES;
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:received];
        parser.delegate=delegate;
        [parser parse];
    });
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    articleViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"articleViewController"];
    bookElement *book = [_bookArray objectAtIndex:indexPath.row];
    [vc setWithObject:book];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
