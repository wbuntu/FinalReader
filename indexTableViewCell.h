//
//  indexTableViewCell.h
//  wenku8
//
//  Created by 武鸿帅 on 15/3/22.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bookElement.h"
//
//@interface CTView : UIView
//@property(nonatomic,strong) NSString *bookTitle;
//@property(nonatomic,strong) UIImage *bookCover;
//@end

@interface indexTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cover;
@property (strong, nonatomic) IBOutlet UILabel *title;
-(void)setCellWithBook:(bookElement*)book;
@end
