//
//  MyCourseTableViewCell.h
//  rcpi
//
//  Created by user on 15/11/10.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCourseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *chaptersLabel;
@property (weak, nonatomic) IBOutlet UIButton *studyBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;



@end
