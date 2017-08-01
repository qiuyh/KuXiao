//
//  CourseDetailsTableViewCell.h
//  CourseDetails
//
//  Created by user on 15/10/10.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *coursePeopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTypeLabel;

@end
