//
//  SQLiteRow.h
//
//  Created by Sergo Beruashvili on 10/5/13.
//  Copyright (c) 2013 Sergo Beruashvili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteRow : NSObject

+(id)rowWithRawData:(NSDictionary *)dictionary;

/**
 *  Direct access to containers
 */
@property (nonatomic,strong) NSDictionary *rawData;
@property (nonatomic,strong) NSArray *columnNames;

/**
 *  Returns object by given column name , otherwise returns nil
 *
 *  @param columnName proper column name
 *
 *  @return fetched object
 */
-(id)objectForColumnName:(NSString *)columnName;

/**
 *  Returns object by given column index , otherwise returns nil
 *
 *  @param index proper column index
 *
 *  @return fetched object
 */
-(id)objectForColumnIndex:(NSUInteger)index;

// Returns stringvalue of object , if object does not exist or it does not have string value returns nil

/**
 *  Returns stringvalue of object , if object does not exist or it does not have string value returns nil
 *
 *  @param columnName proper column name
 *
 *  @return NSString value of object
 */
-(NSString *)stringForColumnName:(NSString *)columnName;

/**
 *  Returns stringvalue of object , if object does not exist or it does not have string value returns nil
 *
 *  @param index proper column index
 *
 *  @return NSString value of object
 */
-(NSString *)stringForColumnIndex:(NSUInteger)index;


/**
 *  Returns NSNumber object , if object does not exist returns nil
 *
 *  @param columnName proper column name
 *
 *  @return NSNumber value of object
 */
-(NSNumber *)numberForColumnName:(NSString *)columnName;

/**
 *  Returns NSNumber object , if object does not exist returns nil
 *
 *  @param index proper column index
 *
 *  @return NSNumber value of object
 */
-(NSNumber *)numberForColumnIndex:(NSUInteger)index;

/**
 *  Returns NSData object , if object does not exist returns nil
 *
 *  @param columnName proper column name
 *
 *  @return NSData value of object
 */
-(NSData *)dataForColumnName:(NSString *)columnName;

/**
 *  Returns NSData object , if object does not exist returns nil
 *
 *  @param index proper column index
 *
 *  @return NSData value of object
 */
-(NSData *)dataForColumnIndex:(NSUInteger)index;


/**
 *  Returns NSNumber object , if object does not exist returns nil
 *
 *  @param columnName proper column name
 *
 *  @return NSDate value of column
 */
-(NSDate *)dateForColumnName:(NSString *)columnName;

/**
 *  Returns NSNumber object , if object does not exist returns nil
 *
 *  @param index proper column index
 *
 *  @return NSDate value of column
 */
-(NSDate *)dateForColumnIndex:(NSUInteger)index;

@end
