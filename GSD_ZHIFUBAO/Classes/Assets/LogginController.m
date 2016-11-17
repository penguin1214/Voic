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
#import "iFlyNvpViewController.h"

@interface LogginController (){
//    RegisterController* _cRegController;
    LogginView* _vLogginView;
    NSString* _phone;
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
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(recvNotif:) name:@"Login" object:nil];
    
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
    
    //删除模型
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    
    NSString* notifyName = @"deleteModel";
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:notifyName, @"NotifyName", nil];
    
    [nc postNotificationName:@"VoiceModelController" object:self userInfo:dict];
    
    [self.navigationController pushViewController:_cRegController animated:NO];
}

- (void)didClickLoginBtnWithPhone:(NSString *)phone {
    _phone = phone;
    [[ProfileManager sharedInstance] setUserPhone:phone];
    iFlyNvpViewController* ivp = [[iFlyNvpViewController alloc] init];
    ivp.sst = @"verify";
    [self.navigationController pushViewController:ivp animated:YES];
}

- (void)toastMessage:(NSString *)message{
    [self toast:message];
}


- (void)recvNotif:(NSNotification*)notify {
    // 取得广播内容
    NSDictionary *dict = [notify userInfo];
    NSString *name = [dict objectForKey:@"NotifyName"];
    
    if ([name  isEqual: @"login success"]) {
        
        [CommunicationManager loginWithPhone:_phone success:^(BOOL result, NSString *message, NSDictionary *data) {
            
            if (!result) {
                NSLog(@"%@", message);
                //data
                NSString* _user_id = [data objectForKey:kResponseUserIDKey];
                NSString* _auth_token = [data objectForKey:kResponseUserAuthToken];
                NSArray* _grid_items = [data objectForKey:kResponseUserGridItems];
                
                [[ProfileManager sharedInstance] setUserID:_user_id];
                [[ProfileManager sharedInstance] setAuthToken:_auth_token];
                [[ProfileManager sharedInstance] setUserPhone:_phone];
                [[ProfileManager sharedInstance] setGridItems:_grid_items];
                [[ProfileManager sharedInstance] setVoiceIDWithSugar];
                
                [self toast:@"登录成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else {
                NSLog(@"%@", message);
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

- (void)loginSuccess{
    [self toast:@"登录成功"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
