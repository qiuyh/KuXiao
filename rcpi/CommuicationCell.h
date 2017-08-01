//
//  CommuicationCell.h
//  rcpi
//
//  Created by admin on 15/12/20.
//  Copyright © 2015年 Dyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommuicationCell : UITableViewCell

@property (nonatomic,strong)CommentModel *commentModel;

@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel     *unameL;
@property (nonatomic,strong)UILabel     *timeAndFloorL;//楼层和时间
@property (nonatomic,strong)UIButton    *praiseB;
@property (nonatomic,strong)UILabel     *msgL;

@end
