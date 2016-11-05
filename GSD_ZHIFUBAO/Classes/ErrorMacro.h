//
//  ErrorMacro.h
//  SCUxCHG
//
//  Created by 杨京蕾 on 5/13/16.
//  Copyright © 2016 yang. All rights reserved.
//

#ifndef ErrorMacro_h
#define ErrorMacro_h

//自定义错误提供给NSError使用
#define kCustomErrorDomain @"com.SCUxCHG.ios"
typedef enum {
    eCustomErrorCodeFailure = 0
} eCustomErrorCode;
#endif /* ErrorMacro_h */
