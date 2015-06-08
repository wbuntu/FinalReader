//
//  articleTableViewController.m
//  wenku8
//
//  Created by 武鸿帅 on 15/3/24.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "articleViewController.h"
#import "parserArticleinfo.h"
#import "articleDownloadViewController.h"

@interface articleViewController ()

//@property (nonatomic,strong) UITableView *tableView;
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
    [_indicator startAnimating];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"articleInfo/%d",_bookId]];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
        _intro = [dic objectForKey:@"intro"];
        _author = [dic objectForKey:@"author"];
        _classType  = [dic objectForKey:@"classtype"];
        _height = [[dic objectForKey:@"height"] floatValue];
        [_indicator stopAnimating];
    }
    else
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self getWenkuIndex];
        });
    
}

-(void)getWenkuIndex
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.wenku8.cn/wap/article/articleinfo.php?id=%d",_bookId];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *regex = @"<[^>]+>|\\s|&[^;]+;";
    NSString *restring = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    NSRegularExpression *regexs = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:nil];
    NSString *currentString = [regexs stringByReplacingMatchesInString:restring options:0 range:NSMakeRange(0, restring.length) withTemplate:@""];
    //    currentString = [currentString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    //    NSLog(@"%@",currentString);
    NSRange ra1 = [currentString rangeOfString:@"作者:"];
    NSRange ra2 = [currentString rangeOfString:@"类别"];
    NSRange ra = NSMakeRange(ra1.location+3, ra2.location-ra1.location-3);
    _author = [currentString substringWithRange:ra];
    
    ra1 = [currentString rangeOfString:@"[作品简介]"];
    ra2 = [currentString rangeOfString:@"联系管理员"];
    ra = NSMakeRange(ra1.location+6, ra2.location-ra1.location-6);
    _intro = [currentString substringWithRange:ra];
    
    ra1 = [currentString rangeOfString:@"类别:"];
    ra2 = [currentString rangeOfString:@"状态:"];
    ra = NSMakeRange(ra1.location+3, ra2.location-ra1.location-3);
    _classType = [currentString substringWithRange:ra];
    //NSLog(@"\n%@\n%@\n%@",_author,_intro,_classType);
    CGSize labelSize = [_intro boundingRectWithSize:CGSizeMake(304, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    _height=ceilf(labelSize.height);
    NSDictionary *dic = @{@"intro":_intro,@"author":_author,@"classtype":_classType,@"height":[NSNumber numberWithFloat:_height]};
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"articleInfo/%d",_bookId]];
    [dic writeToFile:path atomically:YES];
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
//            imageView.layer.cornerRadius = 6.0f;
//            imageView.layer.masksToBounds = YES;
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
            
            UILabel *classTypeLabel = (UILabel*)[cell viewWithTag:4];
            classTypeLabel.text=_classType;
            
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
