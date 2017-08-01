//
//  MyCourseModel.h
//  rcpi
//
//  Created by Dyang on 15/12/2.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MyCourseModel : NSObject
@property (nonatomic,strong)NSString *bankId;//课程对应题库id
@property (nonatomic,strong)NSString *cid;//课程id
@property (nonatomic,strong)NSString *imgs;//课程封面
@property (nonatomic,strong)NSString *name;//课程名称
@property (nonatomic,assign)CGFloat process;//课程学习进度
@property (nonatomic,strong)NSString *chapterCnt;//章数
+ (instancetype)appWithDict:(NSDictionary *)dict;

@end
