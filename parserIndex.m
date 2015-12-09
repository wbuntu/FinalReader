//
//  paserIndex.m
//  wenku8
//
//  Created by wbuntu on 15/3/21.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "parserIndex.h"

@interface parserIndex()
{
    NSString *currentString;
    NSMutableArray *currentArray;
    bookElement *book;
}
@property (strong,nonatomic) NSMutableArray *indexArray1;
@property (strong,nonatomic) NSMutableArray *indexArray2;
@property (strong,nonatomic) NSMutableArray *indexArray3;
@property (strong,nonatomic) NSMutableArray *indexArray4;
@property (nonatomic) BOOL canWrite;
@end
@implementation parserIndex
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //NSLog(@"start paersing");
    _indexArray1 = [[NSMutableArray alloc] init];
    _indexArray2 = [[NSMutableArray alloc] init];
    _indexArray3 = [[NSMutableArray alloc] init];
    _indexArray4 = [[NSMutableArray alloc] init];
    currentArray=_indexArray1;
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
    if ([string isEqualToString:@"【最近更新】"]) {
        currentArray=_indexArray2;
    }
    else if ([string isEqualToString:@"【新书风云榜】"])
    {
        currentArray=_indexArray3;
    }
    else if ([string isEqualToString:@"【每周书单】"])
    {
        currentArray=_indexArray4;
    }
    if (_canWrite) {
        currentString = [currentString stringByAppendingString:string];
    }
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (_canWrite)
    {
        _canWrite=NO;
        //NSLog(@"%@,%@",currentString,currentArray);
        book.bookTitle=currentString;
        [currentArray addObject:book];
       // NSLog(@"%d %@",book.bookId,book.bookTitle);
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
//    NSLog(@"\n%@ %d\n%@ %d\n%@ %d\n%@ %d\n",_indexArray1,_indexArray1.count,_indexArray2,_indexArray2.count,_indexArray3,_indexArray3.count,_indexArray4,_indexArray4.count);
    NSArray *indexArray=@[_indexArray1,_indexArray2,_indexArray3,_indexArray4];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"indexParseCompleted" object:indexArray];
}
@end
