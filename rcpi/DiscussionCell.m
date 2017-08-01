//
//  DiscussionCell.m
//  rcpi
//
//  Created by admin on 15/12/18.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "DiscussionCell.h"
#import "Config.h"

//昵称
#define UNAMEFont [UIFont systemFontOfSize:18]

//时间
#define TimeFont [UIFont systemFontOfSize:13]

//主题
#define NameFont [UIFont systemFontOfSize:18]
//正文
#define MSGFont [UIFont systemFontOfSize:16]
//标签
#define TAGFont [UIFont systemFontOfSize:15]

#define LightGrayColor [UIColor colorWithRed:239.0 / 255 green:239.0 / 255 blue:239.0 / 255 alpha:1.0]

//楼主背景颜色
#define PREFloor [UIColor colorWithRed:3.0 / 255.0 green:180.0 / 255.0 blue:170.0 / 255.0 alpha:1.0]

#define UNameTitleColor  [UIColor colorWithRed:105.0 / 255.0 green:105.0 / 255.0 blue:105.0 / 255.0 alpha:1.0]

#define MSGTitleColor [UIColor colorWithRed:168.0 / 255.0 green:168.0 / 255.0 blue:168.0 / 255.0 alpha:1.0]

//分割线颜色
#define LineColor [UIColor colorWithRed:224.0 / 255.0 green:224.0 / 255.0 blue:168.0 / 224.0 alpha:1.0]

@interface DiscussionCell ()

@property (nonatomic,strong)UIView *tagViewLine;
@property (nonatomic,strong)UIView *BtnlineViewS;
@property (nonatomic,strong)UIView *BtnlineViewL;


@end

@implementation DiscussionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpAllChildView];
        
    }
    return self;
}

// 添加所有子控件
- (void)setUpAllChildView
{
    //主题
    self.noteV = [[UIView alloc] init];
    self.noteV.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.noteV];
    //在主题视图上添加自控件
    [self setUpNoteChildView];
    
    //标签和主题内容
    self.tagV = [[UIView alloc]init];
    self.tagV.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.tagV];
    // 标签和主题内容视图添加子控件
    [self setUpTagChildView];
    
    
    
    // 工具条按钮视图
    self.buttonV = [[UIView alloc] init];
    self.buttonV.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.buttonV];
    // 工具条按钮视图添加子控件
    [self setUpButtonChildView];
    
    
}

//noteView上的视图加载
- (void)setUpNoteChildView
{
    self.iconImg = [[UIImageView alloc]init];
    self.iconImg.image = [UIImage imageNamed:@"默认头像"];
    [self.noteV addSubview:self.iconImg];
    
    self.unameL = [[UILabel alloc]init];
    self.unameL.font = UNAMEFont;
    self.unameL.textColor = UNameTitleColor;
    [self.noteV addSubview:self.unameL];
    
    self.preFloorL = [[UILabel alloc]init];
    self.preFloorL.textAlignment = NSTextAlignmentCenter;
    self.preFloorL.font = NameFont;
    self.preFloorL.textColor = [UIColor whiteColor];
    self.preFloorL.backgroundColor = PREFloor;
    [self.noteV addSubview:self.preFloorL];
    
    self.discussB = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.discussB setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
    [self.discussB  setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.discussB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.discussB.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.noteV addSubview:self.discussB];
    
    self.timeL = [[UILabel alloc]init];
    self.timeL.font = TimeFont;
    self.timeL.textColor = [UIColor lightGrayColor];
    [self.noteV addSubview:self.timeL];
    
    self.nameL = [[UILabel alloc]init];
    self.nameL.numberOfLines = 0;
    self.nameL.textColor = UNameTitleColor;
    self.nameL.font = NameFont;
    [self.noteV addSubview:self.nameL];
}

//标签和主题内容上的子视图
- (void)setUpTagChildView
{
    self.msgL = [[UILabel alloc]init];
    self.msgL.numberOfLines = 0;
    self.msgL.font = MSGFont;
    self.msgL.textColor = [UIColor lightGrayColor];
    [self.tagV addSubview:self.msgL];

    self.tagImg = [[UIImageView alloc]init];
    self.tagImg.image = [UIImage imageNamed:@"标签"];
    [self.tagV addSubview:self.tagImg];
    
    self.tagL = [[UILabel alloc]init];
    self.tagL.font = TAGFont;
    self.tagL.numberOfLines = 0;
    self.tagL.textColor = [UIColor lightGrayColor];
    [self.tagV addSubview:self.tagL];

    
    //标签上的分割线
    self.tagViewLine = [[UIView alloc]init];
    self.tagViewLine.backgroundColor = LightGrayColor;
    [self.tagV addSubview:self.tagViewLine];

}

