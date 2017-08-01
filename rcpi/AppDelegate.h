//
//  AppDelegate.h
//  rcpi
//
//  Created by Dyang on 15/11/30.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Config.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;//保存数据到持久层（数据库）
- (NSURL *)applicationDocumentsDirectory;//应用程序沙箱下的Documents目录路径
- (void)sendMessageWithMsg:(NSString *)msg AndUid:(NSString *)uid;
//+ (AppDelegate*)shared;
-(NSManagedObjectContext *)getConText;
+ (AppDelegate*)shared;
@property (strong, nonatomic) NSManagedObjectContext *MSG_CONTEXT;
@end

