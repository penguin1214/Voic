//
//  BaseLoadingView.m
//  SCUxCHG
//
//  Created by 杨京蕾 on 5/15/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "BaseLoadingView.h"

@interface BaseLoadingView ()
{
    UIActivityIndicatorView *_loadingView;
}

@end

@implementation BaseLoadingView
- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect selfFrame = CGRectMake(frame.origin.x, frame.origin.y, 32, 32);
    if (self = [super initWithFrame:selfFrame]) {
        self.backgroundColor = kColorWhite;
        
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [_loadingView startAnimating];
        [self addSubview:_loadingView];
    }
    return self;
}
@end
