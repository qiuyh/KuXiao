//
//  SearchCourseViewCell.h
//  rcpi
//
//  Created by Dyang on 15/10/13.
//  Copyright (c) 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iwf/iwf.h>
@interface SearchCourseViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *courseImgView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLable;

@property (weak, nonatomic) IBOutlet UIImageView *courseRatingImgView;
@property (weak, nonatomic) IBOutlet UILabel *courseLearnnerSumLable;
@property (weak, nonatomic) IBOutlet UILabel *coursePriceLable;

@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;

@property(weak,nonatomic) UIStarView *courseRatingStatView;

@end
