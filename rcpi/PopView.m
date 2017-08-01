//
//  PopView.m
//  rcpi
//
//  Created by Dc on 15/11/21.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "PopView.h"

@implementation PopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithTitleArray:(NSArray *)TitleArray imageArray:(NSArray *)imageArray Frame:(CGRect)frame delegate:(id)delegate {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.65;
        for(int i = 0; i<TitleArray.count;i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/3.5, 10+38*i, 70, 25)];
            [btn setTitle:TitleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            [self addSubview:btn];
            
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12+38*i, 20, 20)];
            img.image =imageArray[i];
            [self addSubview:img];
        }
        for(int i =0;i<TitleArray.count-1 ;i++) {
            UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(15,40 +38*i, CGRectGetWidth(self.frame) - 25, 0.3)];
            lineLab.backgroundColor = [UIColor whiteColor];
            lineLab.alpha = 0.5;
            [self addSubview:lineLab];
        }
           self.delegate = delegate;
        
    }
    return self;
}

-(void)BtnClick :(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(PopView: clickButtonAtIndex:)]) {
        [self.delegate PopView:self clickButtonAtIndex:sender.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
