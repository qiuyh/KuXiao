//
//  AllCourseCtl.h
//  rcpi
//
//  Created by wu on 15/11/8.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllCourseCtl : UIViewController


//test
@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)NSArray *data_ProfessionEdu;
@property (nonatomic,strong)NSArray *data_BaseEdu;
@property (nonatomic,strong)NSArray *data_AdvancedEdu;
@property (nonatomic,strong)NSString *strClass;
-(void)leftbtnClick;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)setUpNetwork;
@end
