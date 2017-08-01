//
//  AppDelegate.m
//  rcpi
//
//  Created by Dyang on 15/11/30.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "AppDelegate.h"
#import "TabbarController.h"
#import "ChatContentList.h"
#import "ContactList.h"
#import "ChatController.h"
@interface AppDelegate ()<NSImH>
//im
@property(retain)NSIm* im;
@property(assign)int imc;
@property(retain)NSThread* imThread;//thread fot im
@end

@implementation AppDelegate
static AppDelegate* adelegate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     adelegate=self;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    TabbarController *controller=[[TabbarController alloc]init];
    UINavigationController* nv=[[UINavigationController alloc]initWithRootViewController:controller];
    self.window.rootViewController=nv;
    nv.navigationBarHidden=YES;
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //打开本地数据库
    [self openMsgDB];
    //im初始化
    self.im=[[NSIm alloc]initWith:IM_S port:IM_PORT];
    self.im.delegate=self;
    //开启线程监听
    self.imThread=[[NSThread alloc]initWithTarget:self selector:@selector(run_im) object:nil];
    [self.imThread start];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

//im func
//开启Im
- (void)run_im{
    NSILog(@"%@",@"the im thread start");
    [self.im run:0];
    NSILog(@"%@",@"the im thread is done...");
}
//消息接收
/**
 i:ID
 s:发送者ID
 r:接收者ID
 t:类型
 d:无效
 c:消息内容
 a:可见
 time:时间
 **/
-(int)onMsg:(NSIm*)im msg:(ImMsg*) msg{
    NSLog(@"all msg %@",msg);
    NSILog(@"receive message from %@->%@--->%d", msg.r, [msg.c UTF8String],msg.t);
    self.imc++;
//-----------------------------------------------------------------------------------
    //聊天信息实体
    ChatContentList *contentEntity = [NSEntityDescription insertNewObjectForEntityForName:@"ChatContentList" inManagedObjectContext:self.MSG_CONTEXT];

    //NSLog(@"date========%@",dateStr)
    contentEntity.chat_content=[msg.c UTF8String];//消息内容
    contentEntity.chat_time=@(msg.time);//消息时间
    NSString *r_id=msg.r[0];
    contentEntity.r_id=[PublicTool cutString:r_id f_index:2 e_index:r_id.length-2];//消息接收者
    contentEntity.s_id=[PublicTool cutString:msg.s f_index:2 e_index:msg.s.length-2];//消息发送者
    contentEntity.m_type=@(msg.t);//消息类型
    contentEntity.m_id=msg.i;//消息ID
    contentEntity.u_id=[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];//当前用户ID
    NSError *err = nil;
    [self.MSG_CONTEXT save:&err];
    
    
    if (err) {
        NSLog(@"新消息存储失败%@",err);
    }else {
        [im mr:msg.a mids:msg.i];//通知服务器消息已经获取，无需再次发送
        NSLog(@"新消息存储成功!");
    }
    //通知更新
     [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMessageListNotification" object:nil userInfo:@{@"MsgCount":@(self.imc)}];
//-----------------------------------------------------------------------------------
    return 0;
}


//发送消息
-(void)sendMessageWithMsg:(NSString *)msg AndUid:(NSString *)uid {
    ImMsgBuilder* mb=[ImMsgBuilder new];
    NSLog(@"%@--->",uid);
    [[[mb setRArray:[NSArray arrayWithObjects:uid, nil]]setT:0]setC:[msg dataUsingEncoding:NSUTF8StringEncoding]];
    int code=[self.im sms:[mb build]];
    if(code!=0){
        NSLog(@"发送消息失败");
        NSELog(@"发送消息失败%d", code);
        NSLog(@"return code->%d",code);
    }else{
      NSLog(@"接收id ： %@",uid);
      NSLog(@"发送消息成功%@",msg);
    
    }
}


-(BOOL)saveMsg{
    return YES;
}
//开启sck连接
-(void)onSckEvn:(NSIm *)im evn:(int)evn arga:(void *)arga argb:(void *)argb{
    switch (evn) {
        case V_CWF_NETW_SCK_EVN_RUN:
            NSILog(@"start runner->%d", evn);
            break;
        case V_CWF_NETW_SCK_EVN_CLOSED:
            NSILog(@"socket closed->%d", evn);
            break;
        case V_CWF_NETW_SCK_EVN_CON_S:
            NSILog(@"start connect->%d", evn);
            break;
        case V_CWF_NETW_SCK_EVN_CON_D:
            NSILog(@"%@",@"V_CWF_NETW_SCK_EVN_CON_D");
        {
            int* code=(int*)argb;
            if((*code)==0){
                NSILog(@"connected->%d->OK", evn);
                NSError* err=0;
                [self.im login:[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"tokenID"],@"token", nil] err:&err];
                if(err){
                         NSLog(@"个人token登录失败");
                         return;
                          }
               [self.im ur:nil err:&err];
               if(err){
                        NSLog(@"连接失败");
                        return;
                          }

            }else{
                  NSILog(@"connected->%d->error", evn);
            }
     }
            break;
        case V_CWF_NETW_SCK_EVN_LR_S:
            NSILog(@"start loop read->%d", evn);
            break;
        case V_CWF_NETW_SCK_EVN_LR_D:
            NSILog(@"loop read done->%d", evn);
            break;
        default:
            break;
    }
}
// 开启数据库
-(void)openMsgDB{
    //    if () {
    //        <#statements#>
    //    }
    // 1. 实例化数据模型(将所有定义的模型都加载进来)
    // merge——合并
    NSManagedObjectContext *context=[[NSManagedObjectContext alloc] init];//是否在主线程中执行？
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 2. 实例化持久化存储调度，要建立起桥梁，需要模型
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 3. 添加一个持久化的数据库到存储调度
    // 3.1 建立数据库保存在沙盒的URL
    NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docs[0] stringByAppendingPathComponent:@"rcpi.sqlite"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    // 3.2 打开或者新建数据库文件
    // 如果文件不存在，则新建之后打开
    // 否者直接打开数据库
    NSError *error = nil;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    
    if (error) {
        NSLog(@"打开数据库出错 - %@", error.localizedDescription);
        NSELog(@"打开数据库出错 - %@",  error.localizedDescription);
    } else {
        NSLog(@"打开数据库成功！");
        context.persistentStoreCoordinator = store;
    }
    
    self.MSG_CONTEXT=context;
}
-(NSManagedObjectContext *)getConText{
    
    if (self.MSG_CONTEXT) {
        return self.MSG_CONTEXT;
    }else{
          [self openMsgDB];
          return self.MSG_CONTEXT;
    }

}
+ (AppDelegate*)shared{
    return adelegate;
}





















//core data
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {//存储路径
    // The directory the application uses to store the Core Data store file. This code uses a directory named "io.gdy.rcpi" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {//初始化必须依赖.momd文件路径，而.momd文件由.xcdatamodeld文件编译而来
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"rcpi" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"rcpi.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {//持久化存储
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {//在程序结束前、保存数据到持久层
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
