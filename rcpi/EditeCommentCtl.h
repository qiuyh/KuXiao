//
//  EditeCommentCtl.h
//  rcpi
//
//  Created by admin on 15/12/21.
//  Copyright © 2015年 Dyang. All rights reserved.

//帖子评论编辑发表页面

#import <UIKit/UIKit.h>

@interface EditeCommentCtl : UIViewController

typedef void(^EditeBlock)();

@property (nonatomic,copy)NSString *topicId;//帖子id
@property (nonatomic,copy)EditeBlock block;
@property (nonatomic,strong)UITextView *textView;



-(void)setNav;
- (void)addTextView;
- (void)rightbtnClick;
- (void)textViewDidChange:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView;

@end
