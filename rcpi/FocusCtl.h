//
//  FocusCtl.h
//  rcpi
//
//  Created by wu on 15/10/27.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface FocusCtl : UIViewController
@property (nonatomic,strong)NSArray *arrays;
- (void)showImages:(NSArray*)images;
@end
