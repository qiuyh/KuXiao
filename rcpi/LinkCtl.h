//
//  LinkCtl.h
//  rcpi
//
//  Created by wu on 15/11/2.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkCtl : UIViewController
@property (nonatomic,strong)NSURL *url;
- (void)getBack;
-(BOOL)shouldAutorotate;
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;
@end
