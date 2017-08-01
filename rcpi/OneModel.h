//
//  OneModel.h
//  
//
//  Created by wu on 15/10/13.
//
//

#import <Foundation/Foundation.h>
#import "TwoModel.h"
@interface OneModel : NSObject
@property (nonatomic,strong)NSString *key;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSArray *list;

+ (instancetype)appWithDict:(NSDictionary *)dict;

+ (NSArray *)appWithArray:(NSArray *)array;





@end
