//
//  PopView.h
//  rcpi
//
//  Created by Dc on 15/11/21.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopView : UIView

@property (nonatomic, weak) id delegate;

-(id)initWithTitleArray:(NSArray *)TitleArray imageArray:(NSArray *)imageArray Frame:(CGRect)frame delegate:(id)delegate;

@end

@protocol PoPViewDelegate <NSObject>

@optional

-(void)PopView:(PopView *)PopView clickButtonAtIndex:(NSInteger)buttonIndex;

@end