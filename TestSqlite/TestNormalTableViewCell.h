//
//  TestNormalTableViewCell.h
//  TestSqlite
//
//  Created by wsliang on 15/8/5.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TestNormalTableViewCellDelegate <NSObject>

-(void)cellDataEdit:(int)theIndex;
-(void)cellDataDelete:(int)theIndex;

@end

@interface TestNormalTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TestNormalTableViewCellDelegate> delegate;

@property (nonatomic) int index;
@property (weak, nonatomic) IBOutlet UIView *viewControl;
@property (weak, nonatomic) IBOutlet UILabel *textNum;
@property (weak, nonatomic) IBOutlet UILabel *textTitle;
@property (weak, nonatomic) IBOutlet UILabel *textInfo;
- (IBAction)actionOperations:(UIButton *)sender;

@end
