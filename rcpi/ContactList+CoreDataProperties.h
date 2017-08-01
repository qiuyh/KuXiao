//
//  ContactList+CoreDataProperties.h
//  rcpi
//
//  Created by Dyang on 15/12/15.
//  Copyright © 2015年 Dyang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ContactList.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *new_msg;
@property (nullable, nonatomic, retain) NSString *r_id;
@property (nullable, nonatomic, retain) NSString *s_id;
@property (nullable, nonatomic, retain) NSString *u_alias;
@property (nullable, nonatomic, retain) NSNumber *u_id;
@property (nullable, nonatomic, retain) NSString *u_img;
@property (nullable, nonatomic, retain) NSNumber *u_online;
@property (nullable, nonatomic, retain) NSNumber *u_type;
@property (nullable, nonatomic, retain) NSNumber *up_time;

@end

NS_ASSUME_NONNULL_END
