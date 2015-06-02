//
//  ShelfTVCCellCollectionViewCell.m
//  wenku8Reader
//
//  Created by 武鸿帅 on 15/4/11.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "ShelfTVCCellCollectionViewCell.h"
//#import "BookManager.h"
//@implementation CatalogProductView
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if( self )
//    {
//        self.layer.cornerRadius = 6.0f;
//        self.layer.masksToBounds = YES;
//    }
//    return self;
//}
//-(void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    [[UIColor colorWithRed:255.0/255 green:245.0/255 blue:190.0/255 alpha:1] setFill];
//    UIRectFill(rect);
//    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
//    para.lineBreakMode = NSLineBreakByCharWrapping;
//    para.alignment = NSTextAlignmentCenter;
//    [_title drawInRect:CGRectMake(6, 126, 88, 24) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSParagraphStyleAttributeName:para}];
//    [_cover drawInRect:CGRectMake(11, 8, 78, 117)];
//}
//
//@end

@implementation ShelfTVCCellCollectionViewCell
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
//    _productView = [[CatalogProductView alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
//    [self addSubview:_productView];
//    _cover.layer.cornerRadius = 6.0f;
//    _cover.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:255.0/255 green:245.0/255 blue:190.0/255 alpha:1];
//    self.contentView.layer.cornerRadius = 6.0f;
//    self.contentView.layer.masksToBounds = YES;
}
-(void)setCellWithObject:(bookElement*)book
{

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
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(78, 117), NO, 0.0);
        [im drawInRect:CGRectMake(0, 0, 78, 117)];
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
