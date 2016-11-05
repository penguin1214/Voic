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
                password:(NSString*)password
                 success:(void(^)(BOOL result,
                                  NSString* message,
                                  NSDictionary* data))success
                 failure:(void(^)(NSError* error))failure;

+ (void)loginWithPhone:(NSString*)phone
              password:(NSString*)password
               success:(void(^)(BOOL result, NSString* message, NSDictionary* data))success
               failure:(void(^)(NSError* error))failure;

@end
