//
//  DYTextView.m
//  rcpi
//
//  Created by wu on 15/11/18.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import "DYTextView.h"
#import "Config.h"
@interface DYTextView() <UITextViewDelegate>
@property (nonatomic, weak) UILabel *placehoderLabel;
@end

@implementation DYTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        // 添加一个显示提醒文字的label（显示占位文字的label）
        UILabel *placehoderLabel = [[UILabel alloc] init];
        placehoderLabel.numberOfLines = 0;
        placehoderLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:placehoderLabel];
        self.placehoderLabel = placehoderLabel;

        // 设置默认的占位文字颜色
        self.placehoderColor = [UIColor lightGrayColor];

        // 设置默认的字体
        self.font = [UIFont systemFontOfSize:14];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEdit) name:UITextViewTextDidEndEditingNotification object:self];

    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听文字改变
- (void)textDidChange
{
    self.placehoderLabel.hidden = (self.text.length != 0);
}
//当编辑结束时
- (void)textDidEdit{
    if ([self.delegateDY respondsToSelector:@selector(dyText:text:)]) {
        //代理
        [self.delegateDY dyText:self text:self.text];
    }

}
#pragma mark - 公共方法
- (void)setText:(NSString *)text
{
    [super setText:text];

    [self textDidChange];
}

- (void)setPlacehoder:(NSString *)placehoder
{
    _placehoder = [placehoder copy];

    // 设置文字
    self.placehoderLabel.text = placehoder;

    // 重新计算子控件的fame
    [self setNeedsLayout];
}

- (void)setPlacehoderColor:(UIColor *)placehoderColor
{
    _placehoderColor = placehoderColor;

    // 设置颜色
    self.placehoderLabel.textColor = placehoderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];

    self.placehoderLabel.font = font;

    // 重新计算子控件的fame
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.placehoderLabel.y = 0;
    self.placehoderLabel.x = 5;
    self.placehoderLabel.width = self.width - 2 * self.placehoderLabel.x;
    // 根据文字计算label的高度
    CGFloat placehoderH = [PublicTool heightForString:self.placehoder font:self.placehoderLabel.font andWidth:self.placehoderLabel.width];
    self.placehoderLabel.height = placehoderH;
}

@end

