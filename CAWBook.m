//
//  CAWBook.m
//  CAWReader
//
//  Created by wbuntu on 12/4/15.
//  Copyright © 2015 wbuntu. All rights reserved.
//

#import "CAWBook.h"

@implementation CAWBook

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _bookId = dic[@"id"];
        _title = dic[@"title"];
        _author = dic[@"author"];
        _sortlist = dic[@"sortlist"];
        _zishu = dic[@"zishu"];
        _all_sort = dic[@"all_sort"];
        _all_click = dic[@"all_click"];
        _all_suggest = dic[@"all_suggest"];
        _last_updates = dic[@"last_updates"];
        _status = dic[@"status"];
        _summary = dic[@"summary"];
        _discuss  = dic[@"discuss"];
/*
 "author": "\u6850\u6708",
 "id": 1899,
 "length": 1,
 "newest_chapter": "\u540e\u8bb0",
 "newest_chapter_url": "http://xs.dmzj.com/1899/6949/50573.shtml",
 "publish_time": "2015-06-08 00:00:00",
 "status": "\u8fde\u8f7d\u4e2d ",
 "style": "\u6821\u56ed ",
 "summary": "\u590f\u2014\u2014\u5728\u7fa4\u5c71\u73af\u7ed5\u7684\u5fa1\u5948\u795e\u6751\uff0c\u53d1\u751f\u4e86\u52a8\u7269\u7684\u96c6\u4f53\u66b4\u52a8\uff0c\u8fd9\u4e8b\u4ef6\u662f\u300e\u5929\u5973\u300f\u7684\u9053\u5177\u6240\u5f15\u8d77\u7684\u3002\u8eab\u4e3a\u5929\u5973\u5b50\u5b59\u7684\u7686\u795e\u5b5d\u4ecb\u4e0e\u54b2\u591c\u5144\u59b9\u89e3\u51b3\u4e86\u8fd9\u8d77\u4e8b\u4ef6\uff0c\u5e76\u786e\u5b9a\u4e86\u5bf9\u5f7c\u6b64\u7684\u5fc3\u610f\u3002\n\u5b63\u8282\u6765\u5230\u4e86\u51ac\u5929\u3002\u5b5d\u4ecb\u548c\u54b2\u591c\u5404\u81ea\u56de\u5230\u5927\u5b66\u4e0e\u5b66\u56ed\u5ea6\u8fc7\u65e5\u5e38\u751f\u6d3b\uff0c\u4f46\u54b2\u591c\u5c31\u8bfb\u7684\u5b66\u56ed\u5c31\u5728\u6b64\u65f6\u53d1\u751f\u4e86\u548c\u590f\u5b63\u90a3\u4ef6\u4e8b\u76f8\u4eff\u7684\u602a\u5f02\u4e8b\u4ef6\uff0c\u4e24\u4eba\u65e0\u6cd5\u7f6e\u4e4b\u4e0d\u7406\u2014\u2014\n\u77e5\u540dGALGAME\u300c\u9ec4\u660f\u7684\u7981\u5fcc\u4e4b\u836f\u300d\u6539\u7f16\u4e4b\u8f7b\u5c0f\u8bf4\u3002",
 "title": "\u9ec4\u660f\u7684\u7981\u5fcc\u4e4b\u836f\uff5e\u4ece\u679d\u53f6\u95f4\u6d12\u843d\u7684\u51ac\u9633\uff5e",
 "update_time": "2015-06-08 21:07:45"
*/
    }
    return self;
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"\n \
            bookId:%@\n\
            title:%@\n\
            author:%@\n\
            sortlist:%@\n\
            zishu:%@\n\
            all_sort:%@\n\
            all_click:%@\n\
            all_suggest:%@\n\
            last_updates:%@\n\
            status:%@\n\
            summary:%@\n\
            discuss:%@\n",_bookId,_title,_author,_sortlist,_zishu,_all_sort,_all_click,_all_suggest,_last_updates,_status,_summary,_discuss];
}
@end
