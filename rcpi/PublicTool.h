//
//  PublicTool.h
//  rcpi
//
//  Created by wu on 15/10/27.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iwf/iwf.h>
#import "Config.h"
@interface PublicTool : NSObject

typedef void (^MyCallback) (id isJoin);
/** 是否已经登陆 */
+ (BOOL)isSuccessLogin;
/** 返回正确的URL*/
+ (NSString *)isTureUrl:(NSString *)str;
/** 去除HTML标签 */
+(NSString *)filterHTML:(NSString *)html;
/** 自适应高度*/
+(float)heightForString:(NSString *)value font:(UIFont*)fontSize andWidth:(float)width;
/** 是否已参与了该课程*/
+ (void)isJoinCourse:(NSString *)courseID Callback:(MyCallback)callback;
+(CGSize)widthOfLable:(NSString *)lableText font:(float)font type:(NSString *)codeType;
/** 切割字符串专用*/
+(NSString *)cutString:(NSString *)arg_string f_index:(long)f_index e_index:(long)e_index;
/** 时间处理*/
+(NSString *)timeFunc:(NSNumber *)time;

@end
