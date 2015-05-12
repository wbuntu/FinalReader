//
//  VolumeManager.m
//  FinalReader
//
//  Created by 武鸿帅 on 15/4/30.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import "VolumeManager.h"
@interface VolumeManager ()
@property(nonatomic,strong) NSString *documentPath;
@property(nonatomic,strong) NSFileManager *manager;
@end

@implementation VolumeManager

+(VolumeManager*)defaultManager
{
    static VolumeManager *manager =nil;
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        manager = [[VolumeManager alloc] init];
    });
    return manager;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        _documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _manager = [NSFileManager defaultManager];
        [self createDirectories];
        [self getContext];
//        NSLog(@"%@",_documentPath);
    }
    return self;
}

-(void)getContext
{
    NSString *path = [_documentPath stringByAppendingPathComponent:@"books"];
    if ([_manager fileExistsAtPath:path])
        _books = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    else
        _books = [NSMutableDictionary dictionary];
    
    path = [_documentPath stringByAppendingPathComponent:@"volumes"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path])
        _volumes = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    else
        _volumes = [NSMutableDictionary dictionary];
    
    path = [_documentPath stringByAppendingPathComponent:@"volumeInfo"];
    if ([_manager fileExistsAtPath:path])
        _volumeInfo = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    else
        _volumeInfo = [NSMutableDictionary dictionary];
    
    path = [_documentPath stringByAppendingPathComponent:@"volumeMark"];
    if ([_manager fileExistsAtPath:path])
        _volumeMark = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    else
        _volumeMark = [NSMutableDictionary dictionary];
}
-(void)saveContext
{
    [_books writeToFile:[_documentPath stringByAppendingPathComponent:@"books"] atomically:NO];
    [_volumes writeToFile:[_documentPath stringByAppendingPathComponent:@"volumes"] atomically:NO];
    [_volumeInfo writeToFile:[_documentPath stringByAppendingPathComponent:@"volumeInfo"] atomically:NO];
    [_volumeMark writeToFile:[_documentPath stringByAppendingPathComponent:@"volumeMark"] atomically:NO];
}
-(void)createDirectories
{
    if (![_manager fileExistsAtPath:[_documentPath stringByAppendingPathComponent:@"articleInfo"]]) {
        [_manager createDirectoryAtPath:[_documentPath stringByAppendingPathComponent:@"articleInfo"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![_manager fileExistsAtPath:[_documentPath stringByAppendingPathComponent:@"cover"]]) {
        [_manager createDirectoryAtPath:[_documentPath stringByAppendingPathComponent:@"cover"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![_manager fileExistsAtPath:[_documentPath stringByAppendingPathComponent:@"localfiles"]]) {
        [_manager createDirectoryAtPath:[_documentPath stringByAppendingPathComponent:@"localfiles"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
-(BOOL)saveVolume:(NSString *)volumeIdStr WithVolumeName:(NSString *)volumeName AndFileLocation:(NSURL*)location InBook:(NSString *)bookIdStr WithBookName:(NSString *)bookName isAdded:(BOOL)isAdded
{
    NSString *path = [_documentPath stringByAppendingPathComponent:@"localfiles"];
    path = [path stringByAppendingPathComponent:volumeIdStr];
    NSData *data = [NSData dataWithContentsOfURL:location];
    if ([data writeToFile:path atomically:NO])
    {
        if (!isAdded)//若不存在，就添加book
        {
            [_books setObject:bookName forKey:bookIdStr];
            NSMutableArray *volumeArray = [NSMutableArray array];
            [_volumes setObject:volumeArray forKey:bookIdStr];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"booksChanged" object:nil];
        }
        NSMutableArray *volumeArray = [_volumes objectForKey:bookIdStr];
        [volumeArray addObject:volumeIdStr];
        [_volumeInfo setObject:volumeName forKey:volumeIdStr];
        [self saveContext];
        return YES;
    }
    return NO;
}
-(void)isVolume:(NSString *)volumeIdStr InBook:(NSString *)bookIdStr ExistInCell:(downloadpageTableViewCell*)cell
{
    NSMutableArray *volumeArray = [_volumes objectForKey:bookIdStr];
    if (volumeArray!=nil)
    {
        cell.isAdded=YES;
        if ([volumeArray containsObject:volumeIdStr])
        {
            cell.isDownloaded=YES;
        }
        else
            cell.isDownloaded=NO;
    }
    else
        cell.isAdded=NO;
}
-(void)removeVolume:(NSString *)volumeIdStr InBook:(NSString *)bookIdStr
{
        NSMutableArray *volumeArrayOriginal = [_volumes objectForKey:bookIdStr];
        [volumeArrayOriginal removeObject:volumeIdStr];
        [_volumeInfo removeObjectForKey:volumeIdStr];
        [_volumeMark removeObjectForKey:volumeIdStr];
        [_manager removeItemAtPath:[_documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"localfiles/%d",volumeIdStr.intValue]] error:nil];
        if (volumeArrayOriginal.count==0)//books发生变化
        {
            [_books removeObjectForKey:bookIdStr];
            [_volumes removeObjectForKey:bookIdStr];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"booksChanged" object:nil];
        }
}
-(void)removeBook:(NSString *)bookIdStr
{
    NSString *localfiles = [_documentPath stringByAppendingPathComponent:@"localfiles"];
    NSMutableArray *volumeArrayOriginal = [_volumes objectForKey:bookIdStr];
    for (NSString *volumeIdStr in volumeArrayOriginal)
    {
        [_manager removeItemAtPath:[localfiles stringByAppendingPathComponent:volumeIdStr] error:nil];
        [_volumeInfo removeObjectForKey:volumeIdStr];
        [_volumeMark removeObjectForKey:volumeIdStr];
    }
    [_books removeObjectForKey:bookIdStr];
    [_volumes removeObjectForKey:bookIdStr];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VolumeAdded" object:nil];
}
@end
