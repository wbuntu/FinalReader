//
//  CAWBook.h
//  CAWReader
//
//  Created by wbuntu on 12/4/15.
//  Copyright © 2015 wbuntu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAWBook : NSObject
@property(nonatomic,copy) NSNumber *bookId;                 //ID
@property(nonatomic,copy) NSString *title;                  //标题
@property(nonatomic,copy) NSString *author;                 //作者
@property(nonatomic,copy) NSString *sortlist;               //所属文库
@property(nonatomic,copy) NSString *zishu;                  //字数
@property(nonatomic,copy) NSNumber *all_sort;               //总收藏数
@property(nonatomic,copy) NSNumber *all_click;              //总点击数
@property(nonatomic,copy) NSNumber *all_suggest;            //总推荐数
@property(nonatomic,copy) NSString *last_updates;            //最后更新日期
@property(nonatomic,copy) NSString *status;                 //完结状态
@property(nonatomic,copy) NSString *summary;                //简介
@property(nonatomic,copy) NSArray<NSString *> *discuss;     //评论
- (instancetype)initWithDictionary:(NSDictionary *)dic;     //初始化方法
@end