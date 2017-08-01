//
//  ObjectiveItemCtl.h
//  rcpi
//
//  Created by wu on 15/12/5.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObjectiveItemCtl : UIViewController

@property(nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSMutableDictionary *contentData;
@property (nonatomic,strong)NSString *aid;
@property (nonatomic,strong)NSString *qGroupID;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *examName;
//Test
- (void)upLoadData;
- (void)oneClick;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)networkAndUrl:(NSString*)url dargs:(NSDictionary*)args;
- (void)nextItems:(NSInteger)item;
@end
