//
//  ChatContentList+CoreDataProperties.h
//  rcpi
//
//  Created by Dyang on 15/12/15.
//  Copyright © 2015年 Dyang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChatContentList.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatContentList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *chat_content;
@property (nullable, nonatomic, retain) NSNumber *chat_time;
@property (nullable, nonatomic, retain) NSString *m_a;
@property (nullable, nonatomic, retain) NSString *m_id;
@property (nullable, nonatomic, retain) NSNumber *m_type;
@property (nullable, nonatomic, retain) NSString *r_id;
@property (nullable, nonatomic, retain) NSString *s_id;
@property (nullable, nonatomic, retain) NSNumber *u_id;

@end

NS_ASSUME_NONNULL_END
