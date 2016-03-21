//
//  FMDBTools.m
//  CarRadius
//
//  Created by Lzq on 16/2/22.
//  Copyright © 2016年 Lzq. All rights reserved.
//

#import "FMDBTools.h"
#import "FMDB.h"
#import "SearchModel.h"

@implementation FMDBTools
{
    FMDatabase *database;
}

+ (instancetype)shareManageDate
{
    static FMDBTools *fmdbTools  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         fmdbTools = [[FMDBTools alloc]init];
    
    });
    return fmdbTools;
}


- (void)creatSearchHistory
{
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *dbpath  =[path stringByAppendingPathComponent:@"carRadius.db"];
    NSLog(@"数据库路径地址 %@",dbpath);
    database=[FMDatabase databaseWithPath:dbpath];
    if (![database open]) {
        NSLog(@"数据库打开失败");
    }
    //建立yi个列 对应你的model
    BOOL result =  [database  executeUpdate:@"create table searchHistory (title text)"];
    if (result == YES) {
        //  [[NSUserDefaults standardUserDefaults]setObject:@"y" forKey:@"isHave"];
        //  UIAlertView *alter =[[UIAlertView alloc] initWithTitle:@"提示" message:@"创建表成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //   [alter show];
        NSLog(@"创建表成功");
    }

}

#pragma mark 名字相同的话就不插入了
- (void)insertSearchDate:(SearchModel *)model
{
    
    
    NSMutableArray *array = [self selectAllHistory];
    if (array.count == 0) {
        BOOL insert  =[database executeUpdate:@"insert into searchHistory values (?)",model.title];
        if (insert) {
            NSLog(@"数据保存成功");
        }
        else{
            NSLog(@"数据保存失败");
        }

    }
    else{
    for (SearchModel *nowModel in array) {
        if (![model.title isEqualToString:nowModel.title]) {
            BOOL insert  =[database executeUpdate:@"insert into searchHistory values (?)",model.title];
            if (insert) {
                NSLog(@"数据保存成功");
            }
            else{
                NSLog(@"数据保存失败");
            }

        }
    }
    }

}
- (NSMutableArray *)selectAllHistory
{
    NSMutableArray *allArray = [NSMutableArray array];
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *dbpath =[path stringByAppendingPathComponent:@"carRadius.db"];
    database=[FMDatabase databaseWithPath:dbpath];
    if (![database open]) {
        NSLog(@"数据库打开失败");
    }
    FMResultSet *result =[database executeQuery:@"select * from searchHistory"];
    while ([result next]) {
        SearchModel *model = [[SearchModel alloc]init];

        model.title = [result stringForColumn:@"title"];

        [allArray addObject:model];
    }
    return allArray;

}
- (void)deleteHistoryTable
{
    NSString *documentpath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0 ];
    NSString *dbpath=[documentpath stringByAppendingPathComponent:@"carRadius.db"];
    
    database=[FMDatabase databaseWithPath:dbpath];
    if (![database open]) {
        NSLog(@"数据库打开失败");
    }
    //NSNumber *agenumber =[NSNumber numberWithInt:23];
    BOOL update = [database executeUpdate:@"delete from searchHistory"];
    if(update){
        NSLog(@"数据删除成功");
    }else{
        NSLog(@"数据删除失败");
    }
    

}


- (void)closeDB
{
    
    [database close];
}




@end
