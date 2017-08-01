//
//  EvaluationCell.m
//  rcpi
//
//  Created by wu on 15/11/15.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "EvaluationCell.h"
#import "Config.h"
@implementation EvaluationCell

- (void)awakeFromNib {
    self.describe.userInteractionEnabled=NO;
    self.waitLabel.hidden=YES;
    self.backgroundColor = CUSTOM_COLOR(220, 220, 220);
}



@end
