//
//  UserEntity.h
//  SCUxCHG
//
//  Created by 杨京蕾 on 5/13/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseEntity.h"

@interface UserEntity : BaseEntity

//@property (nonatomic, copy) NSString* username; //用户名   less than 30 chars
@property (nonatomic, copy) NSString* password;  //密码    less
@property (nonatomic, copy) NSString* phone; //手机号
@property (nonatomic, copy) NSString* auth_token;    //登录验证token
@end
