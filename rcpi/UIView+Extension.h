


#import <UIKit/UIKit.h>
#import <iwf/iwf.h>
@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
/**
 弹框提示,建议设置1秒
 */
- (void)viewWithpopUp:(NSString*)title time:(CGFloat)times;
/**
隐藏tableView多余的分割线
 */
+ (void)setExtraCellLineHidden:(UITableExtView *)tableView;
/**
 加载图，传参数：X,Y,W,H
 */

@end
