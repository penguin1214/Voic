//
//  NetworkBrokenView.h
//  SCUxCHG
//
//  Created by 杨京蕾 on 5/15/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NetworkBrokenViewDelegate <NSObject>

- (void)doClickNetworkBrokenView;

@end


@interface NetworkBrokenView : UIView

@property (nonatomic, weak) id<NetworkBrokenViewDelegate> delegate;

@end
