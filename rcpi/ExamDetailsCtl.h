//
//  ExamDetailsCtl.h
//  rcpi
//
//  Created by wu on 15/11/15.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamDetailsCtl : UIViewController
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSString *aid;
@property (nonatomic,strong)NSString *qGroupID;
@property (nonatomic,strong)UICollectionView *collectionView;

//信息存储
@property (nonatomic,strong)NSMutableDictionary *textContent;
//test
- (void)upLoadData;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
@end
