//
//  TabbarController.m
//  kXDayang
//
//  Created by heqingliang on 15/9/15.
//  Copyright (c) 2015年 heqingliang. All rights reserved.
//

#import "TabbarController.h"
#import "FirstController.h"
#import "MyCourseController.h"
#import "DynamicController.h"
#import "MessageController.h"
#import "NavigationCtl.h"
@interface TabbarController ()

@end

@implementation TabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}
-(void)creatUI
{
    
    
    FirstController *home = [[FirstController alloc] init];
    [self addChildVc:home title:@"首页" navtitle:@"首页"  image:@"fp_Course1" selectedImage:@"fp_Course"];
    
    MyCourseController *messageCenter = [[MyCourseController alloc] init];
    [self addChildVc:messageCenter title:@"我的课程" navtitle:@"我的课程" image:@"fp_MyObject1" selectedImage:@"fp_MyObject"];
    
    DynamicController *discover = [[DynamicController alloc] init];
    [self addChildVc:discover title:@"动态" navtitle:@"动态" image:@"fp_Dynamic1" selectedImage:@"fp_Dynamic"];
    
    MessageController *messageController = [[MessageController alloc] init];
    [self addChildVc:messageController title:@"消息" navtitle:@"消息" image:@"fp_message-normal" selectedImage:@"fp_message-down"];
    
}
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title navtitle:(NSString *)navtitle image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    
    childVc.tabBarItem.title = title;
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49)];
        [view setBackgroundColor:[UIColor whiteColor]];
        [self.tabBar insertSubview:view atIndex:0];

    childVc.navigationItem.title =navtitle;

    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:62/255.0 green:224/255.0 blue:208/255.0 alpha:1.0];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    childVc.view.backgroundColor = [UIColor whiteColor];
    NavigationCtl *nav = [[NavigationCtl alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
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
