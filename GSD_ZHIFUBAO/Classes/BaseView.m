//
//  BaseView.m
//  Voic
//
//  Created by 杨京蕾 on 10/12/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = kColorWhite;
    return self;
}
@end
