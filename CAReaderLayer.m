//
//  CAReaderLayer.m
//  FinalReader
//
//  Created by wbuntu on 15/6/2.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//
#import "CAReaderLayer.h"
@implementation CAReaderLayer
{
    NSMutableAttributedString *tempSt;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super init]) {
        self.frame = frame;
        self.contentsScale = [UIScreen mainScreen].scale;
    }
    return self;
}
-(void)setNewStr:(NSAttributedString *)st
{
    tempSt = [st mutableCopy];
    [tempSt removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, st.length)];
    [tempSt addAttribute:NSForegroundColorAttributeName value:_fontColor range:NSMakeRange(0, st.length)];
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [tempSt drawInRect:CGRectMake(0, 0, 310, 560)];
    CGImageRef image = (CGBitmapContextCreateImage(UIGraphicsGetCurrentContext()));
    UIGraphicsEndImageContext();
    self.contents = (__bridge id)(image);
    CGImageRelease(image);
}
- (void)updateContent
{
    [tempSt removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, tempSt.length)];
    [tempSt addAttribute:NSForegroundColorAttributeName value:_fontColor range:NSMakeRange(0, tempSt.length)];
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [tempSt drawInRect:CGRectMake(0, 0, 310, 560)];
    CGImageRef image = (CGBitmapContextCreateImage(UIGraphicsGetCurrentContext()));
    UIGraphicsEndImageContext();
    self.contents = (__bridge id)(image);
    CGImageRelease(image);
}
@end