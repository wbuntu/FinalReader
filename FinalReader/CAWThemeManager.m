//
//  CAWThemeManager.m
//  CAWReader
//
//  Created by wbuntu on 11/26/15.
//  Copyright © 2015 wbuntu. All rights reserved.
//

#import "CAWThemeManager.h"
#import "CAReaderVC.h"

static NSString *pure_1 = @"254,255,255|0,0,0|180,181,181";
static NSString *pure_2 = @"239,236,226|59,56,45|168,165,155";
static NSString *pure_3 = @"227,215,190|57,49,35|174,163,144";
static NSString *pure_4 = @"219,211,197|42,42,38|166,160,152";
static NSString *pure_5 = @"163,164,165|28,29,30|123,124,125";
static NSString *pure_6 = @"0,0,0|117,118,119|73,74,75";
static NSString *pure_7 = @"223,233,204|67,70,59|177,185,164";
static NSString *pure_8 = @"198,237,205|62,78,58|150,179,156";
static NSString *pure_9 = @"51,82,76|155,170,166|98,122,118";
static NSString *pure_10 = @"39,60,52|173,198,181|98,118,110";
static NSString *pure_11 = @"38,53,73|177,187,197|102,112,128";
static NSString *pure_12 = @"90,66,44|170,160,150|129,108,92";

static NSString *complex_default = @"52,49,42|150,123,89";
static NSString *complex_1 = @"complex_bg_1.png|62,63,64|181,182,182";
static NSString *complex_2 = @"complex_bg_2.png|54,59,51|162,156,132";
static NSString *complex_3 = @"complex_bg_3.png|52,55,46|144,149,120";
static NSString *complex_4 = @"complex_bg_4.png|53,48,44|145,131,111";
static NSString *complex_5 = @"complex_bg_5.png|207,208,209|112,117,121";

@implementation CAWThemeManager
+ (void)changeCAWTextView:(CAReaderVC *)textView toTheme:(CAWThemeType)theme
{
    switch (theme) {
            //pure option
            //fill background with pure color
        case CAWThemeTypePure_1:
            [self changeTextView:textView withPureOptionString:pure_1];
            break;
        case CAWThemeTypePure_2:
            [self changeTextView:textView withPureOptionString:pure_2];
            break;
        case CAWThemeTypePure_3:
            [self changeTextView:textView withPureOptionString:pure_3];
            break;
        case CAWThemeTypePure_4:
            [self changeTextView:textView withPureOptionString:pure_4];
            break;
        case CAWThemeTypePure_5:
            [self changeTextView:textView withPureOptionString:pure_5];
            break;
        case CAWThemeTypePure_6:
            [self changeTextView:textView withPureOptionString:pure_6];
            break;
        case CAWThemeTypePure_7:
            [self changeTextView:textView withPureOptionString:pure_7];
            break;
        case CAWThemeTypePure_8:
            [self changeTextView:textView withPureOptionString:pure_8];
            break;
        case CAWThemeTypePure_9:
            [self changeTextView:textView withPureOptionString:pure_9];
            break;
        case CAWThemeTypePure_10:
            [self changeTextView:textView withPureOptionString:pure_10];
            break;
        case CAWThemeTypePure_11:
            [self changeTextView:textView withPureOptionString:pure_11];
            break;
        case CAWThemeTypePure_12:
            [self changeTextView:textView withPureOptionString:pure_12];
            break;
            
            //complex option
            //fill background with a pic
        case CAWThemeTypeComplexDefult:
            [self changeTextView:textView withComplexDefaultOptionString:complex_default];
            break;
        case CAWThemeTypeComplex_1:
            [self changeTextView:textView withComplexOptionString:complex_1];
            break;
        case CAWThemeTypeComplex_2:
            [self changeTextView:textView withComplexOptionString:complex_2];
            break;
        case CAWThemeTypeComplex_3:
            [self changeTextView:textView withComplexOptionString:complex_3];
            break;
        case CAWThemeTypeComplex_4:
            [self changeTextView:textView withComplexOptionString:complex_4];
            break;
        case CAWThemeTypeComplex_5:
            [self changeTextView:textView withComplexOptionString:complex_5];
            break;
    }
}
//draw pure bg
+ (void)changeTextView:(CAReaderVC *)textView withPureOptionString:(NSString *)optionStr
{
    NSArray<NSString *> *optionArray = [optionStr componentsSeparatedByString:@"|"];

    UIColor *color = [self RGBColorWithColorStr:optionArray[0]];
    CGRect rect = [UIScreen mainScreen].bounds;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx,rect);
    textView.view.layer.contents = (__bridge id _Nullable)CGBitmapContextCreateImage(ctx);
    UIGraphicsEndImageContext();
    
    textView.fontColor = [self RGBColorWithColorStr:optionArray[1]];
}
//draw complex bg
+ (void)changeTextView:(CAReaderVC *)textView withComplexOptionString:(NSString *)optionStr
{
    NSArray<NSString *> *optionArray = [optionStr componentsSeparatedByString:@"|"];
    UIImage *backgroundImage = [UIImage imageNamed:optionArray[0]];
    CGRect rect = [UIScreen mainScreen].bounds;
    CGRect imageRect = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawTiledImage(ctx, imageRect, backgroundImage.CGImage);
    textView.view.layer.contents = (__bridge id _Nullable)CGBitmapContextCreateImage(ctx);
    UIGraphicsEndImageContext();
    textView.fontColor = [self RGBColorWithColorStr:optionArray[1]];
}


