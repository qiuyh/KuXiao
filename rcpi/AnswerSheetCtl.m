//
//  AnswerSheetCtl.m
//  rcpi
//
//  Created by wu on 15/12/16.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "AnswerSheetCtl.h"
#import "Config.h"
@interface AnswerSheetCtl ()
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

@implementation AnswerSheetCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    if (self.alreadyAnswer) {
        [self analyzName:self.name count:self.counts];
        [self.sendBtn setTitle:@"退出" forState:UIControlStateNormal];
    }else{
        [self answerCardName:self.name content:self.contentData count:self.counts types:self.types];
    }


}
- (void)analyzName:(NSString*)name count:(NSInteger)counts{
    self.titleLabel.text = name;

    CGFloat btnW = (kScreen.width-120)/5;
    int horizontal = 0;
    int vertical = 0;
    for (int i=0; i<counts; i++) {
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
        if (self.currentPage==i) {
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

- (void)setUpNav{
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, kScreen.width, 64)];
    navBar.tintColor = [UIColor yellowColor];
    navBar.backgroundColor = [UIColor redColor];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"eva_close"] forState:0];
    [backBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@"答题卡"];
    item.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    navBar.items = [NSArray arrayWithObject:item];

    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    [self.view addSubview:navBar];
    self.sendBtn.backgroundColor = CUSTOM_COLOR(31, 191, 184);

}

- (void)answerCardName:(NSString*)name content:(NSMutableDictionary*)contentData count:(NSInteger)counts types:(NSArray*)types{
    self.titleLabel.text = name;

        CGFloat btnW = (kScreen.width-120)/5;
        int horizontal = 0;
        int vertical = 0;
        for (int i=0; i<counts; i++) {
            //是否已经作答
            BOOL wu = NO;
            if ([contentData objectForKey:[NSString stringWithFormat:@"%d",(i+1)]]) {
                if ([types[i]integerValue]==35) {
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

- (void)clickBtn:(UIButton*)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.alreadyAnswer) {
        [self.analy.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:btn.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }else{
        [self.obj.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:btn.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }

}
- (void)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//提交答题
- (IBAction)sendExam:(UIButton *)sender {
    
    if (self.alreadyAnswer) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.analy comeback];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.obj upLoadData];

    }
}

@end
