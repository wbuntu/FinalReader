//
//  CAWThemeManager.h
//  CAWReader
//
//  Created by wbuntu on 11/26/15.
//  Copyright © 2015 wbuntu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,CAWThemeType) {
    //pure background color
    CAWThemeTypePure_1,
    CAWThemeTypePure_2,
    CAWThemeTypePure_3,
    CAWThemeTypePure_4,
    CAWThemeTypePure_5,
    CAWThemeTypePure_6,
    CAWThemeTypePure_7,
    CAWThemeTypePure_8,
    CAWThemeTypePure_9,
    CAWThemeTypePure_10,
    CAWThemeTypePure_11,
    CAWThemeTypePure_12,
    //complex background color
    CAWThemeTypeComplexDefult,
    CAWThemeTypeDefault = CAWThemeTypeComplexDefult,
    CAWThemeTypeComplex_1,
    CAWThemeTypeComplex_2,
    CAWThemeTypeComplex_3,
    CAWThemeTypeComplex_4,
    CAWThemeTypeComplex_5,
};
@class CAReaderVC;
@interface CAWThemeManager : NSObject
+ (NSArray<UIColor *> *)colorArray;
+ (void)changeCAWTextView:(CAReaderVC *)textView toTheme:(CAWThemeType)theme;
@end






















