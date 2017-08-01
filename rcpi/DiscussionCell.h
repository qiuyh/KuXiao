//
//  DiscussionCell.h
//  rcpi
//
//  Created by admin on 15/12/18.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationFrame.h"

@class DiscussionCell;
@protocol DiscussionCellDelegate <NSObject>

//评论
- (void)discussionCell:(DiscussionCell *)cell selectIndex:(NSInteger)index;

//点赞
- (void)discussionCell:(DiscussionCell *)cell praiseIndex:(NSInteger)index;

@end

@interface DiscussionCell : UITableViewCell

@property (nonatomic,weak)id<DiscussionCellDelegate> delegate;

@property (nonatomic,strong)CommunicationFrame *communicationgFrame;
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel     *unameL;
@property (nonatomic,strong)UILabel     *preFloorL;//楼主
@property (nonatomic,strong)UIButton    *discussB;
@property (nonatomic,strong)UILabel     *timeL;
@property (nonatomic,strong)UILabel     *nameL;
@property (nonatomic,strong)UILabel     *msgL;
@property (nonatomic,strong)UIImageView *tagImg;
@property (nonatomic,strong)UILabel     *tagL;
@property (nonatomic,strong)UIView      *noteV;
@property (nonatomic,strong)UIView      *tagV;
@property (nonatomic,strong)UIView      *buttonV;
@property (nonatomic,strong)UIButton    *praiseB;
@property (nonatomic,strong)UIButton    *commentB;



- (void)noHidenSomeChideView;

//@property (nonatomic,assign)CGRect iconFrame;
//@property (nonatomic,assign)CGRect uNameFrame;
//@property (nonatomic,assign)CGRect timeFrame;
//@property (nonatomic,assign)CGRect preFloorFrame;//楼主
//@property (nonatomic,assign)CGRect discussFrame;//评论数
//@property (nonatomic,assign)CGRect nameFrame;
//@property (nonatomic,assign)CGRect noteVFrame;
//
//
//@property (nonatomic,assign)CGRect msgFrame;
//@property (nonatomic,assign)CGRect tagFrame;
//@property (nonatomic,assign)CGRect tagVFrame;
//
//@property (nonatomic,assign)CGRect clicksVFrame;
//@property (nonatomic,assign)CGRect praiseFrame;
//@property (nonatomic,assign)CGRect commentFrame;
//
//@property (nonatomic,assign)CGFloat cellTagHeight;//标签之上高度
//@property (nonatomic,assign)CGFloat cellNameHeight;//主题之上高度
//@property (nonatomic,assign)CGFloat cellHeight;//总的高度


@end
