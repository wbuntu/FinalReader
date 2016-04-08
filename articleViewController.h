//
//  articleTableViewController.h
//  wenku8
//
//  Created by wbuntu on 15/3/24.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bookElement.h"
@interface articleViewController : UITableViewController
@property(nonatomic,strong) NSString *bookTitle;
@property(nonatomic) int bookId;
-(void)setWithObject:(bookElement*)book;
@end
