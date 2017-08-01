//
//  ValidateString.m
//  rcpi
//
//  Created by wu on 15/9/24.
//  Copyright (c) 2015年 Dyang. All rights reserved.
//

#import "ValidateString.h"

@implementation ValidateString

+(BOOL)isEmpty:(NSString *)text{
    NSRange rangeName = [text rangeOfString:@" "];
    NSUInteger  blank = (NSUInteger)rangeName.length;
    return blank;
}

+(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}
+(BOOL)isValidNumber:(NSString *)num{
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:num];
}
@end
