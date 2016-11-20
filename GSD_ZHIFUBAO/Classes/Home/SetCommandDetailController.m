//
//  SetCommandDetailController.m
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/18/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "SetCommandDetailController.h"

@interface SetCommandDetailController () {
    //phone number grid
    UIImageView *_vPhoneIcon;
    UITextField *_vPhoneText;
    UILabel *_vPhoneGridUnderline;
    
    //password grid
    UIImageView *_vPwdIcon;
    UITextField *_vPwdText;
    UILabel *_vPwdGridUnderline;
    
    //button grid
    UIButton *_vLoginBtn;
    UIButton *_vForgottenBtn;
    UIButton *_vRegisterBtn;
}

@end

@implementation SetCommandDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kColorWhite;
    
    UIView* _vPhoneGrid = [[UIView alloc] init];
    UIView* _vPwdGrid = [[UIView alloc] init];
    
    [self.view addSubview:_vPhoneGrid];
    [self.view addSubview:_vPwdGrid];
    
    [_vPhoneGrid mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(self.view).with.offset(8);
        make.right.equalTo(self.view).with.offset(-8);
        make.top.equalTo(self.view).with.offset(8);
        make.height.mas_equalTo(45);
    }];
    
    [_vPwdGrid mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vPhoneGrid);
        make.right.equalTo(_vPhoneGrid);
        make.top.equalTo(_vPhoneGrid.mas_bottom);
        make.height.equalTo(_vPhoneGrid.mas_height);
    }];
    
    
    _vPhoneText = [[UITextField alloc] init];
    _vPhoneText.placeholder = @"语音命令";
    _vPhoneText.keyboardType = UIKeyboardTypeDefault;
    [_vPhoneGrid addSubview:_vPhoneText];
    [_vPhoneText mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(self.view).with.offset(20);
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
    
    
    _vPwdText = [[UITextField alloc] init];
    _vPwdText.placeholder = @"命令码";
    _vPwdText.keyboardType = UIKeyboardTypeAlphabet;
    _vPwdText.secureTextEntry = YES;
    [_vPwdGrid addSubview:_vPwdText];
    [_vPwdText mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(self.view).with.offset(20);
        make.centerY.equalTo(_vPwdGrid);
        make.right.equalTo(_vPhoneGrid);
    }];
    
    _vPwdGridUnderline = [[UILabel alloc] init];
    _vPwdGridUnderline.backgroundColor = kColorGray;
    [_vPwdGrid addSubview:_vPwdGridUnderline];
    [_vPwdGridUnderline mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vPwdGrid);
        make.right.equalTo(_vPwdGrid);
        make.top.equalTo(_vPwdGrid.mas_baseline);
        make.height.mas_equalTo(1);
    }];
    
    
}


- (NSDictionary *)collectCommand {
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:_vPhoneText.text, @"command", _vPwdText.text, @"commandCode", nil];
    return dict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
