//
//  TestSqliteBaseViewController.h
//  TestSqlite
//
//  Created by wsliang on 15/6/15.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define defaultTableName @"test_model"

@class SqliteBaseUtil;
@interface TestSqliteBaseViewController : UIViewController
@property (nonatomic) SqliteBaseUtil *dbUtil;

@property (nonatomic, weak) UIViewController *fromViewController;

- (IBAction)actionDataOprations:(UIButton *)sender;

@end
