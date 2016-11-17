//
//  CommunicationManager.h
//  Voic
//
//  Created by 杨京蕾 on 10/19/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UserEntity.h"

@interface CommunicationManager : NSObject

+ (void)registerWithPhone:(NSString*)phone
                 success:(void(^)(BOOL result,
                                  NSString* message,
                                  NSDictionary* data))success
                 failure:(void(^)(NSError* error))failure;

+ (void)loginWithPhone:(NSString*)phone
               success:(void(^)(BOOL result, NSString* message, NSDictionary* data))success
               failure:(void(^)(NSError* error))failure;

+ (void)addDeviceWithTitle:(NSString*)title
                    image:(NSString*)img_res_string
              currentStat:(NSNumber*)current_stat
            colorStatPair:(NSDictionary*)color_stat_pair
                  success:(void(^)(BOOL result, NSString* message, NSDictionary* data))success
                  failure:(void(^)(NSError* error))failure;

@end
