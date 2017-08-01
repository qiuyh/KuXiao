//
//  ExamCell.m
//  rcpi
//
//  Created by wu on 15/11/29.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "ExamCell.h"
#import "Config.h"
@implementation ExamCell


- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(dyText:text:) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];

}
- (void)drawRect:(CGRect)rect{

        if ([[NSFileManager defaultManager] fileExistsAtPath:PATH_TMP]) {
            _textContent = [[NSMutableDictionary alloc]initWithContentsOfFile:PATH_TMP];
        }else{
            _textContent = [NSMutableDictionary dictionary];
        }
    [self setUpContent:self desc:self.desc path:self.indexPath title:self.name];
}


-(void)setUpContent:(UICollectionViewCell*)cell desc:(NSString*)desc path:(NSIndexPath*)indexPath title:(NSString*)name{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width-10, 150)];
    self.webView.opaque=NO;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView loadHTMLString:desc baseURL:nil];
    self.webView.scrollView.bounces = NO;

    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.webView.frame), self.width, 50)];
    titleView.userInteractionEnabled=YES;
    titleView.backgroundColor = [UIColor whiteColor];
    //设置边线
    UIView *sideLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width-10, 1)];
    sideLine.backgroundColor = CUSTOM_COLOR(200, 200, 200);
    UIView *sideLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, titleView.height-1, kScreen.width-10, 1)];
    sideLine2.backgroundColor = CUSTOM_COLOR(200, 200, 200);
    [titleView addSubview:sideLine];
    [titleView addSubview:sideLine2];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 50)];
    titleLabel.text = @"常识题";
    titleLabel.textColor = CUSTOM_COLOR(57, 86, 85);
    titleLabel.font = [UIFont systemFontOfSize:18];

    UILabel *examTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0,30+titleLabel.width*2, titleView.height)];
    //设置题目
    //        NSString *examStr = name;
    NSString *examStr = @"人教版小学5年级";
    examTitle.text = [NSString stringWithFormat:@"(%@)",examStr];
    examTitle.textColor = CUSTOM_COLOR(57, 86, 85);
    examTitle.font = [UIFont systemFontOfSize:18];
    //设置页码
    UILabel *pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width-titleLabel.width, 0, titleLabel.width, titleLabel.height)];
    NSString *currentPage =[NSString stringWithFormat:@"%ld",indexPath.row+1];
    NSMutableAttributedString *pageStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%ld",currentPage,(unsigned long)self.dataArray.count]];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName]=[UIFont systemFontOfSize:25];
    attributes[NSForegroundColorAttributeName] = CUSTOM_COLOR(20, 182, 170);
    [pageStr addAttributes:attributes range:NSMakeRange(0, currentPage.length)];

    pageLabel.font = [UIFont systemFontOfSize:14];
    pageLabel.attributedText = pageStr;

    [titleView addSubview:titleLabel];
    [titleView addSubview:examTitle];
    [titleView addSubview:pageLabel];
    UIView *baffleView = [[UIView alloc]initWithFrame:titleView.bounds];
    baffleView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:baffleView];
    self.textView = [[DYTextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), self.width, self.height-titleView.height-self.webView.height)];
    self.textView.delegateDY = self;

    NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    self.textView.text = [self.textContent objectForKey:key];
    if (self.textView.text.length==0) {
        self.textView.placehoder = @"请输入你的答案";
        self.textView.placehoderColor = CUSTOM_COLOR(200, 200, 200);
    }

    CGFloat btn_W = 50.0;
    CGFloat btn_H = 25;
    self.textView.backgroundColor=[UIColor whiteColor];
    UIButton *showBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.width-btn_W)/2, CGRectGetMinY(titleView.frame)-btn_H, btn_W, btn_H)];
    showBtn.alpha=0.8;
    [showBtn setImage:[[UIImage imageNamed:@"eva_shrinkage"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

    //设置手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard:)];
    [baffleView addGestureRecognizer:tapGR];

    //添加拖动手势
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [showBtn addGestureRecognizer:panGR];
    self.showBtn = showBtn;
    self.titleView = titleView;

    [cell addSubview:self.titleView];
    [cell addSubview:self.textView];
    [cell addSubview:self.webView];
    [cell addSubview:self.showBtn];

}
-(void)pan:(UIPanGestureRecognizer *)gr{
    [self endEditing:YES];
    CGPoint translation = [gr translationInView:self.superview];
    if (self.showBtn.y>=60 && self.showBtn.y <= 350) {
        self.showBtn.y += translation.y;
        self.webView.height +=translation.y;
        self.titleView.y += translation.y;
        self.textView.y += translation.y;
        self.textView.height -= translation.y;
    }

    if (self.showBtn.y<60) {
        if (translation.y>0) {
            self.showBtn.y += translation.y;
            self.webView.height += translation.y;
            self.titleView.y += translation.y;
            self.textView.y += translation.y;
            self.textView.height -= translation.y;
        }else{
            return;
        }
    }

    if (self.showBtn.y>350) {
        if (translation.y<0) {
            self.showBtn.y += translation.y;
            self.webView.height += translation.y;
            self.titleView.y += translation.y;
            self.textView.y += translation.y;
            self.textView.height -= translation.y;

        }else{
            return;
        }
    }
    //将本次增量位移归零
    [gr setTranslation:CGPointZero inView:self];

}
- (void)dyText:(DYTextView *)textView text:(NSString *)text{

    [self saveData:self.indexPath.row];
}


- (void)saveData:(NSInteger)row{
    NSString *key = [NSString stringWithFormat:@"%ld",(long)row];
    [self.textContent setObject:self.textView.text forKey:key];
    NSLog(@"字典里面--%@",self.textContent);
    [self.textContent writeToFile:PATH_TMP atomically:YES];
}
- (void)closeKeyboard:(NSNotification *)notification{
    self.textView.height = self.height- CGRectGetMinY(self.textView.frame);
    [self endEditing:YES];
}

- (void)openKeyboard:(NSNotification *)notification{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //获取键盘弹起时的动画选项
    UIViewAnimationOptions option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    //获取键盘弹起是得动画时长
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //将新的位置赋给inputView
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        weakSelf.showBtn.y = 70;
        weakSelf.titleView.y = CGRectGetMaxY(self.showBtn.frame);
        weakSelf.webView.height = CGRectGetMaxY(self.showBtn.frame);
        weakSelf.textView.y = CGRectGetMaxY(self.titleView.frame);
        weakSelf.textView.height = keyboardFrame.origin.y-CGRectGetMinY(self.textView.frame)-60;
        
    } completion:nil];
    
}

@end
