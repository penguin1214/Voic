//
//  LogginController.m
//  Voic
//
//  Created by 杨京蕾 on 10/22/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "LogginController.h"
#import "RegisterController.h"
#import "ProfileManager.h"
#import "LogginView.h"
#import "CommunicationManager.h"

@interface LogginController (){
//    RegisterController* _cRegController;
    LogginView* _vLogginView;
}

@end

@implementation LogginController
- (instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.view = [[UIView alloc] initWithFrame:kScreenBound];
    _vLogginView = [[LogginView alloc] init];
    _vLogginView.delegate = self;
    
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.title = @"登录";
//    _cRegController = [[RegisterController alloc] init];
    [self.view addSubview:_vLogginView];
    [_vLogginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - LogginViewDelegate

- (void)didClickRegisterBtn{
    RegisterController* _cRegController = [[RegisterController alloc] init];
//    [self presentViewController:_cRegController animated:YES completion:nil];
    [self.navigationController pushViewController:_cRegController animated:NO];
}

- (void)toastMessage:(NSString *)message{
    [self toast:message];
}

-(void)didClickLoginBtnWithPhone:(NSString *)phone Password:(NSString *)password success:(void (^)(BOOL))success failure:(void (^)(NSError *))failure{
    [CommunicationManager loginWithPhone:phone password:password success:^(BOOL result, NSString *message, NSDictionary *data) {
        if (!result) {
            NSLog(@"%@",message);
            //data:
            NSString* _user_id = [data objectForKey:kResponseUserIDKey];
            NSString* _auth_token = [data objectForKey:kResponseUserAuthToken];
            [[ProfileManager sharedInstance] setUserID:_user_id];
            [[ProfileManager sharedInstance] setAuthToken:_auth_token];
            [[ProfileManager sharedInstance] setUserPhone:phone];
            success(YES);
        }else{
            [self toast:message];
            success(NO);
        }
    } failure:^(NSError* error){
        NSLog(@"%@", error);
    }];
}

- (void)loginSuccess{
    [self toast:@"登录成功"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
