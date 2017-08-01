//
//  NoteTableCell.m
//  rcpi
//
//  Created by admin on 15/12/18.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "NoteTableCell.h"
#import "NoteView.h"

@interface NoteTableCell ()

@property (nonatomic,strong)UIButton *pariseButton;
@property (nonatomic,strong)UIButton *commentButton;

@end

@implementation NoteTableCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        
    }
    return self;
}

- (void)setUpChildView
{
    
    NoteView *noteView = [[NSBundle mainBundle]loadNibNamed:@"NoteView" owner:self options:0][0];
    [self addSubview:noteView];
    
    //工具条
    self.pariseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pariseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.pariseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self addSubview:self.pariseButton];
    [self.pariseButton setImage:[UIImage imageNamed:@"icon_laud"] forState:UIControlStateNormal];
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self addSubview:self.commentButton];
    [self.commentButton setImage:[UIImage imageNamed:@"icon_laud"] forState:UIControlStateNormal];
}

//设置数值
- (void)setFuzi
{
    //从新调整位置
    
}

@end






