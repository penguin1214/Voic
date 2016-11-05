//
//  DiagleView.m
//  MSCDemo_UI
//
//  Created by wangdan on 14-12-22.
//
//

#import "iFlyNvpViewController.h"
#import "iflyMSC/IFlySpeechError.h"
#import "Reachability.h"
#import "iflyMSC/iFlyISVRecognizer.h"
#import "TrainViewController.h"
#import "DiagleView.h"


@interface  iFlyNvpViewController()
{
    IFlyISVRecognizer      *isvRec;     //atention 声纹类的单例模式 atention  +++++++++++++++++++++++++++++++
    
    UIButton               *trainButt;
    
    UIButton               *verifyButt;
    
    UIButton               *deleteButt;
    
    UIButton               *queryButt;
    
    UIBarButtonItem        *settingButt;   //四个按钮： 训练，验证，删除，查询
    
    PopupView              *resultShow;   //动态显示界面 黑底白字
    
    NSString               *authID;    //atention  声纹用户名++++++++++++++++++++++++++++++++++++
    
    UIView                 *registerView;
    
    UITextField            *nameField;
    
    UILabel                *nameLabel;  //输入用户名界面
    
    int                     screenWidth ; //界面宽度
    
    int                     screenHeight; //界面宽度
    
    int                     ivppwdt;      //atention  声纹密码类型参数+++++++++++++++++++++++++++++++++++++++
    
    NSArray * fixCodeArray;             //固定密码数组  +++++++++++++++++++++++++++++++++++++++++++++++++++++!
    
    NSArray * numCodeArray;             //数字密码数组  +++++++++++++++++++++++++++++++++++++++++++++++++++++!
    
}

@end


#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define Margin  5
#define Slide   2

#define PWDT_FIXED_CODE  1     //固定密码
//#define PWDT_FREE_CODE   2     //自由说
#define PWDT_NUM_CODE    3     //数字密码



#pragma  mark actionsheet tag

#define SETTING_TAG            1
#define FIXED_CODE_VERIFY_TAG  3
#define FIXED_CODE_TRAIN_TAG   2
#define FIXED_CODE_QUERY_TAG   4
#define FIXED_CODE_DEL_TAG     5
//


#pragma  key of isv
#define  KEY_PTXT           @"ptxt"
#define  KEY_RGN            @"rgn"
#define  KEY_TSD            @"tsd"
#define  KEY_SUB            @"sub"
#define  KEY_PWDT           @"pwdt"
#define  KEY_TAIL           @"vad_speech_tail"
#define  KEY_AUTHID         @"auth_id"
#define  KEY_SST            @"sst"
#define  KEY_KEYTIMEOUT     @"key_speech_timeout"
#define  KEY_VADTIMEOUT     @"vad_timeout"

#pragma mark value of key 
#define  TRAIN_SST          @"train"
#define  VERIFY_SST         @"verify"


#pragma mark del or query
#define  DEL                @"del"
#define  QUERY              @"que"

@implementation iFlyNvpViewController

- (void)viewDidLoad
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
#endif
    
    [super viewDidLoad];
    
    isvRec=[IFlyISVRecognizer sharedInstance];    // 创建声纹对象 attention isv +++++++++++++++++++++++++++++++++++++
    
    ivppwdt = PWDT_NUM_CODE;//默认为数字密码方式
    
    [self viewInit];

}



#pragma mark ButtonHandler

