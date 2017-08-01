//
//  CommunicationFrame.m
//  rcpi
//
//  Created by admin on 15/12/20.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "CommunicationFrame.h"
#import <UIKit/UIKit.h>

#define CLLMARGIN   8

//昵称
#define UNAMEFont [UIFont systemFontOfSize:18]
//主题
#define NameFont [UIFont systemFontOfSize:18]
//正文
#define MSGFont [UIFont systemFontOfSize:16]
//标签
#define TAGFont [UIFont systemFontOfSize:15]

#define kScreen [UIScreen mainScreen].bounds.size

@interface CommunicationFrame ()

//@property (nonatomic,assign)CGRect iconFrame;
//@property (nonatomic,assign)CGRect uNameFrame;
//@property (nonatomic,assign)CGRect nameFrame;
//@property (nonatomic,assign)CGRect msgFrame;
//@property (nonatomic,assign)CGRect tagFrame;
//@property (nonatomic,assign)CGRect clicksFrame;
//@property (nonatomic,assign)CGRect praiseFrame;
//@property (nonatomic,assign)CGRect commentFrame;
//


@end

@implementation CommunicationFrame

- (void)setComunication:(Communication *)comunication
{
    _comunication = comunication;
    //头像
    CGFloat iconX = CLLMARGIN;
    CGFloat iconY = CLLMARGIN;
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //昵称
    CGFloat unameX = CGRectGetMaxX(self.iconFrame) + CLLMARGIN;
    CGFloat unameY = 10;
    CGSize  unameSize = [_comunication.uname sizeWithAttributes:@{NSFontAttributeName:UNAMEFont}];
    self.uNameFrame = CGRectMake(unameX, unameY, unameSize.width, unameSize.height);
    
    //是否是楼主
    CGFloat preFloorX = CGRectGetMaxX(self.uNameFrame) + 5;
    CGFloat preFloorY = CLLMARGIN;
    CGSize  preFloorSize = [@"楼主" sizeWithAttributes:@{NSFontAttributeName:UNAMEFont}];
    self.preFloorFrame = CGRectMake(preFloorX, preFloorY, preFloorSize.width + CLLMARGIN, preFloorSize.height);
    
    //评论数
    CGFloat discussX = kScreen.width - CLLMARGIN - 55;
    CGFloat discussY = CLLMARGIN;
    CGFloat discussW = 55;
    CGFloat discussH = 22;
    self.discussFrame = CGRectMake(discussX, discussY, discussW, discussH);
    
    //时间
    CGFloat timeX = unameX;
    CGFloat timeY = CGRectGetMaxY(self.iconFrame) - 12;
    CGFloat timeW = 200;
    CGFloat timeH = 12;
    self.timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    
    //主题   有主题时是主题，没主题时是正文
    CGFloat nameX = CLLMARGIN;
    CGFloat nameY = CGRectGetMaxY(self.iconFrame) + 2 * CLLMARGIN;
    CGFloat nameW = kScreen.width - 2 * CLLMARGIN;
    CGSize  nameSize;
    if (_comunication.name.length == 0)
    {
        nameSize = [_comunication.msg boundingRectWithSize:CGSizeMake(nameW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:NameFont} context:nil].size;
    }
    else
    {
        nameSize = [_comunication.name boundingRectWithSize:CGSizeMake(nameW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:NameFont} context:nil].size;
    }
    self.nameFrame = CGRectMake(nameX, nameY, nameW, nameSize.height);
    
    
    CGFloat noteVX = 0;
    CGFloat noteVY = CLLMARGIN;
    CGFloat noteVW = kScreen.width;
    CGFloat noteVH = CGRectGetMaxY(self.nameFrame) + 5;
    self.noteVFrame = CGRectMake(noteVX, noteVY, noteVW, noteVH);
    self.cellNameHeight = CGRectGetMaxY(self.noteVFrame);
    NSLog(@"11=======  %f   %f",self.noteVFrame.origin.y,noteVH);
    
    //正文
    CGFloat msgX = CLLMARGIN;
    CGFloat msgY = 0;
    CGFloat msgW = kScreen.width - 2 * CLLMARGIN;
    CGSize  msgSize = [_comunication.msg boundingRectWithSize:CGSizeMake(msgW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:MSGFont} context:nil].size;
    self.msgFrame = CGRectMake(msgX, msgY, msgW, msgSize.height);
    
    //标签
    CGFloat tagX = CLLMARGIN + 20 + CLLMARGIN;
    CGFloat tagY = CGRectGetMaxY(self.msgFrame) + 2 * CLLMARGIN;
    CGFloat tagW = kScreen.width - tagX - CLLMARGIN;
    CGSize  tagSize = [_comunication.tag boundingRectWithSize:CGSizeMake(tagW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TAGFont} context:nil].size;
    self.tagFrame = CGRectMake(tagX, tagY, tagW, tagSize.height );
    
    
    
    //正文和标签视图
    CGFloat tagVX= 0;
    CGFloat tagVY = CGRectGetMaxY(self.noteVFrame);
    CGFloat tagVW = kScreen.width;
    CGFloat tagVH = CGRectGetMaxY(self.tagFrame)+ CLLMARGIN;
    self.tagVFrame = CGRectMake(tagVX, tagVY, tagVW, tagVH);
    self.cellTagHeight = CGRectGetMaxY(self.tagVFrame);//tagVY + tagVH
    NSLog(@"22=======  %f   %f",self.tagVFrame.origin.y,tagVH);
    NSLog(@"===== %f    %f",self.tagVFrame.origin.y,self.tagVFrame.size.height);
    NSLog(@"22 == %f",self.cellTagHeight);
    
    
    //点赞
    CGFloat praiseX;
    CGFloat praiseW = kScreen.width * 0.5;

    //评论
    CGFloat commentX;
    CGFloat commentW = kScreen.width * 0.5;
    
    if (comunication.name.length == 0) {
        praiseX = kScreen.width * 0.5;
        praiseW = kScreen.width * 0.5;
        
        commentX = CLLMARGIN;
        commentW = kScreen.width * 0.5;
    }
    else
    {
        praiseX = CLLMARGIN;
        praiseW = kScreen.width * 0.5 - CLLMARGIN;
        
        commentX = kScreen.width * 0.5;
        commentW = kScreen.width * 0.5 - CLLMARGIN;

    }
    CGFloat praiseY = 0;
    CGFloat praiseH = 40;
    self.praiseFrame = CGRectMake(praiseX, praiseY, praiseW, praiseH);
    
    //评论
    CGFloat commentY = 0;
    CGFloat commentH = 40;
    self.commentFrame = CGRectMake(commentX, commentY, commentW, commentH);
    
    //按钮tool
    CGFloat clicksVX = 0;
    CGFloat clicksVY;
    if (comunication.name.length == 0)
    {
        clicksVY = CGRectGetMaxY(self.noteVFrame);
    }
    else
    {
        clicksVY = CGRectGetMaxY(self.tagVFrame);
        
    }
    CGFloat clicksVW = kScreen.width ;
    CGFloat clicksVH = 40;
    self.clicksVFrame = CGRectMake(clicksVX, clicksVY, clicksVW, clicksVH);
    self.cellHeight = CGRectGetMaxY(self.clicksVFrame);
    NSLog(@"333 ==== %f",clicksVH + clicksVY);
    NSLog(@"===== %f    %f   %f",self.clicksVFrame.origin.y,self.clicksVFrame.size.height ,self.cellHeight);
}





@end
