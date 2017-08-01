//
//  AnswerCardCell.h
//  rcpi
//
//  Created by wu on 15/12/14.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^WuCallback) (NSString *bttn);
@interface AnswerCardCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *titleView;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
//@property (nonatomic,strong)NSString *btnTag;
//block属性
@property (nonatomic, copy) WuCallback wu;
//自定义block方法
- (void)answerCardAndButtonAction:(WuCallback)btn;

- (void)answerCardName:(NSString*)name content:(NSMutableDictionary*)contentData count:(NSInteger)counts types:(NSArray*)types;


@end
