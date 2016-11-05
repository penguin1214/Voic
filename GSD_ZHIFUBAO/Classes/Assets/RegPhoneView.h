//
//  RegPhoneView.h
//  Voic
//
//  Created by 杨京蕾 on 10/16/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "BaseView.h"

@protocol RegPhoneViewDelegate <NSObject>

- (void)didClickRegisterButtonWithPhone:(NSString*)phone Password:(NSString*)password;
- (void)toastMessage:(NSString*)message;

@end

@interface RegPhoneView : BaseView

@property (weak) id <RegPhoneViewDelegate> delegate;

@property (nonatomic, strong) UIImageView* phoneIcon;
@property (nonatomic, strong) UITextField* phoneText;

@property (nonatomic, strong) UIImageView* codeIcon;
@property (nonatomic, strong) UITextField* codeText;

@property (nonatomic, strong) UIImageView* pwdIcon;
@property (nonatomic, strong) UITextField* pwdText;

@end
