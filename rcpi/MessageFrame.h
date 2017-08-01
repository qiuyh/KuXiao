//
//  MessageFrame.h
//  rcpi
//
//  Created by Dyang on 15/12/16.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MyMessage.h"
@interface MessageFrame : NSObject
@property(nonatomic,strong) MyMessage *message;
@property(nonatomic,assign,readonly) CGRect timeF;
@property(nonatomic,assign,readonly) CGRect textF;
@property(nonatomic,assign,readonly) CGRect iconF;
@property(nonatomic,assign,readonly) CGFloat cellHeight;
@end
