//
//  LoadingView.h
//  rcpi
//
//  Created by user on 15/11/18.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Singleton.h"
@interface LoadingView : UIView
singleton_interface(Wait)

/**开始等待动画*/
- (void)startWaiting;
/**结束等待动画*/
- (void)stopWaiting;
@end
