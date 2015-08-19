//
//  TestModel.h
//  TestSqlite
//
//  Created by wsliang on 15/6/23.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject

@property (nonatomic) NSInteger index;

@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger age;
@property (nonatomic) NSTimeInterval time; //


-(id)initWithName:(NSString*)theName withAge:(NSInteger)theAge;

@end
