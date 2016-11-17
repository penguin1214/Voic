//
//  RegisterController.m
//  Voic
//
//  Created by 杨京蕾 on 10/16/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "RegisterController.h"
#import "RegPhoneView.h"
#import "CommunicationManager.h"
#import "FormatUtil.h"
#import "ProfileManager.h"
#import "iFlyNvpViewController.h"

@interface RegisterController (){
    RegPhoneView* _vRegView;
}

@end
@implementation RegisterController

//@synthesize RegView = _vRegView;

- (instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.view = [[UIView alloc] initWithFrame:kScreenBound];
    _vRegView = [[RegPhoneView alloc] init];
    _vRegView.delegate = self;
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(recvNotif:) name:@"Register" object:nil];
    
    
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationItem.leftBarButtonItem = nil;
    self.title = @"注册";
    
    [self.view addSubview:_vRegView];
    [_vRegView mas_makeConstraints:^(MASConstraintMaker* make){
        make.top.equalTo(self.view).with.offset(64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - RegPhoneViewDelegate
-(void)didClickRegisterButtonWithPhone:(NSString *)phone{
    
    iFlyNvpViewController* ivp = [[iFlyNvpViewController alloc] init];
    ivp.sst = @"train";
    [self.navigationController pushViewController:ivp animated:YES];
    
}

- (void)recvNotif:(NSNotification*)notify {
    // 取得广播内容
    NSDictionary *dict = [notify userInfo];
    NSString *name = [dict objectForKey:@"NotifyName"];
    
    if ([name  isEqual: @"register success"]) {
        [CommunicationManager registerWithPhone:[[ProfileManager sharedInstance] getUserPhone] success:^(BOOL result, NSString *message, NSDictionary* data) {
            if (!result) {
                NSLog(@"%@", message);
                
                [self toast:@"注册成功"];
                [self performSelector:@selector(popUpController) withObject:nil afterDelay:2.0];
            }
        } failure:^(NSError *error) {
            NSLog(@"error");
        }];
 
    }
}

- (void)popUpController{
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
