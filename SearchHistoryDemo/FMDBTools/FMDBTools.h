//
//  FMDBTools.h
//  CarRadius
//
//  Created by Lzq on 16/2/22.
//  Copyright © 2016年 Lzq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchModel;
@interface FMDBTools : NSObject

#pragma mark 建一个搜索历史的表
+ (instancetype)shareManageDate;
- (void)creatSearchHistory;
- (void)insertSearchDate:(SearchModel *)model;
- (NSMutableArray *)selectAllHistory;
- (void)deleteHistoryTable;


- (void)closeDB;

@end
