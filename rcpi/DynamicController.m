//
//  DynamicController.m
//  kXDayang
//
//  Created by heqingliang on 15/9/15.
//  Copyright (c) 2015年 heqingliang. All rights reserved.
//

#import "DynamicController.h"
#import "Config.h"

@interface DynamicController ()

@end

@implementation DynamicController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(kScreen.width/2-60, 10, 100, 40)];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.text=@"动态";
    lable.textColor=[UIColor whiteColor];
    lable.font=[UIFont systemFontOfSize:20];
    self.navigationItem.titleView=lable;

    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jianshe"]];
    imageView.frame = CGRectMake(0,64+20, kScreen.width,kScreen.width/1.6);
    [self.view addSubview:imageView];
}
- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    [self.view viewWithpopUp:@"还在努力的建设中..." time:1];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
