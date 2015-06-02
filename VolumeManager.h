//
//  VolumeManager.h
//  FinalReader
//
//  Created by 武鸿帅 on 15/4/30.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "downloadpageTableViewCell.h"
@interface VolumeManager : NSObject
@property(nonatomic,strong) NSMutableDictionary *books;//bookid--bookName
@property(nonatomic,strong) NSMutableDictionary *volumes;//bookid--volumeArray->volumeId
@property(nonatomic,strong) NSMutableDictionary *volumeInfo;//volumeId--volumeName
@property(nonatomic,strong) NSMutableDictionary *volumeMark;//volumeId--currentPage
-(void)saveContext;
-(BOOL)saveVolume:(NSString *)volumeIdStr WithVolumeName:(NSString *)volumeName AndFileLocation:(NSURL*)location InBook:(NSString *)bookIdStr WithBookName:(NSString *)bookName isAdded:(BOOL)isAdded;
-(void)isVolume:(NSString *)volumeIdStr InBook:(NSString *)bookIdStr ExistInCell:(downloadpageTableViewCell*)cell;
-(void)removeVolume:(NSString *)volumeIdStr InBook:(NSString *)bookIdStr;
-(void)removeBook:(NSString *)bookIdStr;
-(void)addBookmarkWithBookId:(NSString*)volumeIdStr AndCurrntPage:(NSInteger)page;
+(VolumeManager*)defaultManager;
@end
