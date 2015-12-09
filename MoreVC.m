//
//  MoreVC.m
//  wenku8Reader
//
//  Created by wbuntu on 15/4/13.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "MoreVC.h"
#import "parserSearchView.h"
#import "indexTableViewCell.h"
#import "articleViewController.h"
@interface MoreVC ()
@property(nonatomic)NSInteger currentPage;
@property(nonatomic,strong) NSString *urlString;
@property(nonatomic,strong) NSMutableArray *array;
@property(nonatomic,strong) NSMutableDictionary *imageArray;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;
@end

@implementation MoreVC
static NSString *identifier = @"reuseIdentifier";
-(instancetype)initWithStyle:(UITableViewStyle)style UrlString:(NSString*)urlString AndTitle:(NSString*)title
{
    if (self = [super initWithStyle:style]) {
//        NSLog(@"%@",urlString);
        self.title=title;
        _currentPage = 1;
        _urlString = urlString;
        _array = [[NSMutableArray alloc] init];
        _imageArray = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:@"morePageParseComplete" object:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"indexTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    self.tableView.rowHeight=101;
    [self.tableView setBackgroundColor:[UIColor colorWithRed:249.0/255 green:234.0/255 blue:188.0/255 alpha:1]];
//    self.navigationController.hidesBarsOnSwipe=YES;
    _indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-40, CGRectGetMidY(self.view.frame)-40, 80, 80)];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getPageAndParseWithUrlString:[NSString stringWithFormat:_urlString ,_currentPage]];
    });
}

-(void)getPageAndParseWithUrlString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
//    NSLog(@"%@",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSLog(@"%@",[[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding]);
    parserSearchView *delegate = [[parserSearchView alloc] init];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:received];
    delegate.isSearchView=NO;
    parser.delegate=delegate;
    [parser parse];
}

-(void)loadData:(NSNotification*)notification
{
    NSArray *arr = [notification object];
    [_array addObjectsFromArray:arr];
//    for (bookElement *book in arr) {
//        NSLog(@"%@ %d",book.bookTitle,book.bookId);
//    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_indicator stopAnimating];
        [self.tableView reloadData];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    indexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    // Configure the cell...
    bookElement *book = [_array objectAtIndex:indexPath.row];
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
            NSString *bookImage = [NSString stringWithFormat:@"http://img.wenku8.com/image/%d/%d/%ds.jpg",bookId/1000,bookId,bookId];
            NSURL *url = [NSURL URLWithString:bookImage];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                [data writeToFile:path atomically:YES];
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
            }];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    articleViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"articleViewController"];
    bookElement *book = [_array objectAtIndex:indexPath.row];
    [vc setWithObject:book];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y>(scrollView.contentSize.height-scrollView.frame.size.height))
    {
        [_indicator startAnimating];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _currentPage++;
            [self getPageAndParseWithUrlString:[NSString stringWithFormat:_urlString ,_currentPage]];
        });
    }
}
@end
