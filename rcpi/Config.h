//
//  Config.h
//  rcpi
//
//  Created by Dyang on 15/9/17.
//  Copyright (c) 2015年 Dyang. All rights reserved.
//

#ifndef rcpi_Config_h
#define rcpi_Config_h

//#define SRV @"http://www.kuxiao.cn"
//#define TS_SRV @"http://sso.kuxiao.cn"

#define SRV @"http://rcp.dev.jxzy.com"
/** 登陆*/
#define TS_SRV @"http://sso.dev.jxzy.com"

//消息列表
#define MSG_SRV @"http://imsd.dev.jxzy.com"
//客服
#define KF_SRV @"http://imshs.dev.jxzy.com"
//dev server
#define IM_S @"14.23.162.172"
//讨论区
#define DC_SRV @"http://dms.dev.jxzy.com"

#define IM_PORT 19990

/** 答题*/
#define ANSWER @"http://ebs2.dev.jxzy.com/usr"

#import "PublicTool.h"
#import "UIView+Extension.h"
#import <iwf/iwf.h>
#import "DYTextView.h"
#import "LoadingView.h"

//all course page

#define kScreen [UIScreen mainScreen].bounds.size
#define XCTAssert(expression, ...) \
_XCTPrimitiveAssertTrue(self, expression, @#expression, __VA_ARGS__)
#define CUSTOM_COLOR(float1,float2,float3) [UIColor colorWithRed:float1/225.0 green:float2/225.0 blue:float3/225.0 alpha:100.0]
//TMP的路径
#define PATH_TMP [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_%@",self.aid,self.qGroupID,[[NSUserDefaults standardUserDefaults]objectForKey:@"name"]]]
// 颜色
#define WUColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define WURandomColor WUColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#endif



