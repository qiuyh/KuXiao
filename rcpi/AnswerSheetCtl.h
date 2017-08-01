//
//  AnswerSheetCtl.h
//  rcpi
//
//  Created by wu on 15/12/16.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveItemCtl.h"
#import "AnalyzingCtl.h"
@interface AnswerSheetCtl : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,assign)NSInteger counts;
@property (nonatomic,strong)NSArray *types;
@property (nonatomic,strong)NSMutableDictionary *contentData;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)ObjectiveItemCtl *obj;
@property (nonatomic,strong)AnalyzingCtl *analy;


@property (nonatomic,assign)BOOL alreadyAnswer;
@property (nonatomic,assign)NSInteger currentPage;
@end


