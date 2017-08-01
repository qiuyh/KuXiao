//
//  AnalyzModel.h
//  rcpi
//
//  Created by wu on 15/11/23.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyzModel : NSObject

@property (nonatomic,strong)NSString *analyze;

+ (instancetype)appWithDict:(NSDictionary *)dict;

+ (NSArray *)appWithArray:(NSArray *)array;
@end
