//
//  SqliteUtil.m
//  TestSqlite
//
//  Created by wsliang on 15/6/23.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "SqliteUtil.h"
#import <sqlite3.h>


@implementation SqliteUtil
{
sqlite3 *db;
}

+(instancetype)sharedObject
{
  static SqliteUtil *staticObject;
  if (!staticObject) {
    staticObject = [[SqliteUtil alloc] init];
  }
  return staticObject;
}


-(BOOL)openDB
{
  NSString *path = [self findDefaultPath];
  //文件管理器
  NSFileManager *fileManager = [NSFileManager defaultManager];
  //判断数据库是否存在
  BOOL find = [fileManager fileExistsAtPath:path];
  
  //如果数据库存在，则用sqlite3_open直接打开（不要担心，如果数据库不存在sqlite3_open会自动创建）
  if (find) {
    NSLog(@"Database file have already existed.");
    //打开数据库，这里的[path UTF8String]是将NSString转换为C字符串，因为SQLite3是采用可移植的C(而不是
    //Objective-C)编写的，它不知道什么是NSString.
    if(sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
      
      //如果打开数据库失败则关闭数据库
      sqlite3_close(db);
      NSLog(@"Error: open database file.");
      return NO;
    }
    return YES;
  }
  //如果发现数据库不存在则利用sqlite3_open创建数据库（上面已经提到过），与上面相同，路径要转换为C字符串
  if(sqlite3_open([path UTF8String], &db) == SQLITE_OK) {
    return YES;
  } else {
    //如果创建并打开数据库失败则关闭数据库
    sqlite3_close(db);
    NSLog(@"Error: open database file.");
    return NO;
  }
  return NO;
}

-(BOOL)closeDB
{
  if (db) {
    //如果打开数据库失败则关闭数据库
    sqlite3_close(db);
  }
  db = nil;
  return YES;
}

-(BOOL)clearDB
{
  [self closeDB];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  return [fileManager removeItemAtPath:[self findDefaultPath] error:nil];
  return YES;
}

-(id)executeQuery:(NSString *)theSql
{
  //这句是大家熟悉的SQL语句
  
  const char *sql = [theSql UTF8String];
//  "create table if not exists testTable(ID INTEGER PRIMARY KEY AUTOINCREMENT, testID int,testValue text,testName text)";// testID是列名，int 是数据类型，testValue是列名，text是数据类型，是字符串类型
  
  sqlite3_stmt *statement;
  //sqlite3_prepare_v2 接口把一条SQL语句解析到statement结构里去. 使用该接口访问数据库是当前比较好的的一种方法
  NSInteger sqlReturn = sqlite3_prepare_v2(db, sql, -1, &statement, nil);
  //如果SQL语句解析出错的话程序返回
  if(sqlReturn != SQLITE_OK) {
    NSLog(@"Error: failed to prepare statement:create test table");
    return @(NO);
  }
  
//执行SQL语句
//  int success = sqlite3_step(statement);
//  if ( success != SQLITE_DONE) {
//    return @(NO);
//  }
  BOOL success = false;
  NSArray *array = [self findStatementDataList:statement isOK:&success];
  sqlite3_finalize(statement);
  if (array.count>0) {
    return array;
  }else{
    return @(success);
  }
}

-(NSArray*)listItemAllForTable:(NSString*)theName
{
  
  sqlite3_stmt *statement = nil;
  //sql语句
  NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ ",theName];
  const char *sql = [sqlStr UTF8String];
  
  if (sqlite3_prepare_v2(db, sql, -1, &statement, NULL) != SQLITE_OK) {
    NSLog(@"Error: failed to prepare statement with message:get testValue.");
    return NO;
  }

//  NSUInteger num_cols = (NSUInteger)sqlite3_data_count(statement);
  
  BOOL success = false;
  NSArray *array = [self findStatementDataList:statement isOK:&success];
  sqlite3_finalize(statement);
  
  return array;
}

-(NSDictionary*)selectItem:(int)theId forTable:(NSString*)theName
{
  NSString *sql =[NSString stringWithFormat:@"select * from %@ where id=%d ",theName,theId];
  NSArray *array = [self executeQuery:sql];
  if ([array isKindOfClass:[NSArray class]]) {
    return array[0];
  }else{
    return (NSDictionary*)array;
  }
}

