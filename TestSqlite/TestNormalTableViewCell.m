//
//  TestNormalTableViewCell.m
//  TestSqlite
//
//  Created by wsliang on 15/8/5.
//  Copyright (c) 2015年 wsliang. All rights reserved.
//

#import "TestNormalTableViewCell.h"

@implementation TestNormalTableViewCell

- (void)awakeFromNib
{
    // Initialization code
  self.viewControl.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
  self.viewControl.hidden = !selected;
    // Configure the view for the selected state
}

- (IBAction)actionOperations:(UIButton *)sender {
  if (sender.tag==100) { // edit
    if ([self.delegate respondsToSelector:@selector(cellDataEdit:)]) {
      [self.delegate cellDataEdit:self.index];
    }
    
  }else{ // delete
    if ([self.delegate respondsToSelector:@selector(cellDataDelete:)]) {
      [self.delegate cellDataDelete:self.index];
    }
    
  }
  
}


@end
