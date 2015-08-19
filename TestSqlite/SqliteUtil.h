//
//  SqliteUtil.h
//  TestSqlite
//
//  Created by wsliang on 15/6/23.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "SqliteBaseUtil.h"
#import <sqlite3.h>

@interface SqliteUtil : SqliteBaseUtil


+(instancetype)sharedObject;

-(NSString*)findDefaultPath;

-(BOOL)openDB;
-(BOOL)closeDB;
-(BOOL)clearDB;

-(NSArray*)listItemAllForTable:(NSString*)theName;

-(NSDictionary*)selectItem:(int)theId forTable:(NSString*)theName;

-(BOOL)deleteItemWithId:(int)theId forTable:(NSString*)theName;

-(BOOL)updateItem:(int)theId withData:(NSDictionary*)theData forTable:(NSString*)theName;

-(BOOL)addItemWithData:(NSDictionary*)theData forTable:(NSString*)theName;

-(BOOL)clearTable:(NSString*)tableName;














-(NSArray*)listItemAllForTable:(NSString*)theName;

-(NSDictionary*)selectItem:(int)theId forTable:(NSString*)theName;

-(BOOL)deleteItemWithId:(int)theId forTable:(NSString*)theName;

-(BOOL)updateItem:(int)theId withData:(NSDictionary*)theData forTable:(NSString*)theName;

-(BOOL)addItemWithData:(NSDictionary*)theData forTable:(NSString*)theName;

@end
