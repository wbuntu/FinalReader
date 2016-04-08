//
//  ShelfTVCCellCollectionViewCell.h
//  wenku8Reader
//
//  Created by wbuntu on 15/4/11.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bookElement.h"

//@interface CatalogProductView : UIView
//@property (strong, nonatomic)  UIImage *cover;
//@property (strong, nonatomic)  NSString *title;
//
//@end

@interface ShelfTVCCellCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic)  IBOutlet UIImageView *cover;
@property (strong, nonatomic)  IBOutlet UILabel *title;
-(void)setCellWithObject:(bookElement*)book;
@end
