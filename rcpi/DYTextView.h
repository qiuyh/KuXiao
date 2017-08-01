//
//  DYTextView.h
//  rcpi
//
//  Created by wu on 15/11/18.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DYTextView;
@protocol DYTextDelegate <NSObject>

- (void)dyText:(DYTextView*)textView  text:(NSString*)text;

@end

@interface DYTextView : UITextView
@property (nonatomic, copy) NSString *placehoder;
@property (nonatomic, strong) UIColor *placehoderColor;
@property (nonatomic,strong)NSString *textStr;
@property (nonatomic,strong)id<DYTextDelegate> delegateDY;
@end
