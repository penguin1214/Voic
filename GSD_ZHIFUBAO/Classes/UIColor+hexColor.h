//
//  UIColor+hexColor.h
//  SCUxCHG
//
//  Created by 杨京蕾 on 5/14/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r,g,b) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1.]

@interface UIColor (hexColor)

/**
 *  @brief Return a UIColor instance.
 */
+ (UIColor*)hexColor:(NSString*)hexStr;

@end
