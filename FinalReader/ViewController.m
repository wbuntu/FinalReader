//
//  ViewController.m
//  pageProject
//
//  Created by 武鸿帅 on 15/4/26.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong) NSLayoutManager *textLayout;
@property(nonatomic,strong) UITextView *textView;
@property(nonatomic,strong) NSString *aText;
@property(nonatomic,assign) NSInteger totalPage;
@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,assign) CGRect viewRect;
@property(nonatomic,strong) UIActivityIndicatorView *indicator;
@end

@implementation ViewController
//container 310 560
//textview 310 568
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:[UIColor colorWithRed:249.0/255 green:234.0/255 blue:188.0/255 alpha:1]];
    
    _indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-40, CGRectGetMidY(self.view.frame)-40, 80, 80)];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:_indicator];
    [_indicator startAnimating];
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        _aText = [[NSString alloc] initWithContentsOfFile:_path encoding:gbk error:nil];
        
        NSAttributedString *textString =  [[NSAttributedString alloc] initWithString:_aText attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]                                                                                                                                 }];
        
        NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:textString];
        _textLayout = [[NSLayoutManager alloc] init];
        [textStorage addLayoutManager:_textLayout];
        //设定textviewrect
        _viewRect = CGRectMake(5, 0, CGRectGetWidth(self.view.bounds)-10, CGRectGetHeight(self.view.bounds));
        //设定container的size 宽相等，高减8
        CGSize screenSize = CGSizeMake(_viewRect.size.width, _viewRect.size.height-8);
        
        NSTextContainer *atextContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(screenSize.width, MAXFLOAT)];
        [_textLayout addTextContainer:atextContainer];
        float textViewHeight1 = [_textLayout boundingRectForGlyphRange:NSMakeRange(0, _aText.length) inTextContainer:atextContainer].size.height;
        [_textLayout removeTextContainerAtIndex:0];
        
        NSTextContainer *atextContainer1 = [[NSTextContainer alloc] initWithSize:screenSize];
        [_textLayout addTextContainer:atextContainer1];
        float textViewHeight2 = [_textLayout boundingRectForGlyphRange:NSMakeRange(0, _aText.length) inTextContainer:atextContainer1].size.height;
        [_textLayout removeTextContainerAtIndex:0];
        //    NSLog(@"%f",textViewHeight2);
        //    textViewHeight2=floorf(textViewHeight2);
        //    NSLog(@"%f",textViewHeight2);
        
        int count = textViewHeight1/textViewHeight2+1;
        _totalPage=count;
        //    NSLog(@"%d",count);
        int i=0;
        while (i<count) {
            NSTextContainer *atextContainer3 = [[NSTextContainer alloc] initWithSize:screenSize];
            [_textLayout addTextContainer:atextContainer3];
            i++;
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSTextContainer *atextContainer3 = [_textLayout.textContainers firstObject];
            _textView = [[UITextView alloc] initWithFrame:_viewRect textContainer:atextContainer3];
            
            [_textView setBackgroundColor:[UIColor colorWithRed:249.0/255 green:234.0/255 blue:188.0/255 alpha:1]];
            [_textView setUserInteractionEnabled:NO];
            [self.view addSubview:_textView];
            _currentPage=0;
            //    NSLog(@"%@",_textView.textContainer);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelector:)];
            [self.view addGestureRecognizer:tap];
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSelector:)];
            pan.delegate=self;
            [self.view addGestureRecognizer:pan];
            [_indicator stopAnimating];
        });
    });
    
    
}
-(void)panSelector:(UIPanGestureRecognizer*)pan
{
//    CGPoint p = [pan locationInView:self.view];
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        CGPoint p = [gestureRecognizer locationInView:self.view];
        NSLog(@"%f %f",p.x,p.y);
    }
    return YES;
}
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
//    {
//        CGPoint p = [gestureRecognizer locationInView:self.view];
//        NSLog(@"%f %f",p.x,p.y);
//    }
//    return YES;
//}
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
//    {
//        CGPoint p = [touch locationInView:self.view];
//        NSLog(@"%f %f",p.x,p.y);
//    }
//    return YES;
//}
-(void)tapSelector:(UITapGestureRecognizer*)tap
{
    CGPoint center = self.view.center;
    CGPoint p = [tap locationInView:self.view];
    if (p.x>center.x+50) {
        if (!(_currentPage==_totalPage-1))
        {
            _currentPage++;
            [_textView removeFromSuperview];
            _textView = [[UITextView alloc] initWithFrame:_viewRect textContainer:[_textLayout.textContainers objectAtIndex:_currentPage]];
            [_textView setBackgroundColor:[UIColor colorWithRed:249.0/255 green:234.0/255 blue:188.0/255 alpha:1]];
            [_textView setUserInteractionEnabled:NO];
            [self.view addSubview:_textView];
        }
    }
    else if(p.x<center.x-50)
    {
        if (!(_currentPage==0)) {
            _currentPage--;
            _currentPage=(_currentPage>0)?_currentPage--:_currentPage;
            [_textView removeFromSuperview];
            _textView = [[UITextView alloc] initWithFrame:_viewRect textContainer:[_textLayout.textContainers objectAtIndex:_currentPage]];
            [_textView setBackgroundColor:[UIColor colorWithRed:249.0/255 green:234.0/255 blue:188.0/255 alpha:1]];
            [_textView setUserInteractionEnabled:NO];
            [self.view addSubview:_textView];
        }
        
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            BOOL isHidedn = !self.navigationController.isNavigationBarHidden;
            [self.navigationController setNavigationBarHidden:isHidedn animated:YES];
            _isHidden=!_isHidden;
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *t = [touches anyObject];
//    CGPoint p = [t locationInView:self.view];
//    CGPoint center = self.view.center;
//    if (p.x>center.x+50) {
//        if (!(_currentPage==_totalPage-1))
//        {
//            _currentPage++;
//            [_textView removeFromSuperview];
//            _textView = [[UITextView alloc] initWithFrame:_viewRect textContainer:[_textLayout.textContainers objectAtIndex:_currentPage]];
//            [_textView setBackgroundColor:[UIColor colorWithRed:249.0/255 green:234.0/255 blue:188.0/255 alpha:1]];
//            [_textView setUserInteractionEnabled:NO];
//            [self.view addSubview:_textView];
//        }
//    }
//    else if(p.x<center.x-50)
//    {
//        if (!(_currentPage==0)) {
//            _currentPage--;
//            _currentPage=(_currentPage>0)?_currentPage--:_currentPage;
//            [_textView removeFromSuperview];
//            _textView = [[UITextView alloc] initWithFrame:_viewRect textContainer:[_textLayout.textContainers objectAtIndex:_currentPage]];
//            [_textView setBackgroundColor:[UIColor colorWithRed:249.0/255 green:234.0/255 blue:188.0/255 alpha:1]];
//            [_textView setUserInteractionEnabled:NO];
//            [self.view addSubview:_textView];
//        }
//        
//    }
//    else
//    {
//        [UIView animateWithDuration:0.2 animations:^{
//            BOOL isHidedn = !self.navigationController.isNavigationBarHidden;
//            [self.navigationController setNavigationBarHidden:isHidedn animated:YES];
//            _isHidden=!_isHidden;
//            [self setNeedsStatusBarAppearanceUpdate];
//        }];
//    }
//}
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *t = [touches anyObject];
//    CGPoint p = [t locationInView:self.view];
//    NSLog(@"%f %f",p.x,p.y);
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    float textViewHeight = [_textLayout usedRectForTextContainer:_textView.textContainer].size.height;
    NSLog(@"%f",textViewHeight);
}
-(BOOL)prefersStatusBarHidden
{
    return _isHidden;
}
@end
