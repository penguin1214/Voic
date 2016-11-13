//
//  DeviceInfo.h
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/12/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject <NSCoding>

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* imageResString;
@property (nonatomic, retain) NSNumber* currentStat;
@property (nonatomic, retain) NSDictionary* colorStatPair;

@end
