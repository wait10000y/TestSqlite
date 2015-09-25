//
//  SQLDatabase.m
//
//  Created by Sergo Beruashvili on 10/2/13.
//  Copyright (c) 2013 Sergo Beruashvili. All rights reserved.
//

#import "SQLiteDatabase.h"
#import "SQLiteResult.h"
#import "SQLiteRow.h"
#include <sys/xattr.h>

#ifdef DEBUG
#define LogDebug(frmt, ...) NSLog(frmt, ##__VA_ARGS__);
#else
#define LogDebug(frmt, ...) {}
#endif

@interface SQLiteDatabase()

@property (nonatomic) sqlite3 *databaseHandle;
@property (nonatomic) NSOperationQueue *queryQueue;

@end

@implementation SQLiteDatabase


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SQLiteDatabase *instance;
    dispatch_once(&onceToken, ^{
        instance = [[SQLiteDatabase alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    
    self.queryQueue = [[NSOperationQueue alloc] init];
    self.queryQueue.maxConcurrentOperationCount = 1;
    
    return self;
}

- (sqlite3 *)databaseHandle {
    if(_databaseHandle == nil) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *sqliteDB = [documentsDirectory stringByAppendingPathComponent:DATABASE_FILE_NAME];
        
        if ([fileManager fileExistsAtPath:sqliteDB] == NO) {
            NSArray *parts = [DATABASE_FILE_NAME componentsSeparatedByString:@"."];
            if(parts.count != 2) {
                LogDebug(@"Database file name must be with format FILENAME.TYPE , for example mydatabase.sqlite , your is %@",DATABASE_FILE_NAME);
                return nil;
            }
            NSString *resourcePath = [[NSBundle mainBundle] pathForResource:[parts objectAtIndex:0]
                                                                     ofType:[parts objectAtIndex:1]];
            if(resourcePath == nil) {
                LogDebug(@"Database file %@ Does not exist ",DATABASE_FILE_NAME);
                return nil;
            }
            [fileManager copyItemAtPath:resourcePath toPath:sqliteDB error:&error];
            if(error != nil) {
                LogDebug(@"Error Copying Database File %@ ",error.localizedDescription);
            }
#ifdef EXCLUDE_DATABASE_FROM_BACKUP
            [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:sqliteDB]];
#endif
        }
        
        if(sqlite3_open_v2([sqliteDB UTF8String], &_databaseHandle, SQLITE_OPEN_READWRITE, NULL) !=  SQLITE_OK) {
            LogDebug(@"Failed to open the database %@ ",sqliteDB);
        }
        
    }
    return _databaseHandle;
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    NSError *error = nil;
    [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    return error == nil;
}

#pragma mark - Query Methods

- (void)executeQuery:(NSString *)query
          withParams:(NSDictionary *)params
             success:(void(^)(SQLiteResult *result))success
             failure:(void(^)(NSString *errorMessage))failure {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        SQLiteResult *result = [self qin:query withParams:params];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if(!result) {
                if(failure) {
                    failure(@"Unknown Error");
                }
            } else if(!result.success) {
                if(failure) {
                    failure(result.errorMessage);
                }
            } else {
                if(success) {
                    success(result);
                }
            }
        }];
    }];
    
    operation.queuePriority = NSOperationQueuePriorityHigh;
    [self.queryQueue addOperation:operation];
}

- (void)executeUpdate:(NSString *)query
           withParams:(NSDictionary *)params
              success:(void(^)(SQLiteResult *result))success
              failure:(void(^)(NSString *errorMessage))failure {
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        SQLiteResult *result = [self qout:query withParams:params];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if(!result) {
                if(failure) {
                    failure(@"Unknown Error");
                }
            } else if(!result.success) {
                if(failure) {
                    failure(result.errorMessage);
                }
            } else {
                if(success) {
                    success(result);
                }
            }
        }];
    }];
    operation.queuePriority = NSOperationQueuePriorityNormal;
    [self.queryQueue addOperation:operation];
}


