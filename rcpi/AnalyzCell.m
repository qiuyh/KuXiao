//
//  AnalyzCell.m
//  rcpi
//
//  Created by wu on 15/11/30.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "AnalyzCell.h"
#import "Config.h"
#import "AnalyzModel.h"
#import "AnswerModel.h"

@implementation AnalyzCell

- (void)awakeFromNib {

}
- (void)drawRect:(CGRect)rect{

    [self setUpContent:self desc:self.desc path:self.indexPath title:self.name];
}


-(void)setUpContent:(UICollectionViewCell*)cell desc:(NSString*)desc path:(NSIndexPath*)indexPath title:(NSString*)name{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, 150)];
    self.webView.opaque=NO;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView loadHTMLString:desc baseURL:nil];
    self.webView.scrollView.bounces = NO;


    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.webView.frame), self.width, 50)];
    titleView.userInteractionEnabled=YES;
    titleView.backgroundColor = [UIColor whiteColor];
    //设置边线
    UIView *sideLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, 1)];
    sideLine.backgroundColor = CUSTOM_COLOR(200, 200, 200);
    UIView *sideLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, titleView.height-1, kScreen.width, 1)];
    sideLine2.backgroundColor = CUSTOM_COLOR(200, 200, 200);
    [titleView addSubview:sideLine];
    [titleView addSubview:sideLine2];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 50)];
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

    CGFloat btn_W = 50.0;
    CGFloat btn_H = 25;
    UIButton *showBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.width-btn_W)/2, CGRectGetMinY(titleView.frame)-btn_H, btn_W, btn_H)];
    showBtn.alpha=0.8;

    [showBtn setImage:[[UIImage imageNamed:@"eva_shrinkage"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    //添加拖动手势
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [showBtn addGestureRecognizer:panGR];

    //设置滚动文本
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), self.width, self.height-titleView.height-self.webView.height)];
    self.scrollView.backgroundColor = [UIColor whiteColor];

    //表头
    UIView *tableViewHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 30)];
    tableViewHead.backgroundColor = CUSTOM_COLOR(250, 255, 220);
    //表头标题
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, tableViewHead.height)];
    headLabel.font = [UIFont systemFontOfSize:14];
    headLabel.text = @"本题得分：";
    headLabel.textColor = [UIColor grayColor];
    UILabel *scoresLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headLabel.frame), 0, 30, tableViewHead.height)];

    scoresLabel.font = [UIFont systemFontOfSize:14];
    scoresLabel.textColor = [UIColor orangeColor];
    [tableViewHead addSubview:headLabel];
    [tableViewHead addSubview:scoresLabel];

    //你的答案区域
    UILabel *answerTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(tableViewHead.frame), self.width, tableViewHead.height)];
    answerTitle.text = @"你的答案";
    answerTitle.textColor = CUSTOM_COLOR(200, 200, 200);
    answerTitle.font = [UIFont systemFontOfSize:14];

    //答题内容
    UILabel *answer = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(answerTitle.frame), self.width, 50)];
    answer.font = [UIFont systemFontOfSize:14];
    answer.text = @"内容加载中";
    answer.numberOfLines=0;
    //边线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(answer.frame), self.width, 1)];
    line.backgroundColor = CUSTOM_COLOR(200, 200, 200);
    //参考答案区域

    UILabel *analyzTitle = [[UILabel alloc]initWithFrame:CGRectMake(10,0, self.width, tableViewHead.height)];
    analyzTitle.font = [UIFont systemFontOfSize:14];
    analyzTitle.text = @"参考答案";
    analyzTitle.textColor = CUSTOM_COLOR(200, 200, 200);
