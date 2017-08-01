//
//  Singleton.h
//  多线程Demo
//
//  Created by Jack on 15/4/26.
//  Copyright (c) 2015年 Jack. All rights reserved.
//

#define singleton_interface(name) \
+ (instancetype)share##name;

#if __has_feature(objc_arc)
    #define singleton_implementation(name) \
    static id _instance;\
    + (id)allocWithZone:(struct _NSZone *)zone{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
    _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
    }\
    - (id)copyWithZone:(NSZone *)zone{\
    return _instance;\
    }\
    + (instancetype)share##name{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
    _instance = [[super alloc] init];\
    });\
    return _instance;\
    }
#else
    #define singleton_implementation(name) \
    static id _instance;\
    + (id)allocWithZone:(struct _NSZone *)zone{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
    _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
    }\
    - (id)copyWithZone:(NSZone *)zone{\
    return _instance;\
    }\
    + (instancetype)share##name{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
    _instance = [[super alloc] init];\
    });\
    return _instance;\
    }\
    - (oneway void)release{}\
    - (id)retain{return self;};\
    - (NSUInteger)retainCount{return 1;}\
    - (id)autorelease{return self;}
#endif
