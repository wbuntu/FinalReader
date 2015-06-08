//
//  indexTableViewCell.m
//  wenku8
//
//  Created by 武鸿帅 on 15/3/22.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "indexTableViewCell.h"
//@implementation CTView
//
//-(instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.opaque=YES;
//        self.backgroundColor = [UIColor colorWithRed:249.0/255 green:234.0/255 blue:188.0/255 alpha:1];
//    }
//    return self;
//}
//
//-(void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    [_bookCover drawInRect:CGRectMake(8, 6, 60, 90)];
//    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
//    para.lineBreakMode = NSLineBreakByCharWrapping;
//    para.alignment = NSTextAlignmentLeft;
//    [_bookTitle drawInRect:CGRectMake(76, 6, 236, 100) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:para}];
//}
//@end

@interface indexTableViewCell()


@end
@implementation indexTableViewCell
-(void)awakeFromNib
{
    [super awakeFromNib];
    _cover.layer.shadowOffset = CGSizeMake(2, 2);
    _cover.layer.shadowColor = [UIColor blackColor].CGColor;
    _cover.layer.shadowOpacity = 0.9;
}
-(void)setCellWithBook:(bookElement*)book
{
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
                _cover.image = other;
                _title.text = book.bookTitle;
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
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(60, 90), NO, 0.0);
            [im drawInRect:CGRectMake(0, 0, 60, 90)];
            UIImage *other = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                _cover.image = other;
                _title.text = book.bookTitle;
            });
        }];
    }
    
}
@end
