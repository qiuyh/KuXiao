//
//  AllCourseCell.h
//  rcpi
//
//  Created by wu on 15/11/8.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllCourseCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *courseImgsBtn;

@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (nonatomic,strong)NSIndexPath *indexPath;
@end
