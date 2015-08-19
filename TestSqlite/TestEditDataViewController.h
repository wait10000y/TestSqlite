//
//  TestEditDataViewController.h
//  TestSqlite
//
//  Created by wsliang on 15/8/7.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestEditDataViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textAge;

- (IBAction)actionFinished:(UIButton *)sender;


@end
