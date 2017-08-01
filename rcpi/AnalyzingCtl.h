//
//  AnalyzingCtl.h
//  rcpi
//
//  Created by wu on 15/11/22.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalyzingCtl : UIViewController
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSString *aid;
- (void)comeback;
- (void)oneClick;

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *qGroupID;
@property (nonatomic,strong)NSString *examName;
@end
