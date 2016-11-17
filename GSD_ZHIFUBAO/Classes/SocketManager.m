//
//  SocketManager.m
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/17/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "SocketManager.h"

@implementation SocketManager

+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    static id instance = nil;
    
    dispatch_once(&once, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    
    return instance;
}

@end
