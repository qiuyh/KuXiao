//
//  AnalyzCell.h
//  rcpi
//
//  Created by wu on 15/11/30.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalyzCell : UICollectionViewCell

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *desc;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)NSMutableDictionary *textContent;

@property (nonatomic,strong)UIView *titleView;
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)UIButton *showBtn;
@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)NSArray *answerContent;
@property (nonatomic,strong)NSArray *analyzContent;

@end
