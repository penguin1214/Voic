//
//  Command.h
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/18/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Command : NSObject <NSCoding>

@property (nonatomic, strong) NSString* command;
@property (nonatomic, strong) NSString* commandCode;

@end