//重写navigation 的返回按钮
-(void)leftBarButtonHandler:(id)sender
{
//    [registerView removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)textEditEndHandler:(id)sender //点击换行，退出输入法界面
{
    [nameField resignFirstResponder];
}


//用户名输入"确定" 按钮
-(void)nameRegisterHandler:(id)sender
{
    int  errorFlag=0;
    NSString *nameString = nameField.text;
    
    if( nameString.length < 6 || nameString.length > 18 ){
        errorFlag=1;  // 长度不对
    }else{
        for( int i=0 ; i< nameString.length ; i++ ){
            char sigleChar=[nameString characterAtIndex:i];
            NSString *subString=[nameString substringWithRange:NSMakeRange(i, 1)];
            const char *u8string=[subString UTF8String];
            if( i ==0 ){
                if( strlen(u8string) < 3 ){
                    if( (( sigleChar > 64 && sigleChar < 91 ) || ( sigleChar > 96 && sigleChar <123))==0){
                        errorFlag=4;    ///* 首个不是字母 */
                        break;
                    }
                }else{
                    errorFlag=5;        //首个字符是中文或是其他类型字符
                    break;
                }
                continue;
            }

            if(strlen(u8string)==3){
                errorFlag=2;       /*  含有中文*/
                break;
            }else if((sigleChar>64 && sigleChar<91)|| (sigleChar>96 && sigleChar <123) || (sigleChar>47 && sigleChar<58) || sigleChar==95)
            {
                continue;
            }else{
                errorFlag=3;        /* 不满足要求的字符 */
                break;
            }
        }
        
    }
    
    if(errorFlag==1){
        nameLabel.text=@"用户名长度不符合要求";
    }else if(errorFlag==2 || errorFlag==3 ){
        nameLabel.text=@"用户名内部含有非法字符";
    }else if(errorFlag==4 || errorFlag==5){
        nameLabel.text=@"首字母不是英文字符";
    }else{
        authID=[[NSString alloc]initWithString:nameField.text];
        if( registerView ){ //左侧滑动效果
            [UIView animateWithDuration:0.4 animations:^{
                registerView.center=CGPointMake(-registerView.center.x,registerView.center.y);
            } completion:^(BOOL finished){
                [registerView removeFromSuperview];
                }];
        }
        self.title=@"声纹测试";
        settingButt.enabled=YES;
    }
}

/* Navigation tool bar 右键 */
- (void)settingHandler:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"选择密码类型"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"固定密码", @"数字密码", nil];
    actionSheet.tag = SETTING_TAG;
    [actionSheet showInView:self.view];
}




//训练模型
-(void) trainButtonHandler:(id)sender
{
    if( [self netConnectAble] == NO ){
        [resultShow setText:@"无网络连接"];
        [self.view addSubview:resultShow];
        return;
    }
    [isvRec cancel];
    
    [self buttonDisable];
    [isvRec setParameter:TRAIN_SST forKey:KEY_SST];  //  attention isv ++++++++++++++++++++++++++++++++++++
    
    if( ivppwdt == PWDT_FIXED_CODE ){
        [self trainOrVerifyFixedCode:TRAIN_SST];
    }else if( ivppwdt == PWDT_NUM_CODE ){
        [self trainOrVerifyNumCode:TRAIN_SST];
    }
//    else if( ivppwdt == PWDT_FREE_CODE ){
//        [self trainOrVerifyFreeCode:TRAIN_SST];
//    }
    [self buttonEanble];
    
}






//验证模型
-(void)verifyButtonHandler:(UIButton *)sender
{
    if( [self netConnectAble] == NO )
    {
        [resultShow setText:@"无网络连接"];
        [self.view addSubview:resultShow];
        return;
    }
    [isvRec cancel];
    [self buttonDisable];
    
    if( ivppwdt == PWDT_FIXED_CODE ){
        [self trainOrVerifyFixedCode:VERIFY_SST];
    }else if( ivppwdt == PWDT_NUM_CODE ){
        [self trainOrVerifyNumCode:VERIFY_SST];
    }
//    else if( ivppwdt == PWDT_FREE_CODE ){
//        [self trainOrVerifyFreeCode:VERIFY_SST];
//    }
    [self buttonEanble];
}


//删除模型
-(void)deleteButtonHandler:(id)sender
{
    if( [self netConnectAble] == NO )
    {
        [resultShow setText:@"无网络连接"];
        [self.view addSubview:resultShow];
        return;
    }
    
    [self buttonDisable];
    
    if( ivppwdt == PWDT_FIXED_CODE ){
        [self startRequestFixedCode:DEL];
    }else if( ivppwdt == PWDT_NUM_CODE ){
        [self startRequestNumCode:DEL];
    }
//    else if( ivppwdt == PWDT_FREE_CODE ){
//        [self startRequestFreeCode:DEL];
//    }
    
    [self buttonEanble];
}



