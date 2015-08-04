//
//  articleDownloadViewController.m
//  wenku8
//
//  Created by 武鸿帅 on 15/4/3.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "articleDownloadViewController.h"
#import "parserDownloadpage.h"
#import "downloadpageTableViewCell.h"
#import "VolumeManager.h"
#import "CAReaderVC.h"
@interface articleDownloadViewController ()
@property (nonatomic,strong) NSArray *bookArray;
@property(nonatomic,strong) UIActivityIndicatorView *indicator;
@property(nonatomic,strong) CAReaderVC *vc;
@end

@implementation articleDownloadViewController
{
    VolumeManager *manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:@"downloadpageParseComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"buttonChanged" object:nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"downloadpageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:249.0/255 green:234.0/255 blue:188.0/255 alpha:1]];
    _indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-40, CGRectGetMidY(self.view.frame)-40, 80, 80)];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
    [self getDownloadListAndParse];
    manager = [VolumeManager defaultManager];
}

-(void)getDownloadListAndParse
{
    NSString *downloadLink = [NSString stringWithFormat:@"http://www.wenku8.com/wap/article/packtxt.php?id=%d",_bookId];
   // NSLog(@"%@",downloadLink);
    NSURL *url = [NSURL URLWithString:downloadLink];
    
    NSURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    parserDownloadpage *delegate = [[parserDownloadpage alloc] init];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:received];
    parser.delegate=delegate;
    [parser parse];
    
}
-(void)reloadData
{
    [self.tableView reloadData];
}
-(void)loadData:(NSNotification*)notification
{
    [_indicator stopAnimating];
    _bookArray = [notification object];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"downloadpageParseComplete" object:nil];
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
//    NSLog(@"%@",sender);
//    NSLog(@"%@",sender.nextResponder);
    downloadpageTableViewCell *cell = (downloadpageTableViewCell*)sender.nextResponder.nextResponder;
//    NSLog(@"%d",cell.volumeId);
//    downloadpageTableViewCell *cell = (downloadpageTableViewCell*)sender.nextResponder;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];;
    path = [path stringByAppendingString:[NSString stringWithFormat:@"/localfiles/%d",cell.volumeId]];
//    NSLog(@"%@",path);
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
