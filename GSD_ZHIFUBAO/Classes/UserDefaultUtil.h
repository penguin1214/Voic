//
//  UserDefaultUtil.h
//  SCUxCHG
//
//  Created by 杨京蕾 on 5/13/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultUtil : NSObject

/**
 *  @brief  Save object to UserDefault with key.
 */
+ (void)saveObject:(NSObject*)obj forKey:(NSString*)key;

/**
 *  @brief  Get object from UserDefault by key.
 */
+ (NSString*)getObjectBykey:(NSString*)key;

@end