-(SQLiteResult *)qin:(NSString *)query
          withParams:(NSDictionary *)params {
    
    SQLiteResult *result = [SQLiteResult resultWithSuccess];
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(self.databaseHandle, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        int bindParamsCount = sqlite3_bind_parameter_count(statement);
        if(params.count < bindParamsCount) {
            return [SQLiteResult resultWithErrorMessage:[NSString stringWithFormat:@"Query %@ needs %d parameters to bind, got %@ ",query,bindParamsCount,params]];
        }
        
        SQLiteResult *bindResult = [self bindParams:params toStatement:statement];
        if(!bindResult.success) {
            return bindResult;
        }
        
        int columnCount = sqlite3_column_count(statement);
        for(int i = 0; i < columnCount; i++) {
            if(sqlite3_column_name(statement,i) != NULL) {
                [result addColumnName:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
            } else {
                [result addColumnName:[NSString stringWithFormat:@"%d", i]];
            }
        }
        
        while(sqlite3_step(statement) == SQLITE_ROW) {
            SQLiteRow *row = [self getSqliteRowWithStatement:statement andColumnCount:columnCount];
            row.columnNames = result.columnNames;
            [result addSQLiteRow:row];
        }
        
        sqlite3_finalize(statement);
    } else {
        return [SQLiteResult resultWithErrorMessage:[NSString stringWithFormat:@"Incorrect query %@",query]];
    }
    return result;
}



-(SQLiteResult *)qout:(NSString *)query
           withParams:(NSDictionary *)params {
    
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(self.databaseHandle, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        int bindParamsCount = sqlite3_bind_parameter_count(statement);
        if(params.count < bindParamsCount) {
            return [SQLiteResult resultWithErrorMessage:[NSString stringWithFormat:@"Query %@ needs %d parameters to bind, got %@ ",query,bindParamsCount,params]];
        }
        
        SQLiteResult *bindResult = [self bindParams:params toStatement:statement];
        if(!bindResult.success) {
            return bindResult;
        }
        
        if(sqlite3_step(statement) != SQLITE_DONE) {
            const char* error = sqlite3_errmsg(self.databaseHandle);
            return [SQLiteResult resultWithErrorMessage:[NSString stringWithFormat:@"Error => %@",[[NSString alloc] initWithUTF8String:error]]];
        }
        
        sqlite3_finalize(statement);
    } else {
        return [SQLiteResult resultWithErrorMessage:[NSString stringWithFormat:@"Incorrect query %@",query]];
    }
    
    
    return [SQLiteResult resultWithSuccess];
}

#pragma mark - Inner Private Methods

- (SQLiteResult *)bindParams:(NSDictionary *)params toStatement:(sqlite3_stmt *)statement {
    
    if(params != nil) {
        int paramsCount = sqlite3_bind_parameter_count(statement);
        for(int columnIndex = 1;columnIndex <= paramsCount;columnIndex++) {
            
            const char *charKey = sqlite3_bind_parameter_name(statement, columnIndex);
            if(!charKey) {
                return [SQLiteResult resultWithErrorMessage:@"Incorrect query"];
            }
            
            NSString *key = [[NSString alloc] initWithUTF8String:charKey];
            
            id parameter = [params objectForKey:key];
            if(!parameter) {
                if([key hasPrefix:@":"]) {
                    parameter = [params objectForKey:[key substringFromIndex:1]];
                } else {
                    parameter = [params objectForKey:[NSString stringWithFormat:@":%@",key]];
                }
            }
            
            if(!parameter) {
                return [SQLiteResult resultWithErrorMessage:[NSString stringWithFormat:@"Can`t find parameter with name %@",key]];
            }
            
            if([parameter isKindOfClass:[NSString class]]) {
                sqlite3_bind_text(statement, columnIndex,[((NSString *)parameter) UTF8String], -1, SQLITE_TRANSIENT);
            } else if([parameter isKindOfClass:[NSNumber class]]) {
                sqlite3_bind_double(statement, columnIndex, ([(NSNumber *)parameter doubleValue]));
            } else if([parameter isKindOfClass:[NSData class]]) {
                sqlite3_bind_blob(statement, columnIndex, [parameter bytes], [parameter length], SQLITE_TRANSIENT);
            } else if([parameter isKindOfClass:[NSDate class]]) {
                sqlite3_bind_double(statement, columnIndex, [((NSDate *)parameter) timeIntervalSince1970]);
            } else {
                return [SQLiteResult resultWithErrorMessage:[NSString stringWithFormat:@"Can`t bind parameter with type %@",[parameter class]]];
            }
        }
    }
    
    return [SQLiteResult resultWithSuccess];
}

-(SQLiteRow *)getSqliteRowWithStatement:(sqlite3_stmt *)statement andColumnCount:(NSUInteger)columnCount {
    NSMutableDictionary *row = [[NSMutableDictionary alloc] initWithCapacity:columnCount];
    
    for(int i = 0;i < columnCount;i++) {
        NSString *name = nil;
        if(sqlite3_column_name(statement,i) != NULL) {
            name = [NSString stringWithUTF8String:sqlite3_column_name(statement,i)];
        } else {
            name = [NSString stringWithFormat:@"%d", i];
        }
        
        id value;
        
        int type = sqlite3_column_type(statement, i);
        
        switch (type) {
            case SQLITE_INTEGER:
            case SQLITE_FLOAT:
                value = [NSNumber numberWithDouble:sqlite3_column_double(statement, i)];
                break;
                
            case SQLITE_TEXT:
                value = [self stringWithCString:(char *) sqlite3_column_text(statement, i)];
                break;
                
            case SQLITE_BLOB:
                value = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, i) length: sqlite3_column_bytes(statement, i)];
                break;
                
            default:
                value = [NSNull null];
                break;
        }
        
        [row setObject:value forKey:name];
    }
    return [SQLiteRow rowWithRawData:row];
}

- (NSString *)stringWithCString:(char *)str {
    if(str) {
        return [[NSString alloc] initWithUTF8String:str];
    }
    return @"";
}


@end