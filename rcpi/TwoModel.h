//
//  TwoModel.h
//  rcpi
//
//  Created by wu on 15/10/28.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwoModel : NSObject

//@property(nonatomic,copy)NSNumber *activityPrice;
//@property(nonatomic,copy)NSNumber *answerPrice;
//@property(nonatomic,copy)NSNumber *bankId;
//@property(nonatomic,copy)NSNumber *burdenType;
@property(nonatomic,copy)NSString *category;
//@property(nonatomic,copy)NSNumber *chapterCnt;
//@property(nonatomic,copy)NSString *courseType;
@property(nonatomic,copy)NSString *name;
//@property(nonatomic,copy)NSNumber *credit;
//@property(nonatomic,copy)NSString *ext;
@property(nonatomic,copy)NSString *imgs;
//@property(nonatomic,copy)NSNumber *teachPrice;
//@property(nonatomic,copy)NSNumber *testPrice;
//@property(nonatomic,copy)NSNumber *user;
//@property(nonatomic,copy)NSString *userName;
//@property(nonatomic,copy)NSString *guide;
@property(nonatomic,copy)NSString *id;
//@property (nonatomic,strong)NSString *totalPrice;
//@property (nonatomic,strong)NSString *status;
//@property (nonatomic,strong)NSString *joinCnt;
//@property (nonatomic,strong)NSString *levelCategory;
//@property (nonatomic,strong)NSString *paperCnt;
//@property (nonatomic,strong)NSString *reason;
//@property (nonatomic,strong)NSString *time;
//@property (nonatomic,strong)NSString *startTime;
//@property (nonatomic,strong)NSString *sectionPrice;
//@property (nonatomic,strong)NSString *sectionCnt;
//@property (nonatomic,strong)NSString *score;
//@property (nonatomic,strong)NSString *questionCnt;
//@property (nonatomic,strong)NSString *tryTime;

+ (NSArray *)listWithArray:(NSArray *)array;
+ (instancetype)appWithDict:(NSDictionary *)dict;
@end
