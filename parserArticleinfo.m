//
//  paserArticleinfo.m
//  wenku8
//
//  Created by 武鸿帅 on 15/3/23.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//
#import "parserArticleinfo.h"
@interface parserArticleinfo()
{
    NSString *currentString;
}
@property (nonatomic,strong) NSString *intro;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *classType;
@end
@implementation parserArticleinfo
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    currentString=[[NSString alloc] init];
//    NSLog(@"start");
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    currentString = [currentString stringByAppendingString:string];
//    NSLog(@"%@",string);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
//    NSLog(@"%@",currentString);
    NSRange ra1 = [currentString rangeOfString:@"作者:"];
    NSRange ra2 = [currentString rangeOfString:@"类别"];
    NSRange ra = NSMakeRange(ra1.location+3, ra2.location-ra1.location-3);
    _author = [currentString substringWithRange:ra];
    
    ra1 = [currentString rangeOfString:@"[作品简介]"];
    ra2 = [currentString rangeOfString:@"联系管理员"];
    ra = NSMakeRange(ra1.location+6, ra2.location-ra1.location-6);
    _intro = [currentString substringWithRange:ra];
    
    ra1 = [currentString rangeOfString:@"类别:"];
    ra2 = [currentString rangeOfString:@"状态:"];
    ra = NSMakeRange(ra1.location+3, ra2.location-ra1.location-3);
    _classType = [currentString substringWithRange:ra];
    CGSize labelSize = [_intro boundingRectWithSize:CGSizeMake(304, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    labelSize.height=ceilf(labelSize.height);
    NSNumber *height = [NSNumber numberWithFloat:labelSize.height];
    NSDictionary *dic = @{@"author":_author,
                          @"classType":_classType,
                          @"intro":_intro,
                          @"height":height};
    //NSDictionary *dic = @{@"键":@"值",@"键1":@"值1"};
    //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
//                   my1, @"my1",
//                   my2, @"my2",
//                   my3, @"my3",
//                   my4, @"my4", nil]; 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"articleinfoParseCompleted" object:dic];
}

@end

