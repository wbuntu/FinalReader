//
//  CAReaderLayer.m
//  FinalReader
//
//  Created by 武鸿帅 on 15/6/2.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//
#import "CAReaderLayer.h"
@implementation CAReaderLayer
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
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [st drawInRect:CGRectMake(0, 0, 310, 560)];
    CGImageRef image = (CGBitmapContextCreateImage(UIGraphicsGetCurrentContext()));
    UIGraphicsEndImageContext();
    self.contents = (__bridge id)(image);
    CGImageRelease(image);
}
@end