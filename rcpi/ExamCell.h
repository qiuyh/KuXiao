//
//  ExamCell.h
//  rcpi
//
//  Created by wu on 15/11/29.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYTextView.h"
@interface ExamCell : UICollectionViewCell <DYTextDelegate>
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *desc;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)NSString *aid;
@property (nonatomic,strong)NSString *qGroupID;
@property (nonatomic,strong)NSMutableDictionary *textContent;

@property (nonatomic,strong)UIView *titleView;
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)UIButton *showBtn;
@property (nonatomic,strong)DYTextView *textView;
//@property (nonatomic,strong)NSString *pathToDoc;

@end
