//
//  DiscussEditController.m
//  rcpi
//
//  Created by admin on 15/12/17.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "DiscussEditController.h"
#define kScreen [UIScreen mainScreen].bounds.size

//背景色
#define LightGrayColor [UIColor colorWithRed:239.0 / 255 green:239.0 / 255 blue:239.0 / 255 alpha:1.0]

//楼主背景颜色
#define PREFloor [UIColor colorWithRed:3.0 / 255.0 green:180.0 / 255.0 blue:170.0 / 255.0 alpha:1.0]

@interface DiscussEditController ()<UITextViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UITextView *textView;

@property (nonatomic,strong)NSMutableArray *tagArrM;

@end

@implementation DiscussEditController

- (NSMutableArray *)tagArrM
{
    if (_tagArrM) {
        _tagArrM = [NSMutableArray array];
    }
    return _tagArrM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = LightGrayColor;
    
    //UITextField *textfield = [[UITextField alloc]init];
    [self setNav];
    
    [self addEditView];
    
        
    
   
}

/** 修改导航栏 */
-(void)setNav{
    UIButton *rightBt=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBt.frame=CGRectMake(0, 0, 40, 30);
    [rightBt setTitle:@"保存" forState:UIControlStateNormal];
    [rightBt addTarget:self action:@selector(rightbtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBt];
    
    UIButton *leftBt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftBt setTitle:@"取消" forState:UIControlStateNormal];
    [leftBt addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftBt];
    
    self.navigationItem.leftBarButtonItem=leftItem;
    self.navigationItem.rightBarButtonItem=rightItem;
    
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(kScreen.width/2-60, 10, 50, 40)];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0 green:192/255.0 blue:183/255.0 alpha:100.0]];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.text=@"编辑标签";
    lable.textColor=[UIColor whiteColor];
    lable.font=[UIFont systemFontOfSize:20];
    self.navigationItem.titleView=lable;
}

/** 标签编写视图 */
- (void)addEditView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreen.width, 500)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.contentSize = CGSizeMake(0, 500);
    [self.view addSubview:self.scrollView];
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(120, 20, 100, 40)];
    self.textView.scrollEnabled = NO;
    //self.textView.contentMode =
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:20];
    self.textView.layer.borderWidth = 2;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.cornerRadius = 10;    
    [self.scrollView addSubview:self.textView];
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSRange range = [textView.text rangeOfString:@","];
    NSLog(@"%li, %li", range.location, range.length);
    if (range.location != NSNotFound) {
        if (range.location != 0){
             NSLog(@"生成新的");
            NSString *tagStr = [textView.text substringToIndex:range.location]; // 不包括4 开区间()
            [self addTagBtnWithRect:textView.frame tagStr:tagStr];
            NSLog(@"%@",tagStr);
            textView.text = @"";
        }
        else
        {
            textView.text = @"";
        }
       
    }
    NSString *str = textView.text;
    CGRect rect = self.textView.frame;
    CGSize textSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    if (textSize.width <= 90) {
        rect.size.width = 100;
        rect.size.height = 40;
        self.textView.frame = rect;
        //在这里判断该放回原来的位置
    }
    else
    {
        
        CGSize size = [str boundingRectWithSize:CGSizeMake(kScreen.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
        CGFloat sizeHeight = size.height + 17;
        size.height = sizeHeight;
        
        CGFloat text10Sizem = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}].width;
        if (text10Sizem > kScreen.width - 20) {
            size.width = kScreen.width - 20;
        }
        else
        {
            size.width = size.width + 10;
        }
        rect.size = size;
        self.textView.frame = rect;
        CGFloat maxX = CGRectGetMaxX(self.textView.frame);
        if (maxX > kScreen.width - 10) {
            CGFloat originY = rect.origin.y + 30;
            CGFloat originX = 10;
            rect.origin.x = originX;
            rect.origin.y = originY;
            rect.size.width = size.width + 10;
            self.textView.frame = rect;
        }
    }
}

//按了,生成一个按钮

- (void)addTagBtnWithRect:(CGRect)rect tagStr:(NSString *)tagStr
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 10;
    btn.layer.borderWidth = 2;
    btn.layer.borderColor = PREFloor.CGColor;
    
    
}

//保存
- (void)rightbtnClick
{
    
}

//取消
- (void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"标签编辑销毁");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
