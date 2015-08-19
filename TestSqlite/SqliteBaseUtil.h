//
//  SqliteBaseUtil.h
//  TestSqlite
//
//  Created by wsliang on 15/6/23.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqliteBaseUtil : NSObject
@property (nonatomic) NSString *filePath;

-(NSString*)findDefaultPath;

-(BOOL)openDB;
-(BOOL)closeDB;
-(BOOL)clearDB;

-(id)executeQuery:(NSString*)theSql;

-(NSArray*)listItemAllForTable:(NSString*)tableName;

-(NSDictionary*)selectItem:(int)theId forTable:(NSString*)tableName;

-(BOOL)deleteItemWithId:(int)theId forTable:(NSString*)tableName;

-(BOOL)updateItem:(int)theId withData:(NSDictionary*)theData forTable:(NSString*)tableName;

-(BOOL)addItemWithData:(NSDictionary*)theData forTable:(NSString*)tableName;

-(BOOL)clearTable:(NSString*)tableName;


// ---------------------------------------
//-(BOOL)excuteSql;

-(BOOL)insertData:(NSDictionary*)theDict;
-(BOOL)deleteData:(NSDictionary*)theSearchKeys;
-(BOOL)updateData:(NSDictionary*)theDict withSearchKeys:(NSDictionary*)theSearchKeys;
-(NSArray*)selectData:(NSDictionary*)theSearchKeys;

//-(id)executeQuery:(NSString*)theSql withArguments:(NSArray*)theArgs;
//-(BOOL)executeUpdate:(NSString*)theSql withArguments:(NSArray*)theArgs;
//-(NSError*)getLastError;

@end
