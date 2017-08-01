//
//  SearchCourseViewCell.m
//  rcpi
//
//  Created by Dyang on 15/10/13.
//  Copyright (c) 2015年 Dyang. All rights reserved.
//

#import "SearchCourseViewCell.h"

@implementation SearchCourseViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       // [self createUi];
        
    }
    
    return self;
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext(); CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:200.0 / 255.0 green:199.0 / 255.0 blue:204.0 / 255.0 alpha:1.0].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width , 1));
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
