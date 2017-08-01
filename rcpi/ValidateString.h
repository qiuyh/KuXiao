//
//  ValidateString.h
//  rcpi
//
//  Created by wu on 15/9/24.
//  Copyright (c) 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateString : NSObject
//是否为空
+(BOOL)isEmpty:(NSString *)text;
//是否邮件格式
+(BOOL)isValidateEmail:(NSString *)email;
//是否全为数字
+(BOOL)isValidNumber:(NSString *)num;

@end