//查询模型
- (void)queryButtonHandler:(id)sender
{
    if( [self netConnectAble] == NO )
    {
        [resultShow setText:@"无网络连接"];
        [self.view addSubview:resultShow];
        return;
    }//判断网络连接状态
    
    [self buttonDisable];
    
    if( ivppwdt == PWDT_FIXED_CODE ){
        [self startRequestFixedCode:QUERY];
    }else if( ivppwdt == PWDT_NUM_CODE ){
        [self startRequestNumCode:QUERY];
    }
//    else if( ivppwdt == PWDT_FREE_CODE ){
//        [self startRequestFreeCode:QUERY];
//    }
    
    [self buttonEanble];
}




#pragma mark UIActionSheetDelegate

// actionsheet 点击处理函数
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self processActionSheet:actionSheet withIndex:buttonIndex];
}


-(void)processActionSheet:(UIActionSheet *)actionSheet withIndex:(NSInteger)buttonIndex
{
    if( actionSheet.tag == SETTING_TAG ) {//选择固定密码或者是数字密码或者是自由说
        switch (buttonIndex){
            case 0:
                NSLog(@"选择了固定密码");
                ivppwdt = PWDT_FIXED_CODE;
                break;
            case 1:
                NSLog(@"选择了数字密码");
                ivppwdt = PWDT_NUM_CODE;
                break;
            default:
                break;
        }
        
    }else if( actionSheet.tag == FIXED_CODE_TRAIN_TAG ){  //选择固定密码的文本密码 /注册
        if( buttonIndex < actionSheet.numberOfButtons-1 ){
            NSString *ptString=[fixCodeArray objectAtIndex:buttonIndex];
            [self defaultSetparam:authID withpdwt: PWDT_FIXED_CODE withptxt:ptString trainorverify:TRAIN_SST];
            TrainViewController *trainController=[[TrainViewController alloc]init];
            trainController.fixCodeArray=fixCodeArray;
            trainController.pwdt=PWDT_FIXED_CODE;
            trainController.sst=TRAIN_SST;
            trainController.titleString=ptString;    //设置训练的密码，用于显示在小喇叭上方
            [self presentViewController:trainController animated:YES completion:nil];
        }
        
    }else if( actionSheet.tag == FIXED_CODE_VERIFY_TAG) {
        if( buttonIndex < actionSheet.numberOfButtons-1 ){
            NSString *ptString=[fixCodeArray objectAtIndex:buttonIndex];
            [self defaultSetparam:authID withpdwt: PWDT_FIXED_CODE withptxt:ptString trainorverify:VERIFY_SST];
            TrainViewController *trainController=[[TrainViewController alloc]init];
            trainController.fixCodeArray=fixCodeArray;
            trainController.pwdt=PWDT_FIXED_CODE;
            trainController.sst=VERIFY_SST;
            trainController.titleString=ptString;    //设置训练的密码，用于显示在小喇叭上方
            [self presentViewController:trainController animated:YES completion:nil];
        }
        
    }else if( actionSheet.tag == FIXED_CODE_QUERY_TAG ){
        if( buttonIndex < actionSheet.numberOfButtons-1 ){
            NSString *ptString=[fixCodeArray objectAtIndex:buttonIndex];
            int err;
            BOOL ret;
            ret=[isvRec sendRequest:QUERY authid:authID pwdt:ivppwdt ptxt:ptString vid:nil err:&err]; // attention isv +++++++++++++++++++++++++++
            [self processRequestResult:QUERY ret:ret err:err];
        }
        
    }else if( actionSheet.tag == FIXED_CODE_DEL_TAG ){
        if( buttonIndex < actionSheet.numberOfButtons-1 ){
            NSString *ptString=[fixCodeArray objectAtIndex:buttonIndex];
            int err;
            BOOL ret;
            ret=[isvRec sendRequest:DEL authid:authID pwdt:ivppwdt ptxt:ptString vid:nil err:&err];  // attention isv ++++++++++++++++++++++++++++
            [self processRequestResult:DEL ret:ret err:err];
        }
    }
    
}


