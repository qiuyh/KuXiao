//
//  EvaluationCell.h
//  rcpi
//
//  Created by wu on 15/11/15.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluationCell : UITableViewCell
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *title;
/** 描述头 */
@property (weak, nonatomic) IBOutlet UILabel *describeTitle;
/** 描述内容 */
@property (weak, nonatomic) IBOutlet UITextView *describe;
/** 时间头 */
@property (weak, nonatomic) IBOutlet UILabel *timeTitle;
/** 时间内容 */
@property (weak, nonatomic) IBOutlet UILabel *timeContent;
/** 试卷头 */
@property (weak, nonatomic) IBOutlet UILabel *examTitle;
/** 试卷名字 */
@property (weak, nonatomic) IBOutlet UILabel *examContent;
/** 标题图案 */
@property (weak, nonatomic) IBOutlet UIImageView *titleImgs;
/** 等待批改 */
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;
/** 价格 */
@property (weak, nonatomic) IBOutlet UILabel *price;


//cell2
/** 题型 */
@property (weak, nonatomic) IBOutlet UILabel *typeTitle;
/** 编辑 */
@property (weak, nonatomic) IBOutlet UIImageView *imgs;

@end
