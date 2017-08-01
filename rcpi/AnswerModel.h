//
//  AnswerModel.h
//  rcpi
//
//  Created by wu on 15/11/23.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerModel : NSObject
@property (nonatomic,strong)NSArray *aItem;
@property (nonatomic,strong)NSString *score;
@property (nonatomic,strong)NSString *remark;
+ (instancetype)appWithDict:(NSDictionary *)dict;

+ (NSArray *)appWithArray:(NSArray *)array;
@end