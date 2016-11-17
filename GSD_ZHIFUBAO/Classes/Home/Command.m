
//
//  Command.m
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/18/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "Command.h"

@implementation Command
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _command = [aDecoder decodeObjectForKey:@"command"];
        _commandCode = [aDecoder decodeObjectForKey:@"commandCode"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_command forKey:@"command"];
    [aCoder encodeObject:_commandCode forKey:@"commandCode"];
}

@end
