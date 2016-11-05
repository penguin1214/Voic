//
//  RequestPackUtil.m
//  SCUxCHG
//
//  Created by 杨京蕾 on 5/15/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "RequestPackUtil.h"
#import "ProfileManager.h"

@implementation RequestPackUtil

+ (NSDictionary *)packWithData:(NSObject *)data{
    NSMutableDictionary* ret = [[NSMutableDictionary alloc] init];
    NSString* userId = [[ProfileManager sharedInstance] getUserID];
    NSString* authToken = [[ProfileManager sharedInstance] getAuthToken];
    
    if (userId.length > 0 && authToken.length > 0) {
        [ret setObject:kLoggedMark forKey:kLogStatKey];
        [ret setObject:userId forKey:kUserIdKey];
        [ret setObject:authToken forKey:kAuthTokenKey];
        [ret setObject:data forKey:kDataKey];
        return ret;
    }else{
        [ret setObject:kUnLoggedMark forKey:kLogStatKey];
        [ret setObject:kUnloggedUserId forKey:kUserIdKey];   //value cannot be nil
        [ret setObject:kUnloggedAuthToken forKey:kAuthTokenKey];
        [ret setObject:data forKey:kDataKey];
        return ret;
    }
}
@end
