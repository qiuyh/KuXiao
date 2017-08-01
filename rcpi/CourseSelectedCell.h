//
//  CourseSelectedCell.h
//  rcpi
//
//  Created by 王文选 on 15/10/12.
//  Copyright (c) 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseSelectedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLablel;
//星级
@property (weak, nonatomic) IBOutlet UIImageView *hotGradeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *hotGradeImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *hotGradeImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *hotGradeImageView4;
@property (weak, nonatomic) IBOutlet UIImageView *hotGradeImageView5;


@property (weak, nonatomic) IBOutlet UILabel *studyCountLable;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


//cell2
@property (weak, nonatomic) IBOutlet UILabel *selectedNameLabel;
@property (weak, nonatomic) IBOutlet UIView *leftLineView;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
@property (weak, nonatomic) IBOutlet UILabel *underLabel;


@end
