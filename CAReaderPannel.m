//
//  CAReaderPannel.m
//  FinalReader
//
//  Created by 武鸿帅 on 15/6/8.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "CAReaderPannel.h"

@implementation CAReaderPannel

-(instancetype)initWithFrame:(CGRect)frame Andbg:(NSInteger)bg Andfs:(NSInteger)fs
{
    if (self = [super initWithFrame:frame]) {
        _bgColor = bg;
        _fontSize = fs;
        [self setBackgroundColor:[UIColor colorWithRed:255.0/255 green:245.0/255 blue:190.0/255 alpha:1]];
        NSString *str = @"reading_bg%d.png";
        for (int i =0; i<4; i++)
        {
            UIButton *im = [[UIButton alloc] initWithFrame:CGRectMake(16+76*i,16, 60, 60)];
            im.tag = i+1;
            [im setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:str,i+1]] forState:UIControlStateNormal];
            [im addTarget:self action:@selector(didSelectedBg:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:im];
        }
//        UIButton *dec = [[UIButton alloc] initWithFrame:CGRectMake(30, 8, 100, 44)];
//        [dec setTitle:@"A-" forState:UIControlStateNormal];
//        [dec setTitleColor:[UIColor colorWithRed:0.0 green:91.0/255 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
//        [dec addTarget:self action:@selector(didChangeFs:) forControlEvents:UIControlEventTouchUpInside];
//        dec.tag = 5;
//        UIButton *inc = [[UIButton alloc] initWithFrame:CGRectMake(190, 8, 100, 44)];
//        [inc setTitle:@"A+" forState:UIControlStateNormal];
//        [inc setTitleColor:[UIColor colorWithRed:0.0 green:91.0/255 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
//        [inc addTarget:self action:@selector(didChangeFs:) forControlEvents:UIControlEventTouchUpInside];
//        inc.tag = 6;
//        [self addSubview:dec];
//        [self addSubview:inc];
    }
    return self;
}

-(void)didSelectedBg:(UIButton*)sender
{
    self.bgColor = sender.tag;
}
-(void)didChangeFs:(UIButton*)sender
{
    NSLog(@"%d",sender.tag);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
