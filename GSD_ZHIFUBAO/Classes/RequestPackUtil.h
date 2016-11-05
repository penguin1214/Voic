//
//  RequestPackUtil.h
//  SCUxCHG
//
//  Created by 杨京蕾 on 5/15/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestPackUtil : NSObject

/**
 *  @brief  Pack requests with objects.
 *  All request is packed like
 *
 *  {@"logStat":,@"userId":,@"authToken":,@"data"}
 */
+ (NSDictionary*)packWithData:(NSObject*)data;
@end
