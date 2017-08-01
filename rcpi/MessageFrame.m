//
//  MessageFrame.m
//  rcpi
//
//  Created by Dyang on 15/12/16.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "MessageFrame.h"

@implementation MessageFrame
- (void)setMessage:(MyMessage *)message {
    _message = message;
    
    CGFloat padding = 10;
    //取得屏幕宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    if (message.hideTime == NO) {
        CGFloat timeX = 0;
        CGFloat timeY = padding;
        CGFloat timeW = screenW;
        CGFloat timeH = 40;
        _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    CGFloat iconW = 30;
    CGFloat iconH = 30;
    CGFloat iconX;
    CGFloat iconY = CGRectGetMaxY(_timeF);
    if (message.type == MessageTypeMe) {
        iconX = screenW - iconW - padding;
    }else{
        iconX = padding;
    }
    _iconF=CGRectMake(iconX, iconY, iconW, iconH);
    
    CGSize textMaxSize = CGSizeMake(screenW - 150, MAXFLOAT);
    NSDictionary *attr1 = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize textSize = [message.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr1 context:nil].size;
    CGFloat textX;
    CGFloat textY = iconY;
    if (message.type == MessageTypeMe) {
        textX = screenW - iconW - textSize.width - padding*2 - 40;
    }else{
        textX = CGRectGetMaxX(_iconF) + padding;
    }
    _textF = CGRectMake(textX, textY, textSize.width + 40, textSize.height + 20);
    
    
    _cellHeight = (CGRectGetMaxY(_textF) > CGRectGetMaxY(_iconF)) ? CGRectGetMaxY(_textF) + padding : CGRectGetMaxY(_iconF) + padding;
}
@end
