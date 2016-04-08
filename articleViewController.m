//
//  articleTableViewController.m
//  wenku8
//
//  Created by wbuntu on 15/3/24.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "articleViewController.h"
#import "articleDownloadViewController.h"
#import "CAWBook.h"
@interface articleViewController ()

@property (nonatomic,strong) NSString *intro;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *classType;
@property (nonatomic) float height;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;

@end

@implementation articleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-40, CGRectGetMidY(self.view.frame)-40, 80, 80)];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_indicator];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"articleInfo/%d",_bookId]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
        CAWBook *book = [[CAWBook alloc] initWithDictionary:dic];
        _bookTitle = book.title;
        _intro = book.summary;
        _author = book.author;
        _classType = book.sortlist;
        CGSize labelSize = [_intro boundingRectWithSize:CGSizeMake(304, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        _height=ceilf(labelSize.height);
    }else
    {
        [self getBookInfo];
    }
}

-(void)getBookInfo
{
    [_indicator startAnimating];
    NSURL *queryUrl = [NSURL URLWithString:[NSString stringWithFormat:CAWBookInfoUrl,_bookId]];
    //strong-weak dance
    NSData *data = [NSData dataWithContentsOfURL:queryUrl];
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *arr = [rootDic objectForKey:@"data"];
    CAWBook *book = [[CAWBook alloc] initWithDictionary:arr[0]];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"articleInfo/%d",_bookId]];
    [arr[0] writeToFile:path atomically:YES];
    _bookTitle = book.title;
    _intro = book.summary;
    _author = book.author;
    CGSize labelSize = [_intro boundingRectWithSize:CGSizeMake(304, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    _height=ceilf(labelSize.height);
    dispatch_async(dispatch_get_main_queue(), ^{
        [_indicator stopAnimating];
        [self.tableView reloadData];
    });
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 162;
            break;
        case 1:
            return  44;
            break;
        case 2:
            return CGRectGetHeight(self.view.bounds)-227;
            break;
        default:
            break;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long i = indexPath.row;
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    switch (i) {
        case 0:
        {
            UIImageView *imageView = (UIImageView*)[cell viewWithTag:5];
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"cover/%ds.jpg",_bookId]];
            imageView.image = [UIImage imageWithContentsOfFile:path];
            imageView.layer.shadowOffset = CGSizeMake(2, 2);
            imageView.layer.shadowColor = [UIColor blackColor].CGColor;
            imageView.layer.shadowOpacity = 0.9f;
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
            CGSize labelSize = [_bookTitle boundingRectWithSize:CGSizeMake(196, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            labelSize.width=ceil(labelSize.width);
            labelSize.height=ceil(labelSize.height);
            [title setFrame:CGRectMake(116, 6, labelSize.width, labelSize.height)];
            [title setFont:[UIFont systemFontOfSize:14]];
            [title setNumberOfLines:0];
            [title setLineBreakMode:NSLineBreakByWordWrapping];
            [title setUserInteractionEnabled:NO];
            [title setText:_bookTitle];
            [cell.contentView addSubview:title];
            
            UILabel *authorLabel = (UILabel*)[cell viewWithTag:3];
            authorLabel.text=_author;
            
        }
            break;
        case 1:
            break;
        case 2:
        {
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(8, 6, 304, _height)];
            [lable setFont:[UIFont systemFontOfSize:14]];
            [lable setNumberOfLines:0];
            [lable setLineBreakMode:NSLineBreakByWordWrapping];
            [lable setUserInteractionEnabled:NO];
            [lable setText:_intro];
            [cell.contentView addSubview:lable];
        }
            break;
        default:
            break;
    }
    return cell;
}
- (IBAction)pushToArticleDownload:(id)sender {
    articleDownloadViewController *view = [[articleDownloadViewController alloc] initWithStyle:UITableViewStylePlain];
    view.bookId = _bookId;
    view.bookName  =_bookTitle;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)setWithObject:(bookElement*)book{
    _bookId = book.bookId;
    _bookTitle = book.bookTitle;
}
@end
