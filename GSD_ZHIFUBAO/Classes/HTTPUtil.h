//
//  HTTPUtil.h
//  SCUxCHG
//
//  Created by 杨京蕾 on 5/15/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "AFNetworking/AFNetworking.h"

@interface HTTPUtil : AFHTTPSessionManager

/**
 *  @brief  封装HTTP请求
 */

+ (instancetype)sharedInstance;

@end
