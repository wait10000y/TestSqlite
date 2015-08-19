//
//  TestSqliteBaseViewController.m
//  TestSqlite
//
//  Created by wsliang on 15/6/15.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "TestSqliteBaseViewController.h"
#import "TestNormalTableViewCell.h"

#import "SqliteUtil.h"
#import "FMDBUtil.h"


@interface TestSqliteBaseViewController ()<UITableViewDataSource,UITableViewDelegate,TestNormalTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSString* tableCellId;

@property (nonatomic) NSMutableArray *mDataList;

@end

@implementation TestSqliteBaseViewController

@synthesize dbUtil;

- (void)viewDidLoad
{
    [super viewDidLoad];
  self.mDataList = [NSMutableArray new];
//  self.tableView.tableHeaderView = [UIView new];
//  self.tableView.tableFooterView = [UIView new];
  
  self.tableCellId = @"tableCellId";
  [self.tableView registerNib:[UINib nibWithNibName:@"TestNormalTableViewCell" bundle:nil] forCellReuseIdentifier:self.tableCellId];
  
  [self defaultInitDatabase];
  [self listAllDatas];
  
  
}


-(void)defaultInitDatabase
{
  if(!dbUtil){
    NSLog(@"------- dbUtil is null ---------");
    return;
  }
  BOOL isOpen = [dbUtil openDB];
  if (!isOpen) {
    NSLog(@"------- dbUtil open failed ---------");
  }else{
    NSLog(@"----- dbUtil open ok -----");
//    BOOL tableExists = NO;
//    NSString *qSql = [NSString stringWithFormat:@"SELECT count(*) count FROM sqlite_master WHERE type='table' AND name='%@'",defaultTableName];
//    FMResultSet *resultSet = [dbUtil executeQuery:qSql withArguments:nil];
//    if ([resultSet next]) {
//      int count = [resultSet intForColumn:@"count"];
//      if (count > 0) {
//        tableExists = YES;
//        NSLog(@"----- table '%@' already exists -----",defaultTableName);
//      }
//    }
    
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement, name text,age integer,time time);",defaultTableName];
    NSNumber *result = [dbUtil executeQuery:sql];
    if (result.boolValue) {
      NSLog(@"----- init table ok -----");
    }
    
  }
}

-(void)listAllDatas
{
  NSArray *result = [dbUtil listItemAllForTable:defaultTableName];
  [self.mDataList removeAllObjects];
  [self.mDataList addObjectsFromArray:result];
  [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.mDataList.count;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  TestNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.tableCellId];
  NSDictionary *data = self.mDataList[indexPath.row];
  cell.delegate = self;
  cell.index = indexPath.row;
  cell.textNum.text = [data[@"id"] description];
  cell.textTitle.text = [NSString stringWithFormat:@"%@ (年龄:%@)",data[@"name"],data[@"age"]];
  NSDate *time = [NSDate dateWithTimeIntervalSince1970:[data[@"time"] doubleValue]];
  static NSDateFormatter *df;
  if (!df) {
    df = [NSDateFormatter new];
    df.dateFormat = @"YYYY-MM-dd HH:mm:ss";
  }
  cell.textInfo.text = [NSString stringWithFormat:@"创建时间: %@ ",[df stringFromDate:time]];
  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}


-(void)cellDataDelete:(int)theIndex
{
  // show warn
  
  // delete data
  // reload tableview
  int theId = [[self.mDataList[theIndex] objectForKey:@"id"] integerValue];
  BOOL result = [dbUtil deleteItemWithId:theId forTable:defaultTableName];
  if (result) {
    [self.mDataList removeObjectAtIndex:theIndex];
  }
  [self listAllDatas];
  
}

-(void)cellDataEdit:(int)theIndex
{
  NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:self.mDataList[theIndex]];
  if (item) {
    int theId = [[item objectForKey:@"id"] integerValue];
    [item setObject:[self randomString] forKey:@"name"];
    [item setObject:@([self randomInt]) forKey:@"age"];
    [item setObject:@([NSDate timeIntervalSinceReferenceDate]) forKey:@"time"];
    
    BOOL result = [dbUtil updateItem:theId withData:item forTable:defaultTableName];
    NSLog(@"------ update data %@ -----",result?@"ok":@"fail");
  }
  
  [self listAllDatas];
}

- (IBAction)actionDataOprations:(UIButton *)sender {
  if (sender.tag == 100) { // add
    NSDictionary *newData = @{
                              @"name":[self randomString],
                              @"age":@([self randomInt]),
                              @"time":@([NSDate date].timeIntervalSince1970)
                              };
    
    [dbUtil addItemWithData:newData forTable:defaultTableName];
    
  }else if (sender.tag == 101){ // clear
    
    [dbUtil clearTable:defaultTableName];
    
  }
  [self listAllDatas];
}

-(NSString*)randomString
{
  NSString *uuid = [[NSUUID UUID] UUIDString];
  if (uuid) {
    return  [uuid substringToIndex:8];
  }
  return @"";
}

-(int)randomInt
{
  return arc4random()%100+1;
}

@end
