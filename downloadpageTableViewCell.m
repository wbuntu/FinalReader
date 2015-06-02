//
//  downloadpageTableViewCell.m
//  wenku8
//
//  Created by 武鸿帅 on 15/4/3.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "downloadpageTableViewCell.h"
#import "VolumeManager.h"
@interface downloadpageTableViewCell ()
@end

@implementation downloadpageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_isDownloaded) {
        [self.downloadButton setTitle:@"阅读" forState:UIControlStateNormal];
//        [self.downloadButton addTarget:self action:@selector(readBook) forControlEvents:UIControlEventTouchUpInside];
    }
    else
        [self.downloadButton addTarget:self action:@selector(downloadTxt) forControlEvents:UIControlEventTouchUpInside];
    [_bookTitleLable setText:_title];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)downloadTxt
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:_link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    CGSize size = self.contentView.frame.size;
    self.downloadingProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, size.height-5, size.width, 5)];
    [self addSubview:self.downloadingProgressView];
    NSURLSessionDownloadTask *download = [session downloadTaskWithRequest:request];
    [download resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    VolumeManager *manager =[VolumeManager defaultManager];
    [manager saveVolume:[NSString stringWithFormat:@"%d",_volumeId] WithVolumeName:_title AndFileLocation:location InBook:[NSString stringWithFormat:@"%d",_bookId] WithBookName:_bookName isAdded:_isAdded];
    _isDownloaded = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.downloadingProgressView removeFromSuperview];
        [self.downloadButton removeTarget:self action:@selector(downloadTxt) forControlEvents:UIControlEventTouchUpInside];
        [self.downloadButton setTitle:@"阅读" forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"buttonChanged" object:nil];
    });
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten // 每次写入的data字节数
 totalBytesWritten:(int64_t)totalBytesWritten // 当前一共写入的data字节数
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite // 期望收到的所有data字节数
{
    // 计算当前下载进度并更新视图
    double downloadProgress = totalBytesWritten / (double)totalBytesExpectedToWrite;
   // NSLog(@"进度:%f",downloadProgress);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.downloadingProgressView setProgress:downloadProgress animated:YES];
    });
}
@end
