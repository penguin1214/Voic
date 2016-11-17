//
//  RegPhoneView.m
//  Voic
//
//  Created by 杨京蕾 on 10/16/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "RegPhoneView.h"
#import <SMS_SDK/SMSSDK.h>
#import "CommunicationManager.h"
#import "ProfileManager.h"
#import "FormatUtil.h"

@interface RegPhoneView (){
    //phone number grid
    UIImageView *_vPhoneIcon;
    UITextField *_vPhoneText;
    UILabel *_vPhoneGridUnderline;
    
    //sms code grid
    UIImageView *_vCodeIcon;
    UITextField *_vCodeText;
    UILabel *_vCodeGridUnderline;
    UIButton *_vGetCodeBtn;
    
    //button grid
    UIButton *_vNextBtn;
}
@end
@implementation RegPhoneView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    //    self.backgroundColor = kColorWhite;
    
    UIView* _vPhoneGrid = [[UIView alloc] init];
    UIView* _vCodeGrid = [[UIView alloc] init];
    UIView* _vPwdGrid = [[UIView alloc] init];
    UIView* _vButtonGrid = [[UIView alloc] init];
    
    [self addSubview:_vPhoneGrid];
    [self addSubview:_vCodeGrid];
    [self addSubview:_vPwdGrid];
    [self addSubview:_vButtonGrid];
    
    [_vPhoneGrid mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(self).with.offset(8);
        make.right.equalTo(self).with.offset(-8);
        make.top.equalTo(self).with.offset(8);
        make.height.mas_equalTo(45);
    }];
    
    [_vCodeGrid mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vPhoneGrid);
        make.right.equalTo(_vPhoneGrid);
        make.top.equalTo(_vPhoneGrid.mas_bottom);
        make.height.equalTo(_vPhoneGrid.mas_height);
    }];
    
    [_vPwdGrid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_vPhoneGrid);
        make.right.equalTo(_vPhoneGrid);
        make.top.equalTo(_vCodeGrid.mas_bottom).with.offset(30);
        make.height.equalTo(_vPhoneGrid.mas_height);
    }];
    
    [_vButtonGrid mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vPhoneGrid);
        make.right.equalTo(_vPhoneGrid);
        make.top.equalTo(_vPwdGrid.mas_bottom);
        make.height.mas_equalTo(300);   //height 300
    }];
    
    _vPhoneIcon = [[UIImageView alloc] init];
    _vPhoneIcon.image = [UIImage imageNamed:@"icon_account"];
    [_vPhoneGrid addSubview:_vPhoneIcon];
    [_vPhoneIcon mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vPhoneGrid);
        make.centerY.equalTo(_vPhoneGrid);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    _vPhoneText = [[UITextField alloc] init];
    _vPhoneText.placeholder = @"手机号";
    _vPhoneText.keyboardType = UIKeyboardTypePhonePad;
    [_vPhoneGrid addSubview:_vPhoneText];
    [_vPhoneText mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vPhoneIcon.mas_right).with.offset(10);
        make.centerY.equalTo(_vPhoneGrid);
        make.right.equalTo(_vPhoneGrid);
    }];
    
    _vPhoneGridUnderline = [[UILabel alloc] init];
    _vPhoneGridUnderline.backgroundColor = kColorGray;
    [_vPhoneGrid addSubview:_vPhoneGridUnderline];
    [_vPhoneGridUnderline mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vPhoneGrid);
        make.right.equalTo(_vPhoneGrid);
        make.top.equalTo(_vPhoneGrid.mas_baseline);
        make.height.mas_equalTo(1);
    }];
    
    _vCodeIcon = [[UIImageView alloc] init];
    _vCodeIcon.image = [UIImage imageNamed:@"icon_lock"];
    [_vCodeGrid addSubview:_vCodeIcon];
    [_vCodeIcon mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vCodeGrid);
        make.centerY.equalTo(_vCodeGrid);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    _vCodeText = [[UITextField alloc] init];
    _vCodeText.placeholder = @"验证码";
    //    _vCodeText.secureTextEntry = YES;
    _vCodeText.keyboardType = UIKeyboardTypeAlphabet;
    [_vCodeGrid addSubview:_vCodeText];
    [_vCodeText mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vCodeIcon.mas_right).with.offset(10);
        make.centerY.equalTo(_vCodeGrid);
        make.width.mas_equalTo(200);
    }];
    
    _vGetCodeBtn = [[UIButton alloc] init];
    [_vGetCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _vGetCodeBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [_vGetCodeBtn setBackgroundColor:kColorWhite];
    [_vGetCodeBtn setTitleColor:kColorMainGreen forState:UIControlStateNormal];
    [_vCodeGrid addSubview:_vGetCodeBtn];
    [_vGetCodeBtn mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vCodeText.mas_right).with.offset(10);
        make.right.equalTo(_vCodeGrid);
        make.centerY.equalTo(_vCodeGrid);
    }];
    
    
    _vCodeGridUnderline = [[UILabel alloc] init];
    _vCodeGridUnderline.backgroundColor = kColorGray;
    [_vCodeGrid addSubview:_vCodeGridUnderline];
    [_vCodeGridUnderline mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vCodeGrid);
        make.right.equalTo(_vCodeGrid);
        make.top.equalTo(_vCodeGrid.mas_baseline);
        make.height.mas_equalTo(1);
    }];
    
    _vNextBtn = [[UIButton alloc] init];
    [_vNextBtn setTitle:@"注册" forState:UIControlStateNormal];
    //    _vNextBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [_vNextBtn setBackgroundColor:kColorMainGreen];
    [_vNextBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [_vButtonGrid addSubview:_vNextBtn];
    [_vNextBtn mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vButtonGrid);
        make.right.equalTo(_vButtonGrid);
        make.top.equalTo(_vButtonGrid).with.offset(20);
    }];
    
    //  bind event to buttons
    [_vGetCodeBtn addTarget:self action:@selector(clickGetCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    [_vNextBtn addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

#pragma mark - Action

- (void)clickGetCodeBtn{
    NSLog(@"getting verification code...");
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_vPhoneText.text
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error){
                                     if (!error){
                                         NSLog(@"get code success");
                                     }
                                     else{
                                         NSLog(@"get code error");
                                     }
                                 }];
}

- (void)clickNextBtn{
    NSError* err = nil;
    if (![FormatUtil isValidPhone:_vPhoneText.text error:&err]) {
        [self.delegate toastMessage:@"错误的手机号码"];
    }else{
        [SMSSDK commitVerificationCode:_vCodeText.text phoneNumber:_vPhoneText.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error){
            if (!error) {
                NSLog(@"verification success");
            }else{
                NSLog(@"verification failed");
            }
        }];
        NSLog(@"verification success");
        [self.delegate didClickRegisterButtonWithPhone:_vPhoneText.text];
    }
    
}
@end
