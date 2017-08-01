//
//  CommuicationCell.m
//  rcpi
//
//  Created by admin on 15/12/20.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "CommuicationCell.h"
#import "Config.h"

#define CELLMARGIN   8
////昵称
//#define UNAMEFont [UIFont systemFontOfSize:18]
//
////时间
#define TimeFont [UIFont systemFontOfSize:13]

////主题
//#define NameFont [UIFont systemFontOfSize:18]
//正文
#define MSGFont [UIFont systemFontOfSize:15]
//昵称文字颜色
#define UNAMECOLOR [UIColor colorWithRed:43.0 / 255.0 green:127.0 / 255.0 blue:251.0 / 255.0 alpha:1.0]
#define LightGrayColor [UIColor colorWithRed:239.0 / 255 green:239.0 / 255 blue:239.0 / 255 alpha:1.0]


@implementation CommuicationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setUpAllChildView];
    }
    return self;
}


- (void)setUpAllChildView
{
    self.iconImg = [[UIImageView alloc]init];
    self.iconImg.image = [UIImage imageNamed:@"默认头像"];
    [self addSubview:self.iconImg];
    
    self.unameL = [[UILabel alloc]init];
    self.unameL.font = MSGFont;
    self.unameL.textColor = UNAMECOLOR;
    [self addSubview:self.unameL];
    
    self.praiseB = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.praiseB setImage:[UIImage imageNamed:@"icon_laud"] forState:UIControlStateNormal];
    self.praiseB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.praiseB.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    [self addSubview:self.praiseB];
    self.praiseB.backgroundColor = [UIColor redColor];
    
    self.timeAndFloorL = [[UILabel alloc]init];
    self.timeAndFloorL.font = TimeFont;
    self.timeAndFloorL.textColor = [UIColor lightGrayColor];
    [self addSubview:self.timeAndFloorL];
    
    self.msgL = [[UILabel alloc]init];
    self.msgL.numberOfLines = 0;
    //self.msgL.textColor = UNameTitleColor;
    self.msgL.font = MSGFont;
    [self addSubview:self.msgL];

}

- (void)setCommentModel:(CommentModel *)commentModel
{
    _commentModel = commentModel;
    
    [self setValueForChildView];
    
    [self setFrameForChildView];
    
    
}

- (void)setValueForChildView
{
//    @property (nonatomic,strong)UIImageView *iconImg;
//    @property (nonatomic,strong)UILabel     *unameL;
//    @property (nonatomic,strong)UILabel     *timeAndFloorL;//楼层和时间
//    @property (nonatomic,strong)UIButton    *praiseB;
//    @property (nonatomic,strong)UILabel     *msgL;
    
    //self.icon;
    self.unameL.text = _commentModel.uname;
    self.timeAndFloorL.text = _commentModel.time;
    self.msgL.text = _commentModel.msg;
    [self.praiseB setTitle:_commentModel.up forState:UIControlStateNormal];

}

- (void)setFrameForChildView
{
    //头像
    CGFloat iconX = CELLMARGIN;
    CGFloat iconY = CELLMARGIN;
    CGFloat iconW = 35;
    CGFloat iconH = 35;
    self.iconImg.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //昵称
    CGFloat unameX = CGRectGetMaxX(self.iconImg.frame) + CELLMARGIN;
    CGFloat unameY = 10;
    CGSize  unameSize = [_commentModel.uname sizeWithAttributes:@{NSFontAttributeName:MSGFont}];
    self.unameL.frame = CGRectMake(unameX, unameY, unameSize.width, unameSize.height);

    //评论数
    CGFloat praiseBX =  kScreen.width - 55- CELLMARGIN;
    CGFloat praiseBY = CELLMARGIN;
    CGFloat praiseBW = 55;
    CGFloat praiseBH = 22;
    self.praiseB.frame = CGRectMake(praiseBX, praiseBY, praiseBW, praiseBH);
    
    //时间
    CGFloat timeX = unameX;
    CGFloat timeY = CGRectGetMaxY(self.iconImg.frame) - 12;
    CGFloat timeW = 200;
    CGFloat timeH = 12;
    self.timeAndFloorL.frame = CGRectMake(timeX, timeY, timeW, timeH);
    
    //主题
    CGFloat msgX = CELLMARGIN;
    CGFloat msgY = CGRectGetMaxY(self.iconImg.frame) + CELLMARGIN;
    CGFloat msgW = kScreen.width - 2 * CELLMARGIN;
    CGFloat msgH = _commentModel.msgHeight;
    self.msgL.frame = CGRectMake(msgX, msgY, msgW, msgH);


}

- (void)drawRect:(CGRect)rect

{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    
    CGContextFillRect(context, rect);
    
    //上分割线，
    
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 0.5));
    
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