-(BOOL)deleteItemWithId:(int)theId forTable:(NSString*)theName
{
  NSString *sql =[NSString stringWithFormat:@"delete from %@ where id=%d ",theName,theId];
  NSNumber *result = [self executeQuery:sql];
  if ([result isKindOfClass:[NSNumber class]]) {
    return [result boolValue];
  }
  return YES;
}

-(BOOL)updateItem:(int)theId withData:(NSDictionary*)theData forTable:(NSString*)tableName
{
  NSMutableString *updateSql = [NSMutableString new];
  [updateSql appendFormat:@"UPDATE %@ SET ",tableName];
  for (NSString *itemKey in theData.allKeys) {
    NSObject *item = [theData valueForKey:itemKey];
    if ([item isKindOfClass:[NSNumber class]]){
      [updateSql appendFormat:@" %@ = %@,",itemKey,item];
    }else if ([item isKindOfClass:[NSData class]]){
      [updateSql appendFormat:@" %@ = '%@',",itemKey,[[NSString alloc] initWithData:(NSData*)item encoding:NSUTF8StringEncoding]];
    }else{
      [updateSql appendFormat:@" %@ = '%@',",itemKey,item];
    }
  }
  [updateSql appendFormat:@" id = %d WHERE id=%d ",theId,theId];
  NSNumber *result = [self executeQuery:updateSql];
  if ([result isKindOfClass:[NSNumber class]]) {
    return [result boolValue];
  }
  return YES;
}

-(BOOL)addItemWithData:(NSDictionary*)theData forTable:(NSString*)theName
{
  sqlite3_stmt *statement;
  
  //这个 sql 语句特别之处在于 values 里面有个? 号。在sqlite3_prepare函数里，?号表示一个未定的值，它的值等下才插入。
  NSString *formatSql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (name,age,time) VALUES (?, ?, ?)",theName];
  const char *sql = [formatSql UTF8String];
  
  int success2 = sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
  if (success2 != SQLITE_OK) {
    NSLog(@"Error: failed to insert:testTable");
    return NO;
  }
  
  //这里的数字1，2，3代表上面的第几个问号，这里将三个值绑定到三个绑定变量
  sqlite3_bind_text(statement, 1, [theData[@"name"] UTF8String], -1, SQLITE_TRANSIENT);
  sqlite3_bind_int(statement, 2, [theData[@"age"] integerValue]);
  sqlite3_bind_double(statement, 3, [theData[@"time"] doubleValue]);
  
  //执行插入语句
  success2 = sqlite3_step(statement);
  //释放statement
  sqlite3_finalize(statement);
  
  //如果插入失败
  if (success2 == SQLITE_ERROR) {
    NSLog(@"Error: failed to insert into the database with message.");
    return NO;
  }
  return YES;
}

-(BOOL)clearTable:(NSString*)tableName
{
  NSNumber *ret = [self executeQuery:[NSString stringWithFormat:@"delete from %@ ",tableName]];
  return [ret boolValue];
}




-(NSArray *)findStatementDataList:(sqlite3_stmt *)statement isOK:(BOOL *)isOK
{
  NSMutableArray *array = [NSMutableArray new];
  while (1) {
    if (sqlite3_step(statement) == SQLITE_ROW) {
      *isOK = YES;
      
      int columnCount = sqlite3_column_count(statement);
      int columnIdx = 0;
      NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:columnCount];
      for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
        
        NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(statement, columnIdx)];
        
        int columnType = sqlite3_column_type(statement, columnIdx);
        
        id returnValue = nil;
        
        if (columnType == SQLITE_INTEGER) {
          returnValue = [NSNumber numberWithLongLong:sqlite3_column_int(statement, columnIdx)];
        }
        else if (columnType == SQLITE_FLOAT) {
          returnValue = [NSNumber numberWithDouble:sqlite3_column_double(statement, columnIdx)];
        }
        else if (columnType == SQLITE_BLOB) {
          returnValue = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, columnIdx) length:0];
        }
        else {
          //default to a string for everything else
          char* strText   = (char*)sqlite3_column_text(statement, 1);
          returnValue = [NSString stringWithUTF8String:strText];
        }
        [dict setObject:returnValue forKey:columnName];
      }
      [array addObject:dict];
      
    }else if (sqlite3_step(statement) == SQLITE_DONE){
      *isOK = YES;
      break;
    }else{
      *isOK = NO;
      break;
    }
  }
    return array;
}





@end
