//
//  CommunicationFrame.h
//  rcpi
//
//  Created by admin on 15/12/20.
//  Copyright © 2015年 Dyang. All rights reserved.

////  模型 + 对应控件的frame

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Communication.h"

@interface CommunicationFrame : NSObject

@property (nonatomic,strong)Communication *comunication;

@property (nonatomic,assign)CGRect iconFrame;
@property (nonatomic,assign)CGRect uNameFrame;
@property (nonatomic,assign)CGRect timeFrame;
@property (nonatomic,assign)CGRect preFloorFrame;//楼主
@property (nonatomic,assign)CGRect discussFrame;//评论数
@property (nonatomic,assign)CGRect nameFrame;
@property (nonatomic,assign)CGRect noteVFrame;


@property (nonatomic,assign)CGRect msgFrame;
@property (nonatomic,assign)CGRect tagFrame;
@property (nonatomic,assign)CGRect tagVFrame;

@property (nonatomic,assign)CGRect clicksVFrame;
@property (nonatomic,assign)CGRect praiseFrame;
@property (nonatomic,assign)CGRect commentFrame;

@property (nonatomic,assign)CGFloat cellTagHeight;//标签之上高度
@property (nonatomic,assign)CGFloat cellNameHeight;//主题之上高度
@property (nonatomic,assign)CGFloat cellHeight;//总的高度




@end
