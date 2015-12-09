//
//  CAReaderPannel.h
//  FinalReader
//
//  Created by wbuntu on 15/6/8.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAReaderPannel : UIView
@property(nonatomic,assign) NSInteger bgColor;
@property(nonatomic,assign) NSInteger fontSize;
-(instancetype)initWithFrame:(CGRect)frame Andbg:(NSInteger)bg Andfs:(NSInteger)fs;
@end
