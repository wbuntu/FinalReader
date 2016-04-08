//
//  CAReaderPannel.m
//  FinalReader
//
//  Created by wbuntu on 15/6/8.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "CAReaderPannel.h"
#import "CAWThemeManager.h"
@implementation CAReaderPannel
{
    NSArray<UIColor *> *arr;
}
-(instancetype)initWithFrame:(CGRect)frame Andbg:(NSInteger)bg Andfs:(NSInteger)fs
{
    if (self = [super initWithFrame:frame]) {
        _bgColor = bg;
        _fontSize = fs;
        arr = [CAWThemeManager colorArray];
        [self setBackgroundColor:[UIColor colorWithRed:255.0/255 green:245.0/255 blue:190.0/255 alpha:1]];
        for (int i =0; i<3; i++)
            for (int j=0; j<6; j++) {
                UIButton *im = [[UIButton alloc] initWithFrame:CGRectMake(20+50*j,10+40*i,30, 30)];
                im.layer.cornerRadius = 5.0f;
                im.layer.masksToBounds = YES;
                NSInteger cur = i*6+j;
                im.tag = cur;
                [im setBackgroundColor:arr[cur]];
                [im addTarget:self action:@selector(didSelectedBg:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:im];
            }
    }
    return self;
}

-(void)didSelectedBg:(UIButton*)sender
{
    self.bgColor = sender.tag;
}
@end
