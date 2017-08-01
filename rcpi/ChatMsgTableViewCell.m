//
//  ChatMsgTableViewCell.m
//  rcpi
//
//  Created by Dyang on 15/12/16.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "ChatMsgTableViewCell.h"
#import "MyMessage.h"

@interface ChatMsgTableViewCell()

@property(nonatomic,weak)UILabel *timerView;
@property(nonatomic,weak)UIImageView *iconView;
@property(nonatomic,weak)UIButton *textView;

@end

@implementation ChatMsgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *timeView = [[UILabel alloc]init];
        timeView.textAlignment = NSTextAlignmentCenter;
        timeView.textColor = [UIColor grayColor];
        timeView.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:timeView];
        self.timerView = timeView;
        
        UIImageView *iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UIButton *textView=[[UIButton alloc]init];
        textView.titleLabel.numberOfLines=0;
        [textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        textView.titleLabel.font = [UIFont systemFontOfSize:15];
        textView.titleEdgeInsets = UIEdgeInsetsMake(20, 10, 20, 10);
        [self.contentView addSubview:textView];
        self.textView = textView;
        //设置cell背景颜色
        [self.contentView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.9]];
    }
    return self;
}

- (void)setMessageFrame:(MessageFrame *)messageFrame {
    _messageFrame = messageFrame;
    
    MyMessage *msg = self.messageFrame.message;
    
    self.timerView.text = msg.time;
    self.timerView.frame = self.messageFrame.timeF;
    
    if (msg.type == MessageTypeMe) {
        self.iconView.image = [UIImage imageNamed:@"chat_me"];
    }else{
        [self.iconView setUrl:self.otherImg];
    }
    self.iconView.frame = self.messageFrame.iconF;
    
    [self.textView setTitle:msg.text forState:UIControlStateNormal];
    self.textView.frame = self.messageFrame.textF;
    if (msg.type == MessageTypeMe) {
        UIImage *meBgNor = [UIImage imageNamed:@"chat_bg_blue"];
        UIEdgeInsets edge1 = UIEdgeInsetsMake(28, 32, 28, 32);
        meBgNor = [meBgNor resizableImageWithCapInsets:edge1 resizingMode:UIImageResizingModeStretch];
        [self.textView setBackgroundImage:meBgNor forState:UIControlStateNormal];
    }else{
        UIImage *otherBgNor = [UIImage imageNamed:@"chat_bg_white"];
        UIEdgeInsets edge2 = UIEdgeInsetsMake(28, 32, 28, 32);
        otherBgNor = [otherBgNor resizableImageWithCapInsets:edge2 resizingMode:UIImageResizingModeStretch];
        [self.textView setBackgroundImage:otherBgNor forState:UIControlStateNormal];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"message";
    ChatMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ChatMsgTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

@end
