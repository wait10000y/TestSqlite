//
//  ViewController.m
//  TestSqlite
//
//  Created by wsliang on 15/6/15.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "ViewController.h"

#import "TestSqliteBaseViewController.h"
#import "SqliteUtil.h"
#import "FMDBUtil.h"

@interface ViewController ()

- (IBAction)actionGoToNextView:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionGoToNextView:(UIButton*)sender {
  SqliteBaseUtil *dbUtil;
  NSString *title = @"未知错误";
  if (sender.tag == 100) { // nomal
    dbUtil = [SqliteUtil sharedObject];
    title = @"测试 系统sqlite API";
  }else if (sender.tag == 101){ // fmdb
    dbUtil = [FMDBUtil sharedObject];
    title = @"测试 FMDB 工具";
  }
  TestSqliteBaseViewController *nextViewController = [[TestSqliteBaseViewController alloc] initWithNibName:nil bundle:nil];
  nextViewController.fromViewController = self;
  nextViewController.title = title;
  nextViewController.dbUtil = dbUtil;
  [self.navigationController pushViewController:nextViewController animated:YES];
}
@end
