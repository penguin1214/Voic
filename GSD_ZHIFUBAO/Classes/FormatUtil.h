//
//  FormatUtil.h
//  SCUxCHG
//
//  Created by 杨京蕾 on 5/13/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatUtil : NSObject

/**
 *  @brief  Check if phone number format is validate.
 */
+ (BOOL)isValidPhone:(NSString*)phone error:(NSError **)err;

/**
 *  @brief  Check if password format is validate.
 */
+ (BOOL)isValidPassword:(NSString*)pwd error:(NSError **)err;
@end
