//
//  CAReaderLayer.h
//  FinalReader
//
//  Created by wbuntu on 15/6/2.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface CAReaderLayer : CALayer
@property(nonatomic,strong) UIColor *fontColor;
-(instancetype)initWithFrame:(CGRect) frame;
-(void)setNewStr:(NSAttributedString*)str;
- (void)updateContent;
@end
