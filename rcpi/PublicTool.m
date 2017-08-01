//
//  PublicTool.m
//  rcpi
//
//  Created by wu on 15/10/27.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "PublicTool.h"
#import "Config.h"
#include <CoreData/CoreData.h>



@implementation PublicTool

/**判断登录*/
+ (BOOL)isSuccessLogin{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"tokenID"]) {
        return YES;
    }else{
        return NO;
    }
}
//图片URL处理
+ (NSString *)isTureUrl:(NSString *)str{
    NSRange range = [str rangeOfString:@","];
    if (range.length != 0) {
       NSArray*array = [str componentsSeparatedByString:@","];
        return array[0];
    }else{
        return str;
    }

}
/**去除标签方法*/
+ (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}
/** 自适应高度*/
+ (float)heightForString:(NSString *)value font:(UIFont*)fontSize andWidth:(float)width
{
    float height = [[NSString stringWithFormat:@"%@\n",value]boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:fontSize,NSFontAttributeName, nil] context:nil].size.height;
    return height;
}
/** 是否已参与了该课程*/
+ (void)isJoinCourse:(NSString *)courseID Callback:(MyCallback)callback{
    NSString *urlType = @"/get-course";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SRV,urlType];
    NSString *tokenID = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    args[@"id"]=courseID;
    args[@"token"]=tokenID;
    if (tokenID==nil) {
        NSString *no = @"0";
        callback(no);
    }else{
        [H doGet:urlStr args:args json:^(URLRequester *req, NSData *data, NSDictionary *json, NSError *err) {
            if (err) {
                NSLog(@"网络请求失败%@",err.userInfo);
            }else {
                NSString *isJoin = json[@"data"][@"hasUserPurchased"];
                callback(isJoin);
            }
        }];

    }

}

/**动态获取文本要的长度*/
+(CGSize)widthOfLable:(NSString *)lableText font:(float)font type:(NSString *)codeType{
//@"HelveticaNeue-Light"
CGSize titleSize=[lableText sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:codeType size:font]}];
    return titleSize;

}


+(NSString *)cutString:(NSString *)arg_string f_index:(long)f_index e_index:(long)e_index{
    if (arg_string==nil||f_index>e_index) {
        return @"你在逗我!";
    }else{
        
        NSString *cutedString =[arg_string  substringWithRange:NSMakeRange(f_index,e_index) ];
        
        return cutedString;
    }

}

+(NSString *)timeFunc:(NSNumber *)time{
    
    NSDate *now = [NSDate date];
    NSTimeInterval nowDateInt = [now timeIntervalSince1970];
    NSInteger dateInt = (int)(nowDateInt - ([time integerValue] / 1000)) / 3600;
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[time integerValue] / 1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSString *timeStr = [[NSString alloc]init];
    if (dateInt <= 24 || dateInt == 0) {
        dateFormatter.dateFormat = @"HH:mm";
    }else {
        dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    timeStr = [dateFormatter stringFromDate:timeDate];
    return timeStr;
}

@end
