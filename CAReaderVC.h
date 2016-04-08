//
//  CAReaderVC.h
//  FinalReader
//
//  Created by wbuntu on 15/6/2.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAReaderVC : UIViewController
@property(nonatomic,strong) NSString *path;
@property(nonatomic) BOOL isStatusBarHidden;
@property(nonatomic,strong) UIColor *fontColor;
@property(nonatomic,assign) NSInteger bgColor;
@end