#pragma  mark SYSTEM Delegate
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark train or verify model
//声纹默认参数设置
- (void)defaultSetparam:(NSString *)auth_id withpdwt:(int) pwdt withptxt:(NSString *) ptxt trainorverify:(NSString*)sst
{
    if( isvRec != nil ){
        [isvRec setParameter:@"ivp" forKey:KEY_SUB];
        [isvRec setParameter:[NSString stringWithFormat:@"%d",pwdt] forKey:KEY_PWDT];
        [isvRec setParameter:@"50" forKey:KEY_TSD];
        [isvRec setParameter:@"3000" forKey:KEY_VADTIMEOUT];
        [isvRec setParameter:@"700" forKey:KEY_TAIL];
        [isvRec setParameter:ptxt forKey:KEY_PTXT];
        [isvRec setParameter:auth_id forKey:KEY_AUTHID];
        [isvRec setParameter:sst forKey:KEY_SST];            /* train or test */
        [isvRec setParameter:@"180000" forKey:KEY_KEYTIMEOUT];
        if( pwdt == PWDT_FIXED_CODE || pwdt == PWDT_NUM_CODE ){
            [isvRec setParameter:@"5" forKey:KEY_RGN];
        }else{
            [isvRec setParameter:@"1" forKey:KEY_RGN];
        }
    }else{
        NSLog(@"isvRec is nil\n");
    }
    
}



