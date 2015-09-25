//
//  SQLiteResult.h
//
//  Created by Sergo Beruashvili on 10/5/13.
//  Copyright (c) 2013 Sergo Beruashvili. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SQLiteRow;

@interface SQLiteResult : NSObject <NSFastEnumeration>

+(id)resultWithSuccess;
+(id)resultWithErrorMessage:(NSString *)error;


/**
 *  SUCCESS/FAILURE
 */
@property (nonatomic,readwrite) BOOL success;


/**
 *  Error message in case of failure
 */
@property (nonatomic,strong) NSString *errorMessage;


/**
 *  Fetched rows with query
 */
@property (nonatomic,strong) NSMutableArray *rows;


/**
 *  Fetched column names
 */
@property (nonatomic,strong) NSMutableArray *columnNames;

/**
 *  Adds SQLiteRow to the result container
 *
 *  @param row proper SQLiteRow object
 */
-(void)addSQLiteRow:(SQLiteRow *)row;

/**
 *  Removes SQLiteRow from result container
 *
 *  @param row proper row index
 */
-(void)removeSQLiteRow:(SQLiteRow *)row;

/**
 *  Returns SQLiteRow at given index
 *
 *  @param index
 *
 *  @return SQLiteRow object
 */
-(SQLiteRow *)rowAtIndex:(NSUInteger)index;

/**
 *  Count of fetched rows
 *
 *  @return Count of fetched rows
 */
-(NSUInteger)count;

/**
 *  Adds column name to container
 *
 *  @param columnName
 */
-(void)addColumnName:(NSString *)columnName;

/**
 *  Removes column name from container
 *
 *  @param columnName
 */
-(void)removeColumnName:(NSString *)columnName;

/**
 *  Returns index for given column name
 *
 *  @param columnName
 *
 *  @return index
 */
-(NSUInteger)indexForColumnName:(NSString *)columnName;

/**
 *  returns coulm name for given index
 *
 *  @param index
 *
 *  @return column name
 */
-(NSString *)columnNameForIndex:(NSUInteger)index;

@end
