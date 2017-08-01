//
//  AnswerCardCell.m
//  rcpi
//
//  Created by wu on 15/12/14.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "AnswerCardCell.h"
#import "Config.h"

@implementation AnswerCardCell

- (void)awakeFromNib {
    self.sendBtn.backgroundColor = CUSTOM_COLOR(31, 191, 184);
    self.continueBtn.backgroundColor = CUSTOM_COLOR(31, 191, 184);
}


-(void)clickBtn:(UIButton*)sender{
    NSString *btnTag = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    if (self.wu) {
        self.wu(btnTag);
    }
}

- (void)answerCardAndButtonAction:(WuCallback)btn{
    self.wu = btn;
}
- (IBAction)updata:(UIButton*)sender {
    NSString *btnTag = @"10000";
    if (self.wu) {
        self.wu(btnTag);
    }
}
- (IBAction)continueAnswer:(UIButton *)sender {
    sender.tag = 0;
    [self clickBtn:sender];
}

- (void)answerCardName:(NSString*)name content:(NSMutableDictionary*)contentData count:(NSInteger)counts types:(NSArray*)types{
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 1)];
    leftLabel.centerY = self.titleView.centerY;
    leftLabel.backgroundColor = CUSTOM_COLOR(200, 200, 200);
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"eva_short-answerQuestion"]];
    imageView.frame = CGRectMake(CGRectGetMaxX(leftLabel.frame)+10, 0, 20, 20);
    imageView.centerY = self.titleView.centerY;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, 0, 75, 30)];
    titleLabel.text = name;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:17 weight:0.05];
    titleLabel.centerY = self.titleView.centerY;
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, self.width, 1)];
    rightLabel.backgroundColor = CUSTOM_COLOR(200, 200, 200);
    rightLabel.centerY = self.titleView.centerY;

    [self addSubview:leftLabel];
    [self addSubview:imageView];
    [self addSubview:titleLabel];
    [self addSubview:rightLabel];


    CGFloat btnW = (kScreen.width-120)/5;
    int horizontal = 0;
    int vertical = 0;
    for (int i=0; i<counts; i++) {
       //是否已经作答
    BOOL wu = NO;
    if ([contentData objectForKey:[NSString stringWithFormat:@"%d",(i+1)]]) {
            if ([types[i]integerValue]==35||[types[i]integerValue]==40) {
                NSArray *answerArray = [contentData objectForKey:[NSString stringWithFormat:@"%d",i+1]];
                for (NSString *str in answerArray) {
                    if (str.length!=0) {
                        wu = YES;
                    }
                }
            }else{
                wu=YES;
            }

        }
        if (i%5==0&&i!=0) {
            horizontal=0;
            vertical=vertical+btnW+5;
        }
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((20+btnW)*horizontal+15,vertical,btnW, btnW)];
        [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:0];
        [btn setTitleColor:CUSTOM_COLOR(31, 191, 184) forState:0];
        btn.backgroundColor = [UIColor whiteColor];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:btnW/2];
        [btn.layer setBorderColor:[CUSTOM_COLOR(200, 200, 200) CGColor]];
        [btn.layer setBorderWidth:1];
        btn.tag = i;
        if (wu) {
            btn.backgroundColor = CUSTOM_COLOR(31, 191, 184);
            [btn setTitleColor:[UIColor whiteColor] forState:0];
        }
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        horizontal +=1;
        [self.scrollView addSubview:btn];
    }
    self.scrollView.contentSize = CGSizeMake(0, vertical+btnW);
    self.scrollView.bounces = NO;
}

@end