/* 判断网络是否连接 */
-(BOOL)netConnectAble
{
    if ( [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable ){
        return NO;
    }
    return YES;
}



//训练或者验证 固定密码
-(void)trainOrVerifyFixedCode:(NSString *)sst
{
    if( ![sst isEqualToString:VERIFY_SST] && ![sst isEqualToString:TRAIN_SST] ){
        NSLog(@"in %s,sst 参数错误",__func__);
        return;
    }
    
    fixCodeArray=[self downloadPassworld:PWDT_FIXED_CODE];
    
    if( fixCodeArray == nil ){
        [resultShow setText:@"获取密码失败"];
        [self.view addSubview:resultShow];
        return;
    }
    
    if( [sst isEqualToString:VERIFY_SST] ){
        if( fixCodeArray != nil ){
            [self generateActionSheetWithArray:fixCodeArray withTag:FIXED_CODE_VERIFY_TAG]; //点击生成的actionsheet元素，在actionSheet中处理
        }else{
            NSLog(@"固定密码，获取密码失败");
        }
    }else{
        if( fixCodeArray != nil ){
            [self generateActionSheetWithArray:fixCodeArray withTag:FIXED_CODE_TRAIN_TAG];
        }else{
            NSLog(@"固定密码，获取密码失败");
        }
    }
}


//训练或者验证 数字密码
-(void)trainOrVerifyNumCode:(NSString *)sst
{
    if( ![sst isEqualToString:VERIFY_SST] && ![sst isEqualToString:TRAIN_SST] ){
        NSLog(@"in %s,sst 参数错误",__func__);
        return;
    }
    
    numCodeArray=[self downloadPassworld:ivppwdt];
    
    if( numCodeArray == nil ){
        [resultShow setText:@"获取密码失败"];
        [self.view addSubview:resultShow];
        return;
    }
    
    if( [sst isEqualToString:VERIFY_SST] ){
        if( numCodeArray!=nil && numCodeArray.count > 0 ){
            NSString *ptString=[numCodeArray objectAtIndex:0];
            [self defaultSetparam:authID withpdwt: PWDT_NUM_CODE withptxt:ptString trainorverify:VERIFY_SST];
            TrainViewController *trainController=[[TrainViewController alloc]init];
            trainController.numCodeArray =numCodeArray;
            trainController.pwdt=PWDT_NUM_CODE;
            trainController.sst=VERIFY_SST;
            [self presentViewController:trainController animated:YES completion:nil];
        }
        
    }else{
        if( numCodeArray!=nil && numCodeArray.count > 0 ){
            NSString *ptString=[self numArrayToString:numCodeArray];
            [self defaultSetparam:authID withpdwt: PWDT_NUM_CODE withptxt:ptString trainorverify:TRAIN_SST];
            TrainViewController *trainController=[[TrainViewController alloc]init];
            trainController.numCodeArray =numCodeArray;
            trainController.pwdt=PWDT_NUM_CODE;
            trainController.sst=TRAIN_SST;
            [self presentViewController:trainController animated:YES completion:nil];
        }
    }
}


//训练或者验证  自由说
/*
-(void)trainOrVerifyFreeCode:(NSString *)sst
{
    if( ![sst isEqualToString:VERIFY_SST] && ![sst isEqualToString:TRAIN_SST] ){
        NSLog(@"in %s,sst 参数错误",__func__);
        return;
    }
    
    if( [sst isEqualToString:VERIFY_SST] ){
        [self defaultSetparam:authID withpdwt: PWDT_FREE_CODE withptxt:nil trainorverify:VERIFY_SST];
        TrainViewController *trainController=[[TrainViewController alloc]init];
        trainController.pwdt=PWDT_FREE_CODE;
        trainController.sst=VERIFY_SST;
        [self presentViewController:trainController animated:YES completion:nil];
        
    }else{
        [self defaultSetparam:authID withpdwt: PWDT_FREE_CODE withptxt:nil trainorverify:TRAIN_SST];
        TrainViewController *trainController=[[TrainViewController alloc]init];
        trainController.pwdt=PWDT_FREE_CODE;
        trainController.sst=TRAIN_SST;
        [self presentViewController:trainController animated:YES completion:nil];
    }
}
*/


#pragma mark request  model

//固定密码查询或者删除
-(void) startRequestFixedCode:(NSString *)queryMode
{
    fixCodeArray=[self downloadPassworld:PWDT_FIXED_CODE];
    if( fixCodeArray != nil ){
        if( [queryMode isEqualToString: QUERY] ){
            [self generateActionSheetWithArray:fixCodeArray withTag:FIXED_CODE_QUERY_TAG]; //点击生成的actionsheet元素，可进入训练界面
        }else if( [queryMode isEqualToString: DEL] ){
            [self generateActionSheetWithArray:fixCodeArray withTag:FIXED_CODE_DEL_TAG];
        }
    }else{
        [resultShow setText:@"获取密码失败"];
        [self.view addSubview:resultShow];
        NSLog(@"in %s,固定密码获取密码失败",__func__);
    }
}



//自由说查询或者删除
/*
-(void)startRequestFreeCode:(NSString *)queryMode
{
    if( ![queryMode isEqualToString: QUERY] && ![queryMode isEqualToString:DEL] ){
        NSLog(@"in %s,queryMode 参数错误",__func__);
        return;
    }
    int err;
    BOOL ret;
    
    ret=[isvRec sendRequest:queryMode authid:authID pwdt:PWDT_FREE_CODE ptxt:nil vid:nil err:&err]; // attention isv ++++++++++++++++++++++++++
    [self processRequestResult:queryMode ret:ret err:err];

}
 */


//数字密码查询或者删除
-(void)startRequestNumCode:(NSString *)queryMode
{
    if( ![queryMode isEqualToString: QUERY] && ![queryMode isEqualToString:DEL] ){
        NSLog(@"in %s,queryMode 参数错误",__func__);
        return;
    }
    int err;
    BOOL ret;
    ret=[isvRec sendRequest:queryMode authid:authID pwdt:PWDT_NUM_CODE ptxt:nil vid:nil err:&err];  // attention isv +++++++++++++++++++++
    [self processRequestResult:queryMode ret:ret err:err];
}

//查询或者时删除返回的结果处理
-(void)processRequestResult:(NSString*)requestMode ret:(BOOL)ret err:(int)err
{
    if( ![requestMode isEqualToString:DEL] && ![requestMode isEqualToString:QUERY]){
        NSLog(@"在%s中，queryMode参数错误",__func__);
        return;
    }
    
    if( [requestMode isEqualToString:QUERY] ){
        if( err != 0 ){
            NSLog(@"查询错误，错误码：%d",err);
            [resultShow setText:[NSString stringWithFormat:@"查询出错！错误码:%d",err]];
        }else{
            if( ret == NO ){
                NSLog(@"模型不存在");
                [resultShow setText:@"模型不存在"];
            }else{
                NSLog(@"查询成功");
                [resultShow setText:@"模型存在！"];
            }
        }
    }else if(  [requestMode isEqualToString:DEL]){
        if( err != 0 ){
            NSLog(@"删除错误，错误码：%d",err);
            [resultShow setText:[NSString stringWithFormat:@"删除出错！错误码:%d",err]];
        }else{
            if( ret == NO ){
                NSLog(@"模型不存在");
                [resultShow setText:@"模型不存在"];
            }else{
                NSLog(@"删除成功");
                [resultShow setText:@"删除成功！"];
            }
        }
    }
    [self.view addSubview:resultShow];
}

#pragma mark other function
//下载密码
-(NSArray*)downloadPassworld:(int)pwdtParam
{
    
    if( pwdtParam != PWDT_FIXED_CODE && pwdtParam != PWDT_NUM_CODE ){
        NSLog(@"in %s,pwdtParam 参数错误",__func__);
        return nil;
    }
    NSArray* tmpArray=[isvRec getPasswordList:pwdtParam];  // attention isv +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    if( tmpArray == nil ){
        NSLog(@"in %s,请求数据有误",__func__);
        return nil;
    }
    
    return tmpArray;   //返回下载
   
}



//数字密码 把array里面的数字 串起来,ISV 固定规则
-(NSString*)numArrayToString:(NSArray *)numArrayParam
{
    if( numArrayParam == nil ){
        NSLog(@"在%s中，numArrayParam is nil",__func__);
        return nil;
    }
    
    NSMutableString *ptxtString = [NSMutableString stringWithCapacity:1];
    [ptxtString appendString:[numArrayParam objectAtIndex:0]];
    
    for (int i = 1;i < [numArrayParam count] ; i++ ){
        NSString *str = [numArrayParam objectAtIndex:i];
        [ptxtString appendString:[NSString stringWithFormat:@"-%@",str]];
        
    }
    return  ptxtString;
}



//根据从网络上获得的密码，生成一个actionsheet并显示所有可用的固定密码
-(BOOL)generateActionSheetWithArray:(NSArray *)arrayParam withTag:(int)tag
{
    if( arrayParam ==nil || arrayParam.count == 0 ){
        NSLog(@"在%s中，文本密码为空，无法生成actionsheet",__func__);
    }
    
    UIActionSheet *showSheet=[[UIActionSheet alloc] initWithTitle:@"选择一个文本密码"
                                             delegate:self
                                    cancelButtonTitle:nil
                               destructiveButtonTitle:nil
                                    otherButtonTitles:nil,nil];
    showSheet.tag=tag;

    for(int i =0; i< arrayParam.count; i++){
        [showSheet addButtonWithTitle:[arrayParam objectAtIndex:i]];
    }
    
    [showSheet addButtonWithTitle:@"取消"];
    [showSheet showInView:self.view];
    return YES;
    
}



#pragma  mark  button enable or disable
-(void)buttonEanble //禁止四个button
{
    trainButt.enabled = YES;
    deleteButt.enabled = YES;
    verifyButt.enabled = YES;
    queryButt.enabled = YES;
}

-(void)buttonDisable //允许4个button
{
    trainButt.enabled = NO;
    deleteButt.enabled = NO;
    verifyButt.enabled = NO;
    queryButt.enabled = NO;
}