//    analyzTitle.backgroundColor = CUSTOM_COLOR(210, 240, 215);
    //参考内容
    UILabel *analyz = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(analyzTitle.frame), self.width, 0)];
    analyz.font = [UIFont systemFontOfSize:14];
    analyz.text = @"内容加载中";
    analyz.numberOfLines=0;
    UIView *analyzView = [[UIView alloc]initWithFrame:CGRectMake(0,  CGRectGetMaxY(line.frame), self.width, tableViewHead.height)];
    //边线
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(analyzView.frame), self.width, 1)];
    line2.backgroundColor = CUSTOM_COLOR(200, 200, 200);
    //补充答案区域
    UILabel *addTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(line2.frame), self.width, tableViewHead.height)];
    addTitle.font = [UIFont systemFontOfSize:14];
    addTitle.text = @"补充答案";
    addTitle.textColor = CUSTOM_COLOR(200, 200, 200);
    //补充答案的内容
    UILabel *add = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(addTitle.frame), self.width, 0)];
    add.font = [UIFont systemFontOfSize:14];
    add.text = @"内容加载中";
    add.numberOfLines=0;

    if (self.analyzContent) {
        AnalyzModel *modelAnalyz = self.analyzContent[indexPath.row];
        AnswerModel *modelAnswer = self.answerContent[indexPath.row];
        scoresLabel.text = modelAnswer.score;
        answer.text = modelAnswer.aItem.firstObject;
        analyz.text = [PublicTool filterHTML:modelAnalyz.analyze];
        if(modelAnswer.remark.length==0){
            add.text = @"略";
        }else{
            add.text = [PublicTool filterHTML:modelAnswer.remark];
        }
    }
    float height =[PublicTool heightForString:answer.text font:answer.font andWidth:self.width];
    answer.height = height;
    float height2 =[PublicTool heightForString:analyz.text font:analyz.font andWidth:self.width];
    analyzView.height = height2+tableViewHead.height;
    float height3 =[PublicTool heightForString:add.text font:add.font andWidth:self.width];
    add.height = height3;

    line.y = CGRectGetMaxY(answer.frame);
    analyzView.y = CGRectGetMaxY(line.frame);
    line2.y = CGRectGetMaxY(analyzView.frame);
    addTitle.y = CGRectGetMaxY(line2.frame);
    add.y = CGRectGetMaxY(addTitle.frame);
//参考内容背景

    [analyzView addSubview:analyzTitle];
    [analyzView addSubview:analyz];
    analyzView.backgroundColor = CUSTOM_COLOR(210, 240, 215);


    [self.scrollView addSubview:tableViewHead];
    [self.scrollView addSubview:answerTitle];
    [self.scrollView addSubview:answer];
    [self.scrollView addSubview:line];
    [self.scrollView addSubview:analyzView];
    [self.scrollView addSubview:line2];
    [self.scrollView addSubview:addTitle];
    [self.scrollView addSubview:add];

    self.scrollView.contentSize = CGSizeMake(self.width, tableViewHead.height+answer.height+answerTitle.height*2+analyzView.height+add.height+2);
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.showBtn = showBtn;
    self.titleView = titleView;
    
    [cell addSubview:self.webView];
    [cell addSubview:self.titleView];
    [cell addSubview:self.scrollView];
    [cell addSubview:self.showBtn];


}
-(void)pan:(UIPanGestureRecognizer *)gr{
    [self endEditing:YES];
    CGPoint translation = [gr translationInView:self.superview];
    if (self.showBtn.y>=60 && self.showBtn.y <= 350) {
        self.showBtn.y += translation.y;
        self.webView.height +=translation.y;
        self.titleView.y += translation.y;
        self.scrollView.y += translation.y;
        self.scrollView.height -= translation.y;
    }

    if (self.showBtn.y<60) {
        if (translation.y>0) {
            self.showBtn.y += translation.y;
            self.webView.height += translation.y;
            self.titleView.y += translation.y;
            self.scrollView.y += translation.y;
            self.scrollView.height -= translation.y;
        }else{
            return;
        }
    }

    if (self.showBtn.y>350) {
        if (translation.y<0) {
            self.showBtn.y += translation.y;
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


}





@end

