//
//  SocketManager.h
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/17/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface SocketManager : NSObject <GCDAsyncSocketDelegate>

+ (SocketManager*)sharedInstance;

@end
