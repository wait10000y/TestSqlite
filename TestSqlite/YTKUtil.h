//
//  YTKUtil.h
//  TestSqlite
//
//  Created by wsliang on 15/8/11.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//


#define YTK_table_name @"tyk_test_data"
#define YTK_database_name @"tyk_test.db"


#import "SqliteBaseUtil.h"
/*
 架构不同,使用单独的数据库表
 */

@interface YTKUtil : SqliteBaseUtil

+(instancetype)sharedObject;

@end