//按钮工具上添加子视图
- (void)setUpButtonChildView
{
    //赞
    self.praiseB = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.praiseB setImage:[UIImage imageNamed:@"icon_laud"] forState:UIControlStateNormal];
    self.praiseB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//居中
    self.praiseB.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.buttonV addSubview:self.praiseB];
    [self.praiseB addTarget:self action:@selector(praiseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.praiseB setTitleColor:MSGTitleColor forState:UIControlStateNormal];
    
    //评论
    self.commentB = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentB setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
    self.commentB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//居中
    self.commentB.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.commentB addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonV addSubview:self.commentB];
    [self.commentB setTitleColor:MSGTitleColor forState:UIControlStateNormal];
    
    
    //按钮上下两条分割线
    
    self.BtnlineViewS = [[UIView alloc]init];
    self.BtnlineViewS.backgroundColor = LightGrayColor;
    [self.buttonV addSubview:self.BtnlineViewS];
    
    self.BtnlineViewL = [[UIView alloc]init];
    self.BtnlineViewL.backgroundColor = LightGrayColor;
    [self.buttonV addSubview:self.BtnlineViewL];
}

//重写模型communicationgFrame的set方法

- (void)setCommunicationgFrame:(CommunicationFrame *)communicationgFrame
{
    _communicationgFrame = communicationgFrame;
    
    //给控件赋值
    
    [self setValueForChildView];
    
    //控件Frame
    [self setUpChildViewFrame];
    
    [self hidSomeChideView];
    
}

- (void)setValueForChildView
{
    //self.iconImg =
    Communication *communication = _communicationgFrame.comunication;
    self.unameL.text = communication.uname;
    self.preFloorL.text = @"楼主";
    [self.discussB setTitle:[NSString stringWithFormat:@"%d",communication.comments] forState:UIControlStateNormal];
    self.timeL.text = communication.time;
    if (communication.name.length == 0) {
        self.nameL.text = communication.msg;
        
        
    }
    else
    {
        self.nameL.text = communication.name;
    }
    
    self.msgL.text  = communication.msg;
    self.tagL.text  = communication.tag;
    
    [self.praiseB setTitle:[NSString stringWithFormat:@"%d",communication.up] forState:UIControlStateNormal];//赞数
    //已点赞
    if (communication.isup == YES)
    {
        [self.praiseB setImage:[UIImage imageNamed:@"icon_select_laud"] forState:UIControlStateNormal];
    }
    //未点赞
    else
    {
        [self.praiseB setImage:[UIImage imageNamed:@"icon_laud"] forState:UIControlStateNormal];
    }
    [self.commentB setTitle:[NSString stringWithFormat:@"%d",communication.comments] forState:UIControlStateNormal];//评论数
}

//控件Frame
- (void)setUpChildViewFrame
{
    Communication *communication = _communicationgFrame.comunication;
    
    self.noteV.frame     = _communicationgFrame.noteVFrame;
    self.iconImg.frame   = _communicationgFrame.iconFrame;
    self.unameL.frame    = _communicationgFrame.uNameFrame;
    self.preFloorL.frame = _communicationgFrame.preFloorFrame;
    self.discussB.frame  = _communicationgFrame.discussFrame;
    self.timeL.frame     = _communicationgFrame.timeFrame;
    self.nameL.frame     = _communicationgFrame.nameFrame;
    
    self.tagV.frame = _communicationgFrame.tagVFrame;
    self.msgL.frame = _communicationgFrame.msgFrame;
    self.tagImg.frame = _communicationgFrame.iconFrame;
    self.tagL.frame = _communicationgFrame.tagFrame;
    CGFloat tagImgY = self.tagL.center.y;
    self.tagImg.frame = CGRectMake(8, tagImgY - 8, 16, 16);
    
    
    //标签之上的分割线
    CGFloat msgMaxY = CGRectGetMaxY(self.msgL.frame);
    self.tagViewLine.frame = CGRectMake(8, msgMaxY + 8, kScreen.width - 2 * 8, 1);

    
    //设置按钮上视图上的两条分割线
    CGFloat btnlineS;
    CGFloat btnlineSW;
    if (communication.name.length == 0) {
        self.tagV.hidden = YES;
        btnlineS = 0;
        btnlineSW = kScreen.width;
        
    }
    else
    {
        self.tagV.hidden = NO;
        btnlineS = 8;
        btnlineSW = kScreen.width - 2 * 8;
    }
    
    self.buttonV.frame  =_communicationgFrame.clicksVFrame;
    self.praiseB.frame = _communicationgFrame.praiseFrame;
    self.commentB.frame = _communicationgFrame.commentFrame;
    
    //设置按钮上视图上的两条分割线
    self.BtnlineViewS.frame= CGRectMake(btnlineS, 0,btnlineSW, 1);
    self.BtnlineViewL.frame = CGRectMake(0, 39, kScreen.width, 1);
    
}

//点击评论
- (void)commentClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(discussionCell:selectIndex:)])
    {
        [self.delegate discussionCell:nil selectIndex:button.tag];
    }
}

//点击点赞
- (void)praiseClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(discussionCell:praiseIndex:)]) {
        [self.delegate discussionCell:nil praiseIndex:button.tag - 500];
    }
}

//隐藏一些子控件
- (void)hidSomeChideView
{
    self.preFloorL.hidden = YES;
    self.discussB.hidden = YES;
}

//显示自控件
- (void)noHidenSomeChideView
{
    self.preFloorL.hidden = NO;
    self.discussB.hidden = NO;
}

@end
