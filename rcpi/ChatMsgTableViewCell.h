//
//  ChatMsgTableViewCell.h
//  rcpi
//
//  Created by Dyang on 15/12/16.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageFrame.h"
#import <iwf/iwf.h>

@interface ChatMsgTableViewCell : UITableViewCell

@property(nonatomic,strong) MessageFrame *messageFrame;

@property (nonatomic,strong)NSString *otherImg;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
