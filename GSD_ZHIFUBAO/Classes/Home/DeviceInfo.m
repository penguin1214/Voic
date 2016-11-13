//
//  DeviceInfo.m
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/12/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "DeviceInfo.h"

#define kUserDefaultDeviceTitleKey @"title"
#define kUserDefaultDeviceImageResStringKey @"imageResString"
#define KUserDefaultDeviceCurrentStatKey @"currentStat"
#define kUserDefaultDeviceColorStatPair @"colorStatPair"

@implementation DeviceInfo

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _title = [aDecoder decodeObjectForKey:kUserDefaultDeviceTitleKey];
        _imageResString = [aDecoder decodeObjectForKey:kUserDefaultDeviceImageResStringKey];
        _currentStat = [aDecoder decodeObjectForKey:KUserDefaultDeviceCurrentStatKey];
        _colorStatPair = [aDecoder decodeObjectForKey:kUserDefaultDeviceColorStatPair];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_title forKey:kUserDefaultDeviceTitleKey];
    [aCoder encodeObject:_imageResString forKey:kUserDefaultDeviceImageResStringKey];
    [aCoder encodeObject:_currentStat forKey:KUserDefaultDeviceCurrentStatKey];
    [aCoder encodeObject:_colorStatPair forKey:kUserDefaultDeviceColorStatPair];
}

@end
