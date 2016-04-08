//
//  ViewController.m
//  wenku8Reader
//
//  Created by wbuntu on 15/4/11.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "wenku8VC.h"
#import "ShelfTVCCellCollectionViewCell.h"
#import "bookElement.h"
#import "articleViewController.h"
#import "ExrtaButton.h"
#import "MoreVC.h"
#import "CAWBook.h"
@interface  wenku8VC()
@property(nonatomic,strong) NSMutableArray *array;
@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,strong) UIActivityIndicatorView *indicator;
@property(nonatomic,strong) NSMutableDictionary *imageDic;
@end

@implementation wenku8VC
static NSString *identifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    [self.view setBackgroundColor:[UIColor colorWithRed:245 green:245 blue:245 alpha:1]];
    _indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-40, CGRectGetMidY(self.view.frame)-40, 80, 80)];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
    _titleArray = @[@"今日热榜",@"最近更新",@"新书榜单",@"每周推荐"];
    _imageDic = [NSMutableDictionary dictionary];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self getWenkuIndex];
    });
    self.title = @"Wenku8";
}
-(void)getWenkuIndex
{
    [[CAWNetwork defaultManager] dataTaskWithString:CAWFirstPageUrl completionHandler:^(NSData *data) {
        NSData *received = data;
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *tempDic = [rootDic objectForKey:@"data"];
        _array = [NSMutableArray arrayWithArray:[tempDic allValues]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_indicator stopAnimating];
            [self.collectionView reloadData];
        });
    }];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = [_array objectAtIndex:section];
    return arr.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _array.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShelfTVCCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSArray *arr = [_array objectAtIndex:indexPath.section];
    CAWBook *book = [[CAWBook alloc] initWithDictionary:arr[indexPath.row]];
    cell.title.text = book.title;
    cell.cover.image = [_imageDic objectForKey:book.bookId];
    if (cell.cover.image==nil) {
        int bookId = [book.bookId intValue];
        NSString *path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"cover/%ds.jpg",bookId]];
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:path]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *im = [UIImage imageWithContentsOfFile:path];
                //opaque：NO 不透明
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(78, 117), NO, 0.0);
                [im drawInRect:CGRectMake(0, 0, 78, 117)];
                UIImage *other = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.cover.image = other;
                    [_imageDic setObject:other forKey:book.bookId];
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
                    UIGraphicsBeginImageContextWithOptions(CGSizeMake(78, 117), NO, 0.0);
                    [im drawInRect:CGRectMake(0, 0, 78, 117)];
                    UIImage *other = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.cover.image = other;
                        [_imageDic setObject:other forKey:book.bookId];
                    });
            }];
        }
    }
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        UILabel *lable = (UILabel*)[view viewWithTag:2];
        [lable setText:[_titleArray objectAtIndex:indexPath.section]];
        ExrtaButton *button =(ExrtaButton*)[view viewWithTag:3];
        button.section = indexPath.section;
        if (indexPath.section==3)
            [button setHidden:YES];
        else
        {
            [button setHidden:NO];
            [button addTarget:self action:@selector(pushToSearchWithSection:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return view;
}
-(void)pushToSearchWithSection:(ExrtaButton*)sender
{
    //NSLog(@"%d",sender.section);
    NSString *urlString;
    switch (sender.section)
    {
        case 0:
            urlString = [CAWPageSectionUrl stringByAppendingString:@"sort=0&page=%d"];
            break;
        case 1:
            urlString = [CAWPageSectionUrl stringByAppendingString:@"sort=1&page=%d"];
            break;
        case 2:
            urlString = [CAWPageSectionUrl stringByAppendingString:@"sort=2&page=%d"];
            break;
        default:
            break;
    }
    MoreVC *vc = [[MoreVC alloc] initWithStyle:UITableViewStylePlain UrlString:urlString AndTitle:[_titleArray objectAtIndex:sender.section]];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"articleInfo"]) {
        articleViewController *vc = segue.destinationViewController;
        ShelfTVCCellCollectionViewCell *cell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        NSArray *arr = [_array objectAtIndex:indexPath.section];
        CAWBook *tempBook = [[CAWBook alloc] initWithDictionary:arr[indexPath.row]];
        bookElement *book = [[bookElement alloc] init];
        book.bookId = tempBook.bookId.intValue;
        book.bookTitle = tempBook.title;
        [vc setWithObject:book];
    }
}
@end