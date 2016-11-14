//
//  DiagleView.m
//  MSCDemo_UI
//
//  Created by wangdan on 14-12-22.
//
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlyISVRecognizer.h"
#import "iflyMSC/IFlyISVDelegate.h"
#import "UIPopoverListView.h"
#import "PopupView.h"
#import "DiagleView.h"


@interface iFlyNvpViewController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate, IFlyISVDelegate>

@property(nonatomic)    DiagleView      *diagView;  //录音界面

@property(nonatomic)    NSArray         *numCodeArray;  //数字密码类型的文本密码数组

@property(nonatomic)     int            pwdt;      //密码类型

@property(nonatomic)    NSString        *titleString;  //录音界面title

@property(nonatomic)    NSString        *sst;      //服务种类，训练还是验证

@property(nonatomic)    UIAlertView     *trainVerifyAlert;

@end