#pragma mark view init
-(void)viewInit
{
    self.title = @"用户名";
    self.view.backgroundColor = [UIColor whiteColor];

    
    settingButt = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:self action:@selector(settingHandler:)];
    self.navigationItem.rightBarButtonItem = settingButt;
    settingButt.enabled=NO;
    
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonHandler:)];
    CGRect rect=[[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    screenWidth = size.width;
    screenHeight=size.height;
    
    UITextView* thumbView = [[UITextView alloc] initWithFrame:CGRectMake(screenWidth/2-self.view.frame.size.width/2 +Margin, Margin, self.view.frame.size.width-2*Margin, 260)];
    thumbView.text = @"1.点击右上角\"设置\"按钮选择声纹类型\n\n2.点击\"训练模型\"按钮，通过训练向服务器注册声纹模型\n\n3.在训练模型界面，如果是固定密码或者是数字密码类型，点击\"开始录音\"按钮并朗读麦克风图标上方文字，朗读完等待1秒后点击\"停止录音\"，重复直到下方显示的数字为5\n\n4.训练成功后，可以点击\"识别声纹\"按钮进行验证\n\n5.可以点击\"删除模型\"或者是\"查询模型\"进行删除或是查询声纹模型操作";
    thumbView.layer.borderWidth = 1;
    thumbView.layer.cornerRadius = 8;
    
    thumbView.editable = NO;
    thumbView.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:thumbView];
    
    
    
    
    
    UIView *trainButtView=[[UIView alloc]initWithFrame:CGRectMake(4, 289, 140.5, 43.5)];
    trainButtView.backgroundColor=[UIColor grayColor];
    trainButt= [UIButton buttonWithType:UIButtonTypeCustom];
    [trainButt setBackgroundImage:[UIImage imageNamed:@"speekNormal"] forState:UIControlStateNormal];
    [trainButt setBackgroundImage:[UIImage imageNamed:@"speekDone"] forState:UIControlStateHighlighted];
    [trainButt setBackgroundImage:[UIImage imageNamed:@"cancelDone"] forState:UIControlStateDisabled];
    [trainButt setFrame:CGRectMake(0.5 , 0, 140, 43)];
    [trainButt setTitle:@"训练模型" forState:UIControlStateNormal];
    [trainButt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [trainButt setTitleColor:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1] forState:UIControlStateHighlighted];
    [trainButt setTitleColor:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1] forState:UIControlStateDisabled];
    [trainButt addTarget:self action:@selector(trainButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    trainButt.exclusiveTouch=YES;//训练按钮
    [trainButtView addSubview:trainButt];
    [self.view  addSubview: trainButtView];
    
    
    
    UIView *verifyButtView=[[UIView alloc]initWithFrame:CGRectMake(screenWidth-144.5, 289, 140.5, 43.5)];//width 135.5
    verifyButtView.backgroundColor=[UIColor grayColor];
    verifyButt= [UIButton buttonWithType:UIButtonTypeCustom];
    [verifyButt setBackgroundImage:[UIImage imageNamed:@"speekNormal"] forState:UIControlStateNormal];
    [verifyButt setBackgroundImage:[UIImage imageNamed:@"speekDone"] forState:UIControlStateHighlighted];
    [verifyButt setBackgroundImage:[UIImage imageNamed:@"cancelDone"] forState:UIControlStateDisabled];
    [verifyButt setFrame:CGRectMake(0.5 , 0, 140, 43)];
    [verifyButt setTitle:@"识别声纹" forState:UIControlStateNormal];
    [verifyButt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [verifyButt setTitleColor:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1] forState:UIControlStateHighlighted];
    [verifyButt setTitleColor:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1] forState:UIControlStateDisabled];
    [verifyButt addTarget:self action:@selector(verifyButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    verifyButt.exclusiveTouch=YES;//验证模型按钮
    [verifyButtView addSubview:verifyButt];
    [self.view  addSubview: verifyButtView];
    
    
    
    UIView *deleteButtView=[[UIView alloc]initWithFrame:CGRectMake(4, 340.5, 140.5, 43.5)];//width 135.5
    deleteButtView.backgroundColor=[UIColor grayColor];
    deleteButt= [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButt setBackgroundImage:[UIImage imageNamed:@"speekNormal"] forState:UIControlStateNormal];
    [deleteButt setBackgroundImage:[UIImage imageNamed:@"speekDone"] forState:UIControlStateHighlighted];
    [deleteButt setBackgroundImage:[UIImage imageNamed:@"cancelDone"] forState:UIControlStateDisabled];
    [deleteButt setFrame:CGRectMake(0.5 , 0, 140, 43)];
    [deleteButt setTitle:@"删除模型" forState:UIControlStateNormal];
    [deleteButt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteButt setTitleColor:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1] forState:UIControlStateHighlighted];
    [deleteButt setTitleColor:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1] forState:UIControlStateDisabled];
    [deleteButt addTarget:self action:@selector(deleteButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    deleteButt.exclusiveTouch=YES;//删除模型按钮
    [deleteButtView addSubview:deleteButt];
    [self.view  addSubview: deleteButtView];
    
    
    UIView *queryButtView=[[UIView alloc]initWithFrame:CGRectMake(screenWidth-144.5, 340.5, 140.5, 43.5)];//width 135.5
    queryButtView.backgroundColor=[UIColor grayColor];
    queryButt= [UIButton buttonWithType:UIButtonTypeCustom];
    [queryButt setBackgroundImage:[UIImage imageNamed:@"speekNormal"] forState:UIControlStateNormal];
    [queryButt setBackgroundImage:[UIImage imageNamed:@"speekDone"] forState:UIControlStateHighlighted];
    [queryButt setBackgroundImage:[UIImage imageNamed:@"cancelDone"] forState:UIControlStateDisabled];
    
    [queryButt setFrame:CGRectMake(0.5 , 0, 140, 43)];
    [queryButt setTitle:@"查询模型" forState:UIControlStateNormal];
    [queryButt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [queryButt setTitleColor:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1] forState:UIControlStateHighlighted];
    [queryButt setTitleColor:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1] forState:UIControlStateDisabled];
    [queryButt addTarget:self action:@selector(queryButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    queryButt.exclusiveTouch=YES;//查询模型按钮
    [queryButtView addSubview:queryButt];
    [self.view  addSubview: queryButtView];
    
    resultShow =  [[PopupView alloc]initWithFrame:CGRectMake(100, 240, 0, 0)];
    resultShow.ParentView=self.view;    // 渐变结果显示

    authID=[[NSString alloc]init];    // 用户名
    

    registerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,screenWidth,screenHeight)];
    registerView.backgroundColor=[UIColor whiteColor];   // 输入用户名界面
    
    UIView *namebackView=[[UIView alloc]initWithFrame:CGRectMake(screenWidth/2-120-Slide/2,30-Slide/2,240+Slide,25+Slide)];
    namebackView.backgroundColor=[UIColor blackColor];
    [registerView addSubview:namebackView];
    
    nameField=[[UITextField alloc]initWithFrame:CGRectMake(screenWidth/2-120,30,240,25)];
    [nameField setBackgroundColor:[UIColor whiteColor]];
    [nameField addTarget:self action:@selector(textEditEndHandler:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [registerView addSubview:nameField];
    
    UIButton *nameButt=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nameButt setFrame:CGRectMake(screenWidth/2-40, 65, 80, 25)];
    [nameButt setTitle:@"确定" forState:UIControlStateNormal];
    [nameButt addTarget:self action:@selector(nameRegisterHandler:) forControlEvents:UIControlEventTouchUpInside];
    [nameButt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerView addSubview:nameButt];
    
    nameLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 120, screenWidth, 40)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"请输入由字母、数字、下划线组成的用户名";
    [registerView addSubview:nameLabel];
    
    [self.view addSubview:registerView];

}
@end
