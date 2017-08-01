//
//  UserInfoController.m
//  rcpi
//
//  Created by Dyang on 15/12/3.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "UserInfoController.h"
#import "Config.h"
#import "RegisterController.h"
#import "LoginViewController.h"
@interface UserInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property ( nonatomic,retain) IBOutlet UIButton *regButton;
@property ( nonatomic,retain) IBOutlet UIButton *LogButton;
@property ( nonatomic,retain) IBOutlet UIButton *lgoButton;

@end

@implementation UserInfoController

-(void)viewWillAppear:(BOOL)animated{
    [self showButton];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setnavigation];
    [self setUserInfoTable];
    // Do any additional setup after loading the view from its nib.
}


-(void)setnavigation{
    [self.navigationItem setTitle:@"我"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
}
-(void)setUserInfoTable{
    self.userInfoTable=[[UITableView alloc]initWithFrame:CGRectMake(0, -36,kScreen.width,kScreen.height+36)style:UITableViewStyleGrouped];
    self.userInfoTable.backgroundColor=CUSTOM_COLOR(220, 220, 220);
    self.userInfoTable.delegate=self;
    self.userInfoTable.dataSource=self;
    [self.userInfoTable setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.userInfoTable];
    //cell
//    [self.userInfoTable registerNib:[UINib nibWithNibName:@"MyCourseTableViewCell" bundle:nil] forCellReuseIdentifier:CELLID];
    // hide line
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.userInfoTable setTableFooterView:view];
    self.userInfoTable.scrollEnabled=NO;
    //[self.userInfoTable setSeparatorInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
   
}
-(void)setRegLoginButton{
    //register button
    self.regButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreen.width*0.5-125, 350, 100, 40)];
    [self.regButton setTitle:@"马上注册" forState:UIControlStateNormal];
    [self.regButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.regButton.backgroundColor=[UIColor colorWithRed:251/255.0 green:112/255.0 blue:85/255.0 alpha:100];
    [self.regButton.layer setCornerRadius:5.0];
    [self.regButton addTarget:self action:@selector(jumpToRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.regButton];
    //login button
    self.LogButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreen.width*0.5+25, 350, 100, 40)];
    [self.LogButton setTitle:@"立刻登录" forState:UIControlStateNormal];
    [self.LogButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.LogButton.backgroundColor=[UIColor colorWithRed:0/255.0 green:192/255.0 blue:183/255.0 alpha:100] ;
    [self.LogButton.layer setCornerRadius:5.0];
    [self.LogButton addTarget:self action:@selector(jumpToLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.LogButton];
    
    
    
    
    
}
-(void)setLoginOutButton{
    //register button
    self.lgoButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreen.width*0.5-75, 350, 150, 40)];
    [self.lgoButton setTitle:@"注销" forState:UIControlStateNormal];
    [self.lgoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.lgoButton.backgroundColor=[UIColor redColor];
    [self.lgoButton.layer setCornerRadius:5.0];
    [self.lgoButton addTarget:self action:@selector(loginOutFunc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lgoButton];
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 100;
    }else{
        return 55;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return 2;
    
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        cell.imageView.image=[UIImage imageNamed:@"user_userHead"];
        if ([PublicTool isSuccessLogin]) {
            cell.textLabel.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
        }else{
            NSLog(@"未登录!");
            cell.textLabel.text=@"未登录";
        
        }
        
        cell.detailTextLabel.text=@"我用双手成就你的梦想";
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        
    }else{
    
        if (indexPath.row==0) {
            cell.imageView.image=[UIImage imageNamed:@"user_studentHead"];
            cell.detailTextLabel.text=@"学生身份";
            UIImageView *changeRole=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"user_roleButton"]];
            changeRole.frame=CGRectMake(kScreen.width*0.91, 15, 20, 20);
            [cell.contentView addSubview:changeRole];
            
            
        }else{
        
            cell.imageView.image=[UIImage imageNamed:@"user_set"];
            cell.detailTextLabel.text=@"设置";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        }
        
      
    
    
    }
   

  return cell;
    
}


-(void)showButton{
    [self.LogButton removeFromSuperview];
    [self.regButton removeFromSuperview];
    [self.lgoButton removeFromSuperview];
    [self.userInfoTable reloadData];
    if ([PublicTool isSuccessLogin]) {
        [self setLoginOutButton];
    }else{
        [self setRegLoginButton];
        
    }
    
}

//jump to register
- (void)jumpToRegister{
    RegisterController *Register = [[RegisterController alloc]init];
    [self.navigationController pushViewController:Register animated:YES];
}
//jump to login
- (void) jumpToLogin{
    LoginViewController *Login = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:Login animated:YES];
}

-(void)loginOutFunc {
      [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"tokenID"];
      [self showButton];
}


































































@end
