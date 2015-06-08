//
//  ViewController.m
//  wenku8Reader
//
//  Created by 武鸿帅 on 15/4/11.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "wenku8VC.h"
#import "ShelfTVCCellCollectionViewCell.h"
#import "bookElement.h"
#import "parserIndex.h"
#import "articleViewController.h"
#import "ExrtaButton.h"
#import "MoreVC.h"
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:@"indexParseCompleted" object:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self getWenkuIndex];
    });
    self.title = @"Wenku8";
}
-(void)loadData:(NSNotification*)notification
{
    _array = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"indexParseCompleted" object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_indicator stopAnimating];
        [self.collectionView reloadData];
    });
}
-(void)getWenkuIndex
{
    NSURL *url = [NSURL URLWithString:@"http://www.wenku8.cn/wap/"];
    NSError *error=nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        
    }
//    NSString *regex2 = @"<a(.*)>(.*)</a>";
//    NSString *restring = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
//    NSRegularExpression *regexs2 = [NSRegularExpression regularExpressionWithPattern:regex2 options:0 error:nil];
//    NSArray *arr = [regexs2 matchesInString:restring options:0 range:NSMakeRange(0, restring.length)];
//    for (NSTextCheckingResult *match in arr ) {
//        NSString *str = [restring substringWithRange:[match range]];
//        NSLog(@"%@",str);
//    }
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:received];
    parserIndex *delegate = [[parserIndex alloc] init];
    parser.delegate=delegate;
    [parser parse];
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
    bookElement *book = [arr objectAtIndex:indexPath.row];
    cell.title.text = book.bookTitle;
    cell.cover.image = [_imageDic objectForKey:[NSNumber numberWithInt:book.bookId]];
    if (cell.cover.image==nil) {
        int bookId = book.bookId;
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
                    [_imageDic setObject:other forKey:[NSNumber numberWithInt:book.bookId]];
                });
            });
        }
        else
        {
            NSString *bookImage = [NSString stringWithFormat:@"http://img.wenku8.cn/image/%d/%d/%ds.jpg",bookId/1000,bookId,bookId];
            NSURL *url = [NSURL URLWithString:bookImage];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                [data writeToFile:path atomically:YES];
                UIImage *im = [UIImage imageWithContentsOfFile:path];
                //opaque：NO 不透明
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(78, 117), NO, 0.0);
                [im drawInRect:CGRectMake(0, 0, 78, 117)];
                UIImage *other = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.cover.image = other;
                    [_imageDic setObject:other forKey:[NSNumber numberWithInt:book.bookId]];
                });
            }];
        }
    }
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%@",_imageDic);
    NSLog(@"%lu",(unsigned long)_imageDic.count);
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
            urlString = @"http://www.wenku8.cn/wap/article/toplist.php?class=0&sort=dayvisit&page=%d";
            break;
        case 1:
            urlString = @"http://www.wenku8.cn/wap/article/toplist.php?class=0&sort=lastupdate&page=%d";
            break;
        case 2:
            urlString = @"http://www.wenku8.cn/wap/article/toplist.php?class=0&sort=postdate&page=%d";
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
        bookElement *book = [arr objectAtIndex:indexPath.row];
        [vc setWithObject:book];
    }
}
@end


