//
//  LogginView.h
//  Voic
//
//  Created by 杨京蕾 on 10/22/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "BaseView.h"

@protocol LogginViewDelegate <NSObject>

- (void)didClickRegisterBtn;

- (void)didClickLoginBtnWithPhone:(NSString*)phone;

- (void)loginSuccess;

- (void)toastMessage:(NSString*)message;

@end

@interface LogginView : BaseView

@property (weak) id <LogginViewDelegate> delegate;
    
@end
