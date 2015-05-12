//
//  parserDownloadpage.m
//  wenku8
//
//  Created by 武鸿帅 on 15/4/3.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "parserDownloadpage.h"

@interface parserDownloadpage ()
{
    NSString *fullString;
    NSMutableArray *linkArray;
}

@end

@implementation parserDownloadpage
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    fullString=[[NSString alloc] init];
    linkArray = [NSMutableArray new];
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"a"]) {
        NSString *he = [attributeDict objectForKey:@"href"];
        if ([he hasSuffix:@"gbk"]) {
            [linkArray addObject:he];
//            NSLog(@"%d",[he substringFromIndex:[he rangeOfString:@"vid="].location+4].intValue);
        }
    }
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    fullString = [fullString stringByAppendingString:string];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSString *str = @"支持相应编码";
    NSRange r1 = [fullString rangeOfString:str];
    NSRange r2 = [fullString rangeOfString:@"返回"];
    NSString *str1 = [fullString substringWithRange:NSMakeRange(r1.location+r1.length, r2.location-r1.location-r1.length)];
    NSArray *arr = [str1 componentsSeparatedByString:@"(简体(G).简体(U).繁体(U))"];
    long i=linkArray.count;
    NSMutableArray *bookArray = [[NSMutableArray alloc] initWithCapacity:i];
    for (int k=0; k<i; k++) {
        titleAndLink *TAL = [[titleAndLink alloc] init];
        TAL.title=[arr objectAtIndex:k];
        TAL.link=[linkArray objectAtIndex:k];
        TAL.volumeId=[[TAL.link substringFromIndex:[TAL.link rangeOfString:@"vid="].location+4] intValue];
        [bookArray addObject:TAL];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadpageParseComplete" object:bookArray];
}
@end

@implementation titleAndLink

@end