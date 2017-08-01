//
//  DisccussTool.h
//  rcpi
//
//  Created by admin on 15/12/20.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisccussTool : NSObject

typedef void (^MyCallback) (id discussionData);

@property (nonatomic,strong)NSString *courseID;



//讨论数据请求 page 为请求第几页数据
- (void)postListTopicDataWithpage:(NSString *)page andCallBack:(MyCallback)callback;

//获取评论数据
- (void)getlistCommentDataWithpage:(NSString *)page topicId:(NSString *)topicId andCallBack:(MyCallback)callback;




@end
