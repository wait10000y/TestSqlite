//
//  FMDBUtil.h
//  TestSqlite
//
//  Created by wsliang on 15/6/23.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "SqliteBaseUtil.h"
#import "FMDB.h"

@interface FMDBUtil : SqliteBaseUtil

+(instancetype)sharedObject;

-(NSString*)findDefaultPath;

-(BOOL)openDB;
-(BOOL)closeDB;
-(BOOL)clearDB;

-(id)executeQuery:(NSString*)theSql;

-(NSArray*)listItemAllForTable:(NSString*)theName;

-(NSDictionary*)selectItem:(int)theId forTable:(NSString*)theName;

-(BOOL)deleteItemWithId:(int)theId forTable:(NSString*)theName;

-(BOOL)updateItem:(int)theId withData:(NSDictionary*)theData forTable:(NSString*)theName;

-(BOOL)addItemWithData:(NSDictionary*)theData forTable:(NSString*)theName;

-(BOOL)clearTable:(NSString*)tableName;





//-(id)executeQuery:(NSString*)theSql withArguments:(NSArray*)theArgs;
//-(BOOL)executeUpdate:(NSString*)theSql withArguments:(NSArray*)theArgs;
//-(NSError*)getLastError;

@end
