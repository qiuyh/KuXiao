//
//  MyMessage.h
//  rcpi
//
//  Created by Dyang on 15/12/16.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    MessageTypeMe = 0,
    MessageTypeOther = 1
}MessageType;

@interface MyMessage : NSObject
@property(nonatomic,copy) NSString *text;
@property(nonatomic,copy) NSString *time;
@property(nonatomic,assign) MessageType type;
@property(nonatomic,assign) BOOL hideTime;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)messageWithDict:(NSDictionary *)dict;
@end
