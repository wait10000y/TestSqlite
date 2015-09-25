//
//  FMDBUtil.m
//  TestSqlite
//
//  Created by wsliang on 15/6/23.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "FMDBUtil.h"

@implementation FMDBUtil
{
  FMDatabase *db;
}
@synthesize filePath;

+(FMDBUtil*)sharedObject
{
  static FMDBUtil *staticObject;
  if (!staticObject) {
    staticObject = [[FMDBUtil alloc] init];
  }
  return staticObject;
}

-(BOOL)openDB
{
  if (!db) {
    if (!filePath) {
      filePath = [self findDefaultPath];
    }
    NSLog(@"---db path:%@ ---",filePath);
    db = [FMDatabase databaseWithPath:filePath];
  }
  return [db open];
}

-(BOOL)closeDB
{
  return [db close];
}

-(BOOL)clearDB
{
  [self closeDB];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  return [fileManager removeItemAtPath:filePath error:nil];
}


-(id)executeQuery:(NSString*)theSql
{
  if (theSql) {
    if ([theSql hasPrefix:@"select"]) {
      FMResultSet *resSet = [db executeQuery:theSql];
      NSMutableArray *items = [NSMutableArray new];
      while ([resSet next]) {
        [items addObject:[resSet resultDictionary]];
      }
      if (items.count == 0) {
        return nil;
      }else if (items.count==1) {
        return items[0];
      }
      return items;
    }else{
      BOOL isOK = [db executeUpdate:theSql];
      return @(isOK);
    }
  }
  return nil;
}

-(NSArray*)listItemAllForTable:(NSString*)theName
{
  NSString *sql = [NSString stringWithFormat:@"select * from %@ ",theName];
  FMResultSet *resSet = [db executeQuery:sql];
  NSMutableArray *items = [NSMutableArray new];
  while ([resSet next]) {
    [items addObject:[resSet resultDictionary]];
  }
  return items;
}

-(NSDictionary*)selectItem:(int)theId forTable:(NSString*)theName
{
  NSString *sql =[NSString stringWithFormat:@"select * from %@ where id=%d ",theName,theId];
  FMResultSet *resSet = [db executeQuery:sql];
  if ([resSet next]) {
    return [resSet resultDictionary];
  }
  return nil;
}

-(BOOL)deleteItemWithId:(int)theId forTable:(NSString*)theName
{
  NSString *sql =[NSString stringWithFormat:@"delete from %@ where id=%d ",theName,theId];
  return [db executeUpdate:sql];
}

-(BOOL)updateItem:(int)theId withData:(NSDictionary*)theData forTable:(NSString*)tableName
{
  if (theData.count > 0) {
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
    
    return [db executeUpdate:updateSql];
  }
  return NO;
}

-(BOOL)addItemWithData:(NSDictionary*)theData forTable:(NSString*)theName
{
  NSString *formatSql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (name,age,time) VALUES (:name,:age,:time)",theName];
  return [db executeUpdate:formatSql withParameterDictionary:theData];
}

-(BOOL)clearTable:(NSString*)tableName
{
  NSString *sql = [NSString stringWithFormat:@"delete from %@ ",tableName];
  return [db executeUpdate:sql];
}
















// CREATE, UPDATE, INSERT, ALTER, COMMIT, BEGIN, DETACH, DELETE, DROP, END, EXPLAIN, VACUUM, and REPLACE statements (plus many more).
// Basically, if your SQL statement does not begin with SELECT, it is an update statement.
-(FMResultSet*)executeQuery:(NSString*)theSql withArguments:(NSArray*)theArgs
{
  return [db executeQuery:theSql withArgumentsInArray:theArgs];
}

-(BOOL)executeUpdate:(NSString*)theSql withArguments:(NSArray*)theArgs
{
  return [db executeUpdate:theSql withArgumentsInArray:theArgs];
}

-(NSError*)getLastError
{
  if (db.hadError) {
    return db.lastError;
  }
  return nil;
}

-(BOOL)insertData:(NSDictionary*)theDict
{
  return NO;
}

-(BOOL)deleteData:(NSDictionary*)theSearchKeys
{
  return NO;
}

-(BOOL)updateData:(NSDictionary*)theDict withSearchKeys:(NSDictionary*)theSearchKeys
{
  return NO;
}

-(NSArray*)selectData:(NSDictionary*)theSearchKeys
{

  // ------------------
  //  FMResultSet *s = [db executeQuery:@"SELECT COUNT(*) FROM myTable"];
  //  if ([s next]) {
  //    int totalCount = [s intForColumnIndex:0];
  //intForColumn:
  //longForColumn:
  //longLongIntForColumn:
  //boolForColumn:
  //doubleForColumn:
  //stringForColumn:
  //dateForColumn:
  //dataForColumn:
  //dataNoCopyForColumn:
  //UTF8StringForColumnName:
  //objectForColumnName:
  //  }
  
  //  while ([s next]) {
  //    //retrieve values for each record
  //  }
  // ------------------
  [db beginTransaction];
  
  [db rollback];
  [db commit];
  // ------------------
  //  NSString *sql = @"select count(*) as count from bulktest1;";
  //  BOOL success = [db executeStatements:sql withResultBlock:^int(NSDictionary *resultsDictionary) {
  //    NSInteger count = [resultsDictionary[@"count"] integerValue];
  //    return 0;
  //  }];
  // ------------------
  
  //  NSDictionary *argsDict = [NSDictionary dictionaryWithObjectsAndKeys:@"My Name", @"name", nil];
  //  [db executeUpdate:@"INSERT INTO myTable (name) VALUES (:name)" withParameterDictionary:argsDict];
  //
  //  [db executeUpdate:@"INSERT INTO myTable VALUES (?)", @"this has \" lots of ' bizarre \" quotes '"];
  //
  //  [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO myTable VALUES (%@)", @"this has \" lots of ' bizarre \" quotes '"]];
  //
  //  [db executeUpdate:@"INSERT INTO myTable VALUES (?)", 42];
  //
  //  [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:42]];
  //
  //  [db executeUpdateWithFormat:@"INSERT INTO myTable VALUES (%d)", 42];
  // %@, %c, %s, %d, %D, %i, %u, %U, %hi, %hu, %qi, %qu, %f, %g, %ld, %lu, %lld, and %llu
  
  // ------------------
  
  //  FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:aPath];
  //
  //  [queue inDatabase:^(FMDatabase *db) {
  //    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:1]];
  //    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:2]];
  //    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:3]];
  //
  //    FMResultSet *rs = [db executeQuery:@"select * from foo"];
  //    while ([rs next]) {
  //      …
  //    }
  //  }];
  //
  //  [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
  //    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:1]];
  //    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:2]];
  //    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:3]];
  //
  //    if (whoopsSomethingWrongHappened) {
  //      *rollback = YES;
  //      return;
  //    }
  //    // etc…
  //    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:4]];
  //  }];
  
  
  // ------------------
  
  
  
  
  // ------------------
  
  
  
  // ------------------
  
  
  
  return nil;
}





@end
