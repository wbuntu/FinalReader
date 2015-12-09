//
//  parserSearchView.m
//  wenku8
//
//  Created by wbuntu on 15/3/21.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "parserSearchView.h"

@interface parserSearchView()
{
    NSString *currentString;
    bookElement *book;
}
@property (strong,nonatomic) NSMutableArray *indexArray;
@property (nonatomic) BOOL canWrite;
@end
@implementation parserSearchView
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    _indexArray = [[NSMutableArray alloc] init];

}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"a"]) {
        NSString *he = [attributeDict objectForKey:@"href"];
       if ([he containsString:@"articleinfo"]) {
            he = [he substringFromIndex:[he rangeOfString:@"id="].location+3];
            book = [[bookElement alloc] init];
            book.bookId=[he intValue];
            currentString=[[NSString alloc] init];
            _canWrite=YES;
        }
    }
    
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_canWrite) {
        currentString = [currentString stringByAppendingString:string];
    }
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (_canWrite)
    {
        _canWrite=NO;
//        if(_isSearchView)
//        {
            NSRange ra1 = [currentString rangeOfString:@"《"];
            NSRange ra2 = [currentString rangeOfString:@"》"];
            currentString = [currentString substringWithRange:NSMakeRange(ra1.location+1, ra2.location-ra1.location-1)];
//        }
        book.bookTitle=currentString;
        [_indexArray addObject:book];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (_isSearchView) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchViewParseCompleted" object:_indexArray];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"morePageParseComplete" object:_indexArray];
    }
}
@end