//draw even complex bg
+ (void)changeTextView:(CAReaderVC *)textView withComplexDefaultOptionString:(NSString *)optionStr
{
        CGRect rect = [UIScreen mainScreen].bounds;
        UIImage *border = [UIImage imageNamed:@"border.png"];
        UIImage *p1 = [UIImage imageNamed:@"parchment1.png"];
        UIImage *p2 = [UIImage imageNamed:@"parchment2.png"];
        UIImage *p3 = [UIImage imageNamed:@"parchment3.png"];
        int imLenth = p1.size.height;
        int height = rect.size.height;
        int width  = rect.size.width;
        NSArray<UIImage *> *images = @[p1,p2,p3];
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        for (int i = 0,i_1=0; i_1 < width; i++,i_1+= imLenth) {
            for (int j = 0,j_1=0; j_1 < height; j++,j_1+= imLenth ) {
                int temp = rand()%3;
                CGRect tempRect =  CGRectMake(i*imLenth, j*imLenth, imLenth, imLenth);
                CGContextDrawImage(ctx, tempRect, images[temp].CGImage);
            }
        }
    
        CGContextDrawImage(ctx, rect, border.CGImage);
        textView.view.layer.contents = (__bridge id _Nullable)CGBitmapContextCreateImage(ctx);
        UIGraphicsEndImageContext();
    NSArray<NSString *> *optionArray = [optionStr componentsSeparatedByString:@"|"];
    textView.fontColor = [self RGBColorWithColorStr:optionArray[0]];
}
+ (NSArray<UIColor *> *)colorArray
{
    NSArray *arr = @[pure_1,pure_2,pure_3,pure_4,pure_5,pure_6,pure_7,pure_8,pure_9,pure_10,pure_11,pure_12];
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSString *optionStr in arr) {
        NSArray<NSString *> *optionArray = [optionStr componentsSeparatedByString:@"|"];
        UIColor *color = [self RGBColorWithColorStr:optionArray[0]];
        [mArr addObject:color];
    }
    UIColor *tempColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"parchment1.png"]];
    [mArr addObject:tempColor];
    NSArray *otherBg = @[complex_1,complex_2,complex_3,complex_4,complex_5];
    for (NSString *optionStr in otherBg) {
        NSArray<NSString *> *optionArray = [optionStr componentsSeparatedByString:@"|"];
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:optionArray[0]]];
        [mArr addObject:color];
    }
    return mArr;
}
+ (UIColor *)RGBColorWithColorStr:(NSString *)colorStr
{
    NSArray *arr = [colorStr componentsSeparatedByString:@","];
    CGFloat red = [arr[0] integerValue]/255.0;
    CGFloat green = [arr[1] integerValue]/255.0;
    CGFloat blue = [arr[2] integerValue]/255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    return color;
}

@end
