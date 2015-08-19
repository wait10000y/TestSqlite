//
//  TestEditDataViewController.m
//  TestSqlite
//
//  Created by wsliang on 15/8/7.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "TestEditDataViewController.h"

@interface TestEditDataViewController ()

@end

@implementation TestEditDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionFinished:(UIButton *)sender {
  // TODO: save data
  
  [self.navigationController popViewControllerAnimated:YES];
}


@end
