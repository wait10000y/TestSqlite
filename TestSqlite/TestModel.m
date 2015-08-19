//
//  TestModel.m
//  TestSqlite
//
//  Created by wsliang on 15/6/23.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel



-(id)initWithName:(NSString*)theName withAge:(NSInteger)theAge
{
  if ([self init]) {
    self.name = theName;
    self.age = theAge;
    self.index = 0;
    self.time = [NSDate date].timeIntervalSinceNow;
  }
  return self;
}


@end
