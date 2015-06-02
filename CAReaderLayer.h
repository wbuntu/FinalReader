//
//  CAReaderLayer.h
//  FinalReader
//
//  Created by 武鸿帅 on 15/6/2.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface CAReaderLayer : CALayer
-(instancetype)initWithFrame:(CGRect) frame;
-(void)setNewStr:(NSAttributedString*)str;
@end
