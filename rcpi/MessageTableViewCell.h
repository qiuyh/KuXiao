//
//  MessageTableViewCell.h
//  rcpi
//
//  Created by Dyang on 15/12/10.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *MsgLable;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;

@end
