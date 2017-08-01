//
//  CommentModel.h
//  rcpi
//
//  Created by admin on 15/12/21.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface CommentModel : NSObject

@property (nonatomic,copy)NSString *topicId;//主题id 帖子
@property (nonatomic,copy)NSString *uname;//发帖人
@property (nonatomic,copy)NSString *uid;//发帖人id
@property (nonatomic,copy)NSString *msg;//评论内容
@property (nonatomic,copy)NSString *floorNo;//楼层
@property (nonatomic,copy)NSString *type;//主题类别
@property (nonatomic,copy)NSString *time;//发表时间
@property (nonatomic,copy)NSString *up;//点赞数
@property (nonatomic,copy)NSString *pid;//
@property (nonatomic,copy)NSString *tid;
@property (nonatomic)BOOL isup;//是否已点赞,你

@property (nonatomic,assign)CGFloat msgHeight;
@property (nonatomic,assign)CGFloat cellHeight;


- (instancetype)initWithDic:(NSDictionary *)dic;



@end
