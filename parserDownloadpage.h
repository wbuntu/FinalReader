//
//  parserDownloadpage.h
//  wenku8
//
//  Created by 武鸿帅 on 15/4/3.
//  Copyright (c) 2015年 wbuntu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface parserDownloadpage : NSObject<NSXMLParserDelegate>

@end

@interface titleAndLink : NSObject
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *link;
@property(nonatomic) int volumeId;
@end