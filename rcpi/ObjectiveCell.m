//
//  ObjectiveCell.m
//  rcpi
//
//  Created by wu on 15/12/5.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "ObjectiveCell.h"

@implementation ObjectiveCell

- (void)awakeFromNib{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextView:) name:UITextViewTextDidChangeNotification object:nil];
}


- (void)textDidChange:(WuCallText)text{
    self.wu = text;
}
-(void)setUpContentAndHtml:(NSString*)strHtml sumPage:(NSInteger)sum chooseCounts:(NSInteger)count labelContent:(NSArray*)content{
    [self.webView loadHTMLString:strHtml baseURL:nil];
    self.webView.opaque=NO;
    self.webView.backgroundColor = CUSTOM_COLOR(220, 220, 220);
    NSInteger num = [self.type integerValue];
//     10:单选题;20:多选题;30:判断题;35:填空题;40:简答题;50:材料题;
    NSString *typeT;
    switch (num) {
        case 10:
            typeT = @"单选题";
            break;
        case 20:
            typeT = @"多选题";
            break;
        case 30:
            typeT = @"判断题";
            break;
        case 35:
            typeT = @"填空题";
            break;
        default:
            typeT = @"随机题";
            break;
    }

    NSString *titleT = @"全国中小学义务教育";
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)",typeT,titleT];
    NSString *key =[NSString stringWithFormat:@"%ld",self.currentPage];
    NSMutableAttributedString *pageStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/%ld",self.currentPage,sum]];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName]=[UIFont systemFontOfSize:25];
    attributes[NSForegroundColorAttributeName] = CUSTOM_COLOR(31, 191, 184);
    [pageStr addAttributes:attributes range:NSMakeRange(0, key.length)];

    self.pageLabel.font = [UIFont systemFontOfSize:14];
    self.pageLabel.attributedText = pageStr;

    [self.dragBtn setImage:[[UIImage imageNamed:@"eva_shrinkage"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    //添加拖动手势
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard:)];
    [self.titleView addGestureRecognizer:tapGR ];
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.dragBtn addGestureRecognizer:panGR];

    self.scrollView.backgroundColor = CUSTOM_COLOR(220, 220, 220);
    //清除多余的控件
    for (id obj in self.scrollView.subviews) {
        [obj removeFromSuperview];
    }
    //动态调整webview高度
//    CGFloat height_web = [PublicTool heightForString:strHtml font:[UIFont systemFontOfSize:17] andWidth:self.width];
//    //    CGFloat height_web = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
//    NSLog(@"height_web==%f",height_web);
//    if (height_web>300) {
//        self.webView.height = 300;
//    }else{
//        self.webView.height = height_web;
//    }
//
//    self.titleView.y = CGRectGetMaxY(self.webView.frame);
//    self.dragBtn.y = CGRectGetMinY(self.titleView.frame)-25;
//    self.scrollView.y = CGRectGetMaxY(self.titleView.frame);
//    self.scrollView.height = self.height - self.scrollView.y;
//  *******************选择题*************************
        CGFloat currentY=0;
    if (num==10||num==20||num==30) {
        if ([self.contentData objectForKey:key]) {
            self.answerArray = [self.contentData objectForKey:key];
        }else{
            self.answerArray = [NSMutableArray array];
            for (int i=0; i<count; i++) {
                [self.answerArray addObject:@0];
            }
        }
        for (int i=0; i<count; i++) {
            UIButton *btn = [[UIButton alloc]init];
            btn.frame = CGRectMake(20, 20+currentY, 30, 30);
            [btn setTitleColor:CUSTOM_COLOR(31, 191, 184) forState:0];
            btn.backgroundColor = [UIColor whiteColor];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:15];
            [btn.layer setBorderColor:[CUSTOM_COLOR(31, 191, 184) CGColor]];
            [btn.layer setBorderWidth:1];
            btn.tag = i;
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            UIImage *select = [UIImage imageWithColor:CUSTOM_COLOR(31, 191, 184)];
            UIImage *normal = [UIImage imageWithColor:[UIColor whiteColor]];

            btn.selected = (BOOL)[self.answerArray[i]intValue];
            [btn setBackgroundImage:select forState:UIControlStateSelected];
            [btn setBackgroundImage:normal forState:UIControlStateNormal];
            //单选，多选
            if (num ==10||num==20) {
                NSArray *btnTitles = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",nil];
                [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn setTitleColor:CUSTOM_COLOR(31, 191, 184) forState:UIControlStateNormal];
            }

            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+5, btn.y, self.width-CGRectGetMaxX(btn.frame)-5, 50)];
            label.text = [PublicTool filterHTML:content[i][@"content"]];
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:14];
            CGFloat labelH = [PublicTool heightForString:label.text font:label.font andWidth:self.width-55];
            label.height =labelH;
            currentY = currentY+labelH+10;
            [self.scrollView addSubview:btn];
            [self.scrollView addSubview:label];
        }

    }else if (num==35){
        //  *******************填空题*************************
            self.scrollView.backgroundColor = [UIColor whiteColor];
        if ([self.contentData objectForKey:key]) {
            self.answerArray = [self.contentData objectForKey:key];
        }else{
            self.answerArray = [NSMutableArray array];
            for (int i=0; i<count; i++) {
                [self.answerArray addObject:@""];
            }
        }
        for (int i=0; i<count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, currentY+10, 25, 40)];
            label.text = [NSString stringWithFormat:@"%d.",i+1];
            label.textColor = CUSTOM_COLOR(31, 191, 184);
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), label.y, self.width-CGRectGetMaxX(label.frame)-5, 40)];
            textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.placeholder = @"请作答";
            textField.layer.cornerRadius=8.0f;
            textField.layer.masksToBounds=YES;
            textField.layer.borderColor=[CUSTOM_COLOR(31, 191, 184)CGColor];
            textField.layer.borderWidth= 1.0f;
            textField.tag = i;
            [textField addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingDidEnd];
            textField.text = self.answerArray[i];
            [self.scrollView addSubview:label];
            [self.scrollView addSubview:textField];
            currentY = currentY+40+5;
        }
    }else if (num==40){
        //  *******************简答题*************************
        if ([self.contentData objectForKey:key]) {
            self.answerArray = [self.contentData objectForKey:key];
        }else{
            self.answerArray = [NSMutableArray array];
            [self.answerArray addObject:@""];
        }

        _textView = [[DYTextView alloc]initWithFrame:self.scrollView.bounds];
        _textView.text = self.answerArray[0];
        _textView.bounces = NO;
        _textView.placehoder = @"请输入你的答案";
        [self.scrollView addSubview:_textView];
        currentY = self.scrollView.height-10;
    }
    self.scrollView.contentSize = CGSizeMake(self.width,currentY+10);
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.bounces=NO;
}
- (void)changeText:(UITextField*)sender{
    [self.answerArray replaceObjectAtIndex:sender.tag withObject:sender.text];
    NSString *key = [NSString stringWithFormat:@"%ld",self.currentPage];
    [self.contentData setObject:self.answerArray forKey:key];
    [self.contentData writeToFile:PATH_TMP atomically:YES];

}

