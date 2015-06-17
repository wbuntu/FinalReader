//
//  CAReaderVC.m
//  FinalReader
//
//  Created by 武鸿帅 on 15/6/2.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//
#import "CAReaderVC.h"
#import "CAReaderLayer.h"
#import "CAReaderPannel.h"
#import <CoreText/CoreText.h>
#import "VolumeManager.h"
@interface CAReaderVC()
@property(nonatomic,strong) CAReaderLayer*ViewToD;
@property(nonatomic,assign) NSInteger totalPage;
@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,strong) UIActivityIndicatorView *indicator;
@property(nonatomic,strong) NSMutableArray *pagingResult;
@property(nonatomic,strong) NSMutableAttributedString *attString;
@property(nonatomic,strong) NSString *pagingResultPath;
@property(nonatomic,strong) NSString *bookPath;
@property(nonatomic,assign) BOOL isNewBook;
@property(nonatomic,strong) CAReaderPannel *pannel;
@end

@implementation CAReaderVC
#pragma mark -- 视图部分
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:249.0/255 green:234.0/255 blue:188.0/255 alpha:1]];
    _indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-40, CGRectGetMidY(self.view.frame)-40, 80, 80)];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_indicator];
    
    _ViewToD = [[CAReaderLayer alloc] initWithFrame:CGRectMake(5, 4, 310, 560)];
    [self.view.layer addSublayer:_ViewToD];
    
    NSNumber *bg = [[NSUserDefaults standardUserDefaults] objectForKey:@"bgColor"];
    NSInteger bgColor;
    if (bg)
        bgColor = bg.integerValue;
    else
        bgColor = 1;
    [self drawNewBgWith:bgColor];
    
    _pannel = [[CAReaderPannel alloc] initWithFrame:CGRectMake(0, 476, 320, 92) Andbg:bgColor Andfs:16];
    [self.view addSubview:_pannel];
    
    [_pannel addObserver:self forKeyPath:@"bgColor" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelector:)];
    [self.view addGestureRecognizer:tap];
}
-(void)drawNewBgWith:(NSInteger)bg
{
    UIImage *im = [UIImage imageNamed:[NSString stringWithFormat:@"reading_bg%ld.png",(long)bg]];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 568), NO, 0.0);
    [im drawAsPatternInRect:CGRectMake(0, 0, 320, 568)];
    self.view.layer.contents = (__bridge id)(CGBitmapContextCreateImage(UIGraphicsGetCurrentContext()));
    UIGraphicsEndImageContext();
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"bgColor"])
    {
        [self drawNewBgWith:(long)_pannel.bgColor];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_indicator startAnimating];
    _pannel.center = CGPointMake(160, 614);
    [self showBookWithPath:_path];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _ViewToD.contents = nil;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_pannel.bgColor] forKey:@"bgColor"];
    [[VolumeManager defaultManager] addBookmarkWithBookId:[_bookPath lastPathComponent] AndCurrntPage:_currentPage];
}
#pragma mark -- 懒加载
-(NSAttributedString*)attString
{
    if (_attString == nil || _isNewBook) {
        NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *aText = [NSString stringWithContentsOfFile:_bookPath encoding:gbk error:nil];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 0.0f;
        _attString = [[NSMutableAttributedString alloc] initWithString:aText attributes:@{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Light" size:16],NSParagraphStyleAttributeName:style}];
    }
    return _attString;
}
-(NSMutableArray*)pagingResult
{
    if (_pagingResult == nil || _isNewBook) {
        _pagingResult = [NSMutableArray arrayWithContentsOfFile:self.pagingResultPath];
    }
    return _pagingResult;
}
-(NSString*)pagingResultPath
{
    if ((_pagingResultPath==nil)||_isNewBook) {
        _pagingResultPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"pagingResults/%@",[_bookPath lastPathComponent]]];
    }
    return _pagingResultPath;
}
#pragma mark -- 重用处理
-(void)showBookWithPath:(NSString *)Path
{
    _isNewBook = ![Path isEqualToString:_bookPath];
    //初次启动或者已经启动，但换了书
    if ((_bookPath==nil)|| _isNewBook)
    {
        _bookPath = Path;
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.pagingResultPath])
        {
            _currentPage = [[[VolumeManager defaultManager].volumeMark objectForKey:[_bookPath lastPathComponent]] integerValue];
            _totalPage = self.pagingResult.count;
            NSRange ra = NSRangeFromString(_pagingResult[_currentPage]);
            [_ViewToD setNewStr:[self.attString attributedSubstringFromRange:ra]];
            [_indicator stopAnimating];
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [self pagingWithCoreText];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSRange ra = NSRangeFromString(_pagingResult[0]);
                    [_ViewToD setNewStr:[self.attString attributedSubstringFromRange:ra]];
                    [_indicator stopAnimating];
                });
            });
        }
    }
    else
    {
        //不换书的情况
        _totalPage = self.pagingResult.count;
        NSRange ra = NSRangeFromString(self.pagingResult[_currentPage]);
        [_ViewToD setNewStr:[self.attString attributedSubstringFromRange:ra]];
        [_indicator stopAnimating];
    }
}
#pragma mark -- 分页策略
-(void)pagingWithCoreText
{
    NSAttributedString *str = [self.attString copy];
    _pagingResult = [NSMutableArray array];
    CGRect textFrame = CGRectMake(0, 0, 310, 560);
    CFAttributedStringRef cfAttStr = CFBridgingRetain(str);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(cfAttStr);
    int textPos = 0;
    _totalPage = 0;
    _currentPage = 0;
    NSUInteger strLength = [_attString length];
    while (textPos < strLength)
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, textFrame);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        NSRange ra = NSMakeRange(frameRange.location, frameRange.length);
        [_pagingResult addObject:NSStringFromRange(ra)];
        textPos += frameRange.length;
        CFRelease(frame);
        CGPathRelease(path);
        _totalPage++;
    }
    CFRelease(framesetter);
    CFRelease(cfAttStr);
    [_pagingResult writeToFile:_pagingResultPath atomically:YES];
}
#pragma mark -- 手势处理
-(void)tapSelector:(UITapGestureRecognizer*)tap
{
    CGPoint center = self.view.center;
    CGPoint p = [tap locationInView:self.view];
    if (p.x>center.x+50) {
        if (!(_currentPage==_totalPage-1))
        {
            _currentPage++;
            NSRange ra = NSRangeFromString(_pagingResult[_currentPage]);
            [_ViewToD setNewStr:[self.attString attributedSubstringFromRange:ra]];
        }
        if(!self.navigationController.isNavigationBarHidden)
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            _pannel.center = CGPointMake(160, 614);
            _isStatusBarHidden=!_isStatusBarHidden;
            [self setNeedsStatusBarAppearanceUpdate];
            
        }
    }
    else if(p.x<center.x-50)
    {
        if (!(_currentPage==0)) {
            _currentPage--;
            NSRange ra = NSRangeFromString(_pagingResult[_currentPage]);
            [_ViewToD setNewStr:[self.attString attributedSubstringFromRange:ra]];
        }
        if(!self.navigationController.isNavigationBarHidden)
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            _pannel.center = CGPointMake(160, 614);
            _isStatusBarHidden=!_isStatusBarHidden;
            [self setNeedsStatusBarAppearanceUpdate];
            
        }
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            BOOL isHidedn = !self.navigationController.isNavigationBarHidden;
            [self.navigationController setNavigationBarHidden:isHidedn animated:YES];
            if (isHidedn)
                _pannel.center = CGPointMake(160, 614);
            else
                _pannel.center = CGPointMake(160,522);
            _isStatusBarHidden=!_isStatusBarHidden;
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
}
#pragma mark -- 隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return _isStatusBarHidden;
}
-(void)dealloc
{
    [_pannel removeObserver:self forKeyPath:@"bgColor"];
}
@end
