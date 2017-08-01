//
//  ObjectiveCell.h
//  rcpi
//
//  Created by wu on 15/12/5.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveItemCtl.h"
#import "Config.h"
typedef void (^WuCallText) (NSString *text);
@interface ObjectiveCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (strong, nonatomic) IBOutlet UIButton *dragBtn;

//文件存储路径
@property (nonatomic,strong)NSString *qGroupID;
@property (nonatomic,strong)NSString *aid;

@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSMutableArray *answerArray;
@property (nonatomic,strong)NSMutableDictionary *contentData;

@property (nonatomic,strong)ObjectiveItemCtl *obj;
-(void)setUpContentAndHtml:(NSString*)strHtml sumPage:(NSInteger)sum chooseCounts:(NSInteger)count labelContent:(NSArray*)content;

- (void)closeKeyboard:(NSNotification *)notification;

@property (nonatomic,strong)DYTextView *textView;
//block属性
@property (nonatomic, copy) WuCallText wu;
//自定义block方法
- (void)textDidChange:(WuCallText)text;
@end
