//
//  FirstController.h
//
//
//  Created by wu on 15/10/12.
//
//

#import <UIKit/UIKit.h>

@interface FirstController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)NSArray *arr;
@property (nonatomic,strong)UIPageControl *pageCtrl;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)UIActivityIndicatorView *indicator;
@property (nonatomic,assign)BOOL isRefresh;

//test
@property (nonatomic,strong)NSString *apiStr;

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)setBackgroundView;
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
-(void)leftBtnClick;
-(void)rightbtnClick;
-(void)clickBut;
-(void)network;
-(void)nextPage;
@end
