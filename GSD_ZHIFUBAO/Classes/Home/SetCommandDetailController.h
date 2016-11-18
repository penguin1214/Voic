//
//  SetCommandDetailController.h
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/18/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "BaseController.h"

@interface SetCommandDetailController : BaseController

@property (nonatomic, strong) NSNumber* tag;
@property (nonatomic, strong) NSString* command;
@property (nonatomic, strong) NSString* commandCode;

- (NSDictionary*)collectCommand;

@end
