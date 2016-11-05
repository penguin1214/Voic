//
//  FormatUtil.m
//  SCUxCHG
//
//  Created by 杨京蕾 on 5/13/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "FormatUtil.h"

@implementation FormatUtil

+ (BOOL)isValidPhone:(NSString *)phone error:(NSError *__autoreleasing *)err{
    NSDictionary *errorUserInfo;
    
    if (phone.length <= 0) {
        errorUserInfo = [NSDictionary dictionaryWithObject:@"请输入手机号"                                                                      forKey:NSLocalizedDescriptionKey];
        *err = [NSError errorWithDomain:kCustomErrorDomain code:eCustomErrorCodeFailure userInfo:errorUserInfo];
        return NO;
    }
    
    if (phone.length != 11) {
        errorUserInfo = [NSDictionary dictionaryWithObject:@"手机号长度只能是11位"                                                                      forKey:NSLocalizedDescriptionKey];
        *err = [NSError errorWithDomain:kCustomErrorDomain code:eCustomErrorCodeFailure userInfo:errorUserInfo];
        return NO;
    } else {
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:phone];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:phone];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:phone];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        } else {
            errorUserInfo = [NSDictionary dictionaryWithObject:@"请输入正确的电话号码"                                                                      forKey:NSLocalizedDescriptionKey];
            *err = [NSError errorWithDomain:kCustomErrorDomain code:eCustomErrorCodeFailure userInfo:errorUserInfo];
            return NO;
        }
    }
}

+(BOOL)isValidPassword:(NSString *)pwd error:(NSError *__autoreleasing *)err{
    NSDictionary *errorUserInfo;
    
    if (pwd.length < 6) {
        errorUserInfo = [NSDictionary dictionaryWithObject:@"密码长度必须六位以上" forKey:NSLocalizedDescriptionKey];
        *err = [NSError errorWithDomain:kCustomErrorDomain code:eCustomErrorCodeFailure userInfo:errorUserInfo];
        return NO;
    }
    
    return YES;
}
@end
