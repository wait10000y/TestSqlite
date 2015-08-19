//
//  YTKUtil.m
//  TestSqlite
//
//  Created by wsliang on 15/8/11.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "YTKUtil.h"
#import "YTKKeyValueStore.h"

@implementation YTKUtil
{
  YTKKeyValueStore *store;
}

+(YTKUtil*)sharedObject
{
  static YTKUtil *staticObject;
  if (!staticObject) {
    staticObject = [[YTKUtil alloc] init];
  }
  return staticObject;
}


-(BOOL)openDB
{
  if(!store){
    store = [[YTKKeyValueStore alloc] initDBWithName:YTK_database_name];
    [store createTableWithName:YTK_table_name];
  }
  return YES;
}

-(BOOL)closeDB
{
  if (store) {
    [store close];
  }
  return YES;
}

-(BOOL)clearDB
{

  return NO;
}

-(id)executeQuery:(NSString*)theSql
{
  return @(NO);
}

-(NSArray*)listItemAllForTable:(NSString*)theName
{
  return [store getAllItemsFromTable:theName];
}

-(NSDictionary*)selectItem:(int)theId forTable:(NSString*)theName
{
  return [store getObjectById:[@(theId) description] fromTable:theName];
}

-(BOOL)deleteItemWithId:(int)theId forTable:(NSString*)theName
{
  [store deleteObjectById:[@(theId) description] fromTable:theName];
  return NO;
}

-(BOOL)updateItem:(int)theId withData:(NSDictionary*)theData forTable:(NSString*)theName
{
  [store putObject:theData withId:[@(theId) description] intoTable:theName];
  return YES;
}

-(BOOL)addItemWithData:(NSDictionary*)theData forTable:(NSString*)theName
{
  [store putObject:theData withId:theData[@"name"] intoTable:theName];
  return YES;
}

-(BOOL)clearTable:(NSString*)tableName
{
  [store clearTable:tableName];
  return YES;
}






@end
