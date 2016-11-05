//
//  UserDefaultUtil.m
//  SCUxCHG
//
//  Created by 杨京蕾 on 5/13/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "UserDefaultUtil.h"

@implementation UserDefaultUtil

+(void)saveObject:(NSObject *)obj forKey:(NSString *)key{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
}

+(NSString *)getObjectBykey:(NSString *)key{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* ret = [defaults objectForKey:key];
    
    if (!ret) {
        return nil;
    }
    
    return ret;
}
@end
