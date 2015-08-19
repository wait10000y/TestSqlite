//
//  SqliteBaseUtil.m
//  TestSqlite
//
//  Created by wsliang on 15/6/23.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "SqliteBaseUtil.h"

@implementation SqliteBaseUtil

@synthesize filePath;

- (instancetype)init
{
  self = [super init];
  if (self) {
    filePath = [self findDefaultPath];
  }
  return self;
}

-(NSString*)findDefaultPath
{
   NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"appDefaultDB.sqlite3"];
  return dbPath;
}

-(BOOL)openDB
{
  return YES;
}

-(BOOL)closeDB
{
  return YES;
}

-(BOOL)clearDB
{
  return YES;
}

-(id)executeQuery:(NSString*)theSql
{
  return nil;
}

-(NSArray*)listItemAllForTable:(NSString*)theName
{
  return [NSArray new];
}

-(NSDictionary*)selectItem:(int)theId forTable:(NSString*)theName
{
  return nil;
}

-(BOOL)deleteItemWithId:(int)theId forTable:(NSString*)theName
{
  return NO;
}

-(BOOL)updateItem:(int)theId withData:(NSDictionary*)theData forTable:(NSString*)theName
{
  return NO;
}

-(BOOL)addItemWithData:(NSDictionary*)theData forTable:(NSString*)theName
{
  return NO;
}

-(BOOL)clearTable:(NSString*)tableName
{
  return NO;
}





-(BOOL)insertData:(NSDictionary*)theDict
{
  return YES;
}

-(BOOL)deleteData:(NSDictionary*)theSearchKeys
{
  return YES;
}

-(BOOL)updateData:(NSDictionary*)theDict withSearchKeys:(NSDictionary*)theSearchKeys
{
  return YES;
}

-(NSArray*)selectData:(NSDictionary*)theSearchKeys
{
  
  return nil;
}



-(id)executeQuery:(NSString*)theSql withArguments:(NSArray*)theArgs
{
  return nil;
}
-(BOOL)executeUpdate:(NSString*)theSql withArguments:(NSArray*)theArgs
{
  return NO;
}
-(NSError*)getLastError
{
  return nil;
}


@end
