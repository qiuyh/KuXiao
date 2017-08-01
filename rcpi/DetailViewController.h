//
//  DetailViewController.h
//  rcpi
//
//  Created by Dc on 15/11/19.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface DetailViewController : UIViewController

@property (nonatomic ,copy)NSString *uuid;
@property (nonatomic ,copy)NSString *nameStr;
@property (nonatomic ,copy)NSString *imgUrlStr;

-(void)addBtnClick;
@end
