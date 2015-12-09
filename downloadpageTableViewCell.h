//
//  downloadpageTableViewCell.h
//  wenku8
//
//  Created by wbuntu on 15/4/3.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface downloadpageTableViewCell : UITableViewCell<NSURLSessionDownloadDelegate>
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *link;
@property(nonatomic,strong) NSString *bookName;
@property(nonatomic) int bookId;
@property(nonatomic) int volumeId;
@property(nonatomic) BOOL isDownloaded;
@property(nonatomic) BOOL isAdded;
@property (strong, nonatomic)   IBOutlet UILabel *bookTitleLable;
@property(nonatomic,strong) UIProgressView *downloadingProgressView;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton;
@end
