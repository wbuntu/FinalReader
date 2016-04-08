//
//  articleDownloadViewController.m
//  wenku8
//
//  Created by wbuntu on 15/4/3.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "articleDownloadViewController.h"
#import "downloadpageTableViewCell.h"
#import "VolumeManager.h"
#import "CAReaderVC.h"
@interface articleDownloadViewController ()
@property (nonatomic,strong) NSMutableArray *bookArray;
@property(nonatomic,strong) UIActivityIndicatorView *indicator;
@property(nonatomic,strong) CAReaderVC *vc;
@end
@interface titleAndLink : NSObject
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *link;
@property(nonatomic) int volumeId;
@end

@implementation titleAndLink



@end

@implementation articleDownloadViewController
{
    VolumeManager *manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"buttonChanged" object:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"downloadpageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:249.0/255 green:234.0/255 blue:188.0/255 alpha:1]];
    _indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-40, CGRectGetMidY(self.view.frame)-40, 80, 80)];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    manager = [VolumeManager defaultManager];
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
    [self getDownloadListAndParse];
}

-(void)getDownloadListAndParse
{
    NSString *downloadLink = [NSString stringWithFormat:CAWBookInfoUrl,_bookId];
    NSURL *url = [NSURL URLWithString:downloadLink];
    NSURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *received = data;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *bookDic = [dic[@"data"] firstObject];
        NSArray *tempArr = bookDic[@"length"];
        _bookArray = [NSMutableArray array];
        for (NSString *volum in tempArr) {
            titleAndLink *singleVol = [[titleAndLink alloc] init];
            singleVol.title = volum;
            singleVol.link = [CAWTxteUrl stringByAppendingString:volum];
            singleVol.link = [singleVol.link stringByAppendingString:@".txt"];
            singleVol.volumeId = [[volum stringByReplacingOccurrencesOfString:@"-" withString:@"0"] intValue];
            [_bookArray addObject:singleVol];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_indicator stopAnimating];
            [self.tableView reloadData];
        });
    }];
    [task resume];
}
-(void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return _bookArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    downloadpageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // Configure the cell...
    titleAndLink *tal = [_bookArray objectAtIndex:indexPath.row];
    cell.title= tal.title;
    cell.link=tal.link;
    cell.bookName = _bookName;
    cell.bookId=_bookId;
    cell.volumeId = tal.volumeId;
    [manager isVolume:[NSString stringWithFormat:@"%d",tal.volumeId] InBook:[NSString stringWithFormat:@"%d",_bookId] ExistInCell:cell];
    if (cell.isDownloaded) {
        UIButton *button = (UIButton*)[cell viewWithTag:3];
        [button addTarget:self action:@selector(pushToReader:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController.isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
-(void)pushToReader:(UIButton *)sender
{
    downloadpageTableViewCell *cell = (downloadpageTableViewCell*)sender.nextResponder.nextResponder;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];;
    path = [path stringByAppendingString:[NSString stringWithFormat:@"/localfiles/%d",cell.volumeId]];
    if (_vc==nil) {
        _vc = [[CAReaderVC alloc] init];
    }
    _vc.path = path;
    _vc.isStatusBarHidden = YES;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController pushViewController:_vc animated:YES];
}

@end
