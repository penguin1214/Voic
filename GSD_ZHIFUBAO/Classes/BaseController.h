//
//  BaseController.h
//  SCUxCHG
//
//  Created by 杨京蕾 on 5/14/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkBrokenView.h"

@interface BaseController : UIViewController <NetworkBrokenViewDelegate>
#pragma mark - self.navigationController

- (void)setNavLeftBarButtonItem;

- (void)popSelfController;


#pragma mark - _loadingView show and hide

- (void)showLoadingView;

- (void)hideLoadingView;


#pragma mark - _networkBrokenView show and hide

- (void)showNetworkBrokenView:(void(^)(MASConstraintMaker *))make;

- (void)hideNetworkBrokenView;


#pragma mark - toast

-(void)toast:(NSString *)title;

-(void)toast:(NSString *)title seconds:(int)seconds;

-(void)toastWithError:(NSError *)error;


#pragma mark - 如果用户没有登录则跳到登录页面

- (BOOL)gotoLoginPageIfNotLogin;
@end
