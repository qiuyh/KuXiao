//
//  NavigationCtl.m
//  rcpi
//
//  Created by wu on 15/11/16.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "NavigationCtl.h"

@interface NavigationCtl ()

@end

@implementation NavigationCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        // 统一设置左边的返回按钮
        UIButton *btn =[[UIButton alloc]init];
        btn.frame = CGRectMake(0, 0, 25, 25);
        [btn setBackgroundImage:[UIImage imageNamed:@"com_return"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(leftbtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
        viewController.navigationItem.leftBarButtonItem = back;
    }

    [super pushViewController:viewController animated:animated];
}
- (void)leftbtnClick
{
    [self popViewControllerAnimated:YES];
}


@end