- (void)clickBtn:(UIButton*)sender{
    NSInteger num = [self.type integerValue];
    if (num==10||num==30) {
        //单选、判断
        for (id obj in self.scrollView.subviews) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *bb=obj;
                bb.selected=NO;
                [self.answerArray replaceObjectAtIndex:bb.tag withObject:@0];
            }
        }
        sender.selected = YES;
        [self.answerArray replaceObjectAtIndex:sender.tag withObject:@1];
        [self.obj nextItems:self.currentPage];
    }else if (num==20){
        //多选
            sender.selected = !sender.selected;
            int yesOrNo = !(BOOL)[[self.answerArray objectAtIndex:sender.tag]intValue];
            [self.answerArray replaceObjectAtIndex:sender.tag withObject:[NSNumber numberWithInt:yesOrNo]];
    }
        //本地储存
     NSString *key = [NSString stringWithFormat:@"%ld",self.currentPage];
    [self.contentData setObject:self.answerArray forKey:key];
     [self.contentData writeToFile:PATH_TMP atomically:YES];

}
-(void)pan:(UIPanGestureRecognizer *)gr{
    [self endEditing:YES];
    CGPoint translation = [gr translationInView:self];
    if (self.dragBtn.y>=60 && self.dragBtn.y <= 350) {
        self.dragBtn.y += translation.y;
        self.webView.height +=translation.y;
        self.titleView.y += translation.y;
        self.scrollView.y += translation.y;
        self.scrollView.height -= translation.y;

    }

    if (self.dragBtn.y<60) {
        if (translation.y>0) {
            self.dragBtn.y += translation.y;
            self.webView.height += translation.y;
            self.titleView.y += translation.y;
            self.scrollView.y += translation.y;
            self.scrollView.height -= translation.y;
        }else{
            return;
        }
    }

    if (self.dragBtn.y>350) {
        if (translation.y<0) {
            self.dragBtn.y += translation.y;
            self.webView.height += translation.y;
            self.titleView.y += translation.y;
            self.scrollView.y += translation.y;
            self.scrollView.height -= translation.y;

        }else{
            return;
        }
    }
    //将本次增量位移归零
    [gr setTranslation:CGPointZero inView:self];
    if (self.textView) {
        self.textView.height = self.scrollView.height;
    }
}

- (void)closeKeyboard:(NSNotification *)notification{
    [self endEditing:YES];
    self.scrollView.height = self.height -self.scrollView.y;
    if (self.textView) {
        self.textView.height = self.scrollView.height;
        self.scrollView.contentSize = CGSizeMake(self.width,_textView.height);
    }

}

- (void)openKeyboard:(NSNotification *)notification{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.dragBtn.y = 100;
    self.webView.height = self.dragBtn.y+25;
    self.scrollView.y = 190;
    self.scrollView.height = keyboardFrame.origin.y-CGRectGetMinY(self.scrollView.frame)-60;
    self.titleView.y = CGRectGetMaxY(self.dragBtn.frame);

    if (self.textView) {
        self.textView.height = self.scrollView.height-5;
        self.scrollView.contentSize = CGSizeMake(self.width,_textView.height);
    }

}
-(void)changeTextView:(NSNotification *)notification{
        if (self.wu) {
            self.wu(self.textView.text);
        }
}


@end
