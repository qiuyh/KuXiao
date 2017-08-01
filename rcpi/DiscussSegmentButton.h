//
//  DiscussSegmentButton.h
//  rcpi
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscussSegmentButton : UIView

@property (nonatomic,strong)UIButton *noteButton;
@property (nonatomic,strong)UIButton *answerButton;
@property (nonatomic,strong)UIButton *discussButton;
@property (nonatomic,strong)UIImageView *bottomImageView;
@property (nonatomic,assign)NSInteger selectedIndex;


@end
