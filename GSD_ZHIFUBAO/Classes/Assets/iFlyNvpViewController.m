//
//  DiagleView.m
//
//
//

#import "iFlyNvpViewController.h"
#import "iflyMSC/IFlySpeechError.h"
#import "Reachability.h"
#import "iflyMSC/iFlyISVRecognizer.h"
#import "DiagleView.h"
#import "ProfileManager.h"

#pragma  mark  result_dic key
#define  SUC_KEY           @"suc"
#define  RGN_KEY           @"rgn"

#pragma pwdt type
#define PWDT_NUM_CODE      3

#pragma mark value of key
#define  TRAIN_SST          @"train"
#define  VERIFY_SST         @"verify"
#define  DCS                @"dcs"
#define  SUCCESS            @"success"
#define  FAIL               @"fail"

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define Margin  5
#define Slide   2

#define pwdt_code 3

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

#define kErrModelNotExist   10116

@interface  iFlyNvpViewController()
{
    IFlyISVRecognizer      *isvRec;     //atention 声纹类的单例模式 atention  +++++++++++++++++++++++++++++++
    
    UIButton               *trainButt;
    
    UIButton               *verifyButt;
    
    PopupView              *resultShow;   //动态显示界面 黑底白字
    
    NSString               *voiceID;    //atention  声纹用户名++++++++++++++++++++++++++++++++++++
    
    int                     screenWidth ; //界面宽度
    
    int                     screenHeight; //界面宽度
    
    int                     ivppwdt;      //atention  声纹密码类型参数+++++++++++++++++++++++++++++++++++++++
    
    NSArray * fixCodeArray;             //固定密码数组  +++++++++++++++++++++++++++++++++++++++++++++++++++++!
    
}

@end

@implementation iFlyNvpViewController

@synthesize numCodeArray = _numCodeArray;

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
    
    voiceID = [NSString new];
    
    voiceID = [[NSString alloc] initWithString:[kModelSugar stringByAppendingString:[[ProfileManager sharedInstance] getUserPhone]]];
    
    isvRec=[IFlyISVRecognizer sharedInstance];    // 创建声纹对象 attention isv +++++++++++++++++++++++++++++++++++++
    isvRec.delegate = self;
    ivppwdt = PWDT_NUM_CODE;
    
    [isvRec setParameter:[NSString stringWithFormat:@"%d",pwdt_code] forKey:KEY_PWDT];
    [isvRec setParameter:voiceID forKey:KEY_AUTHID];
    [isvRec setParameter:@"3000" forKey:KEY_VADTIMEOUT];
    [isvRec setParameter:@"700" forKey:KEY_TAIL];
    [isvRec setParameter:@"180000" forKey:KEY_KEYTIMEOUT];
    [isvRec setParameter:@"50" forKey:KEY_TSD];
    
    [self trainOrVerifyNumCode:_sst];
    
    self.diagView=[[DiagleView alloc]initWithFrame:kScreenBound];//录音界面
    [self.diagView.cancelButton addTarget:self action:@selector(cancelButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self initialDiagViewRecordTtile];//初始化录音界面的titile
    [self.diagView.startRecButton addTarget:self action:@selector(startButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.diagView.stopRecButton  addTarget:self action:@selector(stopButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.diagView];
    
    if ([_sst  isEqual: VERIFY_SST]) {
        self.diagView.cancelButton.enabled = NO;
        self.diagView.cancelButton.tintColor = [UIColor grayColor];
    }
    
    self.trainVerifyAlert=[[UIAlertView alloc]initWithTitle:@"nihao"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
}

#pragma  mark button Handler

-(void)startButtonHandler:(id)sender
{
    if( [self netConnectAble] == NO )
    {
        [self.trainVerifyAlert setTitle:@"网络连接异常"];
        [self.trainVerifyAlert show];
        return;
    }
    
    self.diagView.startRecButton.enabled=NO;
    [isvRec startListening];//开始录音
}

-(void)stopButtonHandler:(id)sender
{
    NSLog(@"stopButtonHandler");
    [isvRec stopListening];//停止录音
}


-(void)cancelButtonHandler:(id)sender
{
    [isvRec cancel];//结束会话
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma  mark iFlyISVDelegate

//正常结果返回回调
-(void)onResult:(NSDictionary *)dic
{
    NSLog(@"onResult");
    [self.diagView.recognitionView stopAnimating];
    [self.diagView recordViewInit];
    
    [self resultProcess:dic];
    self.diagView.startRecButton.enabled = YES;
    //should stop
    //    [self.diagView setRoundButtonCurrentType:@(0)];
}



//发生错误
-(void) onError:(IFlySpeechError *) errorCode
{
    NSLog(@"onError");
    [self.diagView.recognitionView stopAnimating];
    [self.diagView recordViewInit];
    
    if( errorCode.errorCode != 0 )
    {
        self.diagView.startRecButton.enabled=YES;
        if (errorCode.errorCode == 10121) {
            
            [[ProfileManager sharedInstance] setVoiceIDWithSugar];
            NSLog(@"in %s,模型已存在",__func__);
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"模型已存在" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            return;
        }
        self.diagView.resultLabel.textColor=[UIColor redColor];
        self.diagView.resultLabel.text=[NSString stringWithFormat:@"错误码:%d",errorCode.errorCode];
    }
    
    self.diagView.startRecButton.enabled=YES;
    
}


//音量回调
-(void)onVolumeChanged:(int)volume
{
    NSLog(@"onVolumechanged");
    [self.diagView recordViewChangeWithVolume:volume];
}

//识别中回调
-(void)onRecognition
{
    NSLog(@"正在识别中");
    [self performSelectorOnMainThread:@selector(hideRecordView) withObject:nil waitUntilDone:YES];
    //    [self.diagView.recordView removeFromSuperview];//替代方法
    [self.diagView.recognitionView startAnimating];
    
}

#pragma  mark initial recordTitle

-(void)initialDiagViewRecordTtile //录音小窗口标题设置
{
    if( _numCodeArray != nil && _numCodeArray.count !=0 )
        self.diagView.recordTitleLable.text=[_numCodeArray objectAtIndex:0];
}


#pragma mark result process

//对声纹回调结果进行处理
-(void)resultProcess:(NSDictionary *)dic
{
    if( dic == nil ){
        NSLog(@"in %s,dic is nil",__func__);
        return;
    }
    
    if( [self.sst isEqualToString:TRAIN_SST] ){  //训练结果
        
        NSNumber *suc=[dic objectForKey:SUC_KEY] ;
        self.diagView.resultLabel.textColor=[UIColor blackColor];
        self.diagView.resultLabel.text=[NSString stringWithFormat:@"%d",[suc intValue]];
        NSNumber *rgn=[dic objectForKey:RGN_KEY];
        
        if( [suc intValue] >= [rgn intValue] ){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"训练成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                
                NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                
                NSString* notifyName = @"register success";
                NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:notifyName, @"NotifyName", nil];
                
                [nc postNotificationName:@"Register" object:self userInfo:dict];
                
                [[ProfileManager sharedInstance] setVoiceIDWithSugar];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        
        if( [suc intValue] < [rgn intValue] ){
            self.diagView.recordTitleLable.text=[_numCodeArray objectAtIndex:[suc intValue]];
        }
    }else if( [self.sst isEqualToString:VERIFY_SST] ){ //验证结果
        
        self.diagView.resultLabel.text=@""; //结果label不显示
        NSString *successStr=@"";
        
        if( [[dic objectForKey:DCS] isEqualToString:SUCCESS] ){
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"验证成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
//                [[ProfileManager sharedInstance] setVoiceIDWithSugar];
                //登录时发送消息，推出控制器。
                NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                
                NSString* notifyName = @"login success";
                NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:notifyName, @"NotifyName", nil];
                
                [nc postNotificationName:@"Login" object:self userInfo:dict];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            successStr=@"验证失败";
        }
//        [self.trainVerifyAlert setTitle:successStr];
//        [self.trainVerifyAlert show];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"验证失败" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            //                [[ProfileManager sharedInstance] setVoiceIDWithSugar];
//            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
 
    }
    
}

#pragma  mark  net detect
//网络连接判断
-(BOOL)netConnectAble
{
    if ( [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable ){
        return NO;
    }
    return YES;
}


-(void)hideRecordView
{
    [self.diagView.recordView setHidden:YES];
}


#pragma mark - DiagView delegate


//训练模型
-(void) trainButtonHandler:(id)sender
{
    if( [self netConnectAble] == NO ){
        [resultShow setText:@"无网络连接"];
        [self.view addSubview:resultShow];
        return;
    }
    [isvRec cancel];
    
    [isvRec setParameter:TRAIN_SST forKey:KEY_SST];  //  attention isv ++++++++++++++++++++++++++++++++++++
    
    
    [self trainOrVerifyNumCode:TRAIN_SST];
    
}

//
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
    
    
    [self trainOrVerifyNumCode:VERIFY_SST];
    
    [self buttonEanble];
}



//训练或者验证 数字密码
-(void)trainOrVerifyNumCode:(NSString *)sst
{
    if( ![sst isEqualToString:VERIFY_SST] && ![sst isEqualToString:TRAIN_SST] ){
        NSLog(@"in %s,sst 参数错误",__func__);
        return;
    }
    
    _numCodeArray=[self downloadPassworld:ivppwdt];
    
    if( _numCodeArray == nil ){
        [resultShow setText:@"获取密码失败"];
        [self.view addSubview:resultShow];
        return;
    }
    
    if( [sst isEqualToString:VERIFY_SST] ){
        if( _numCodeArray!=nil && _numCodeArray.count > 0 ){
            NSString *ptString=[_numCodeArray objectAtIndex:0];
            [isvRec setParameter:ptString forKey:KEY_PTXT];
            [isvRec setParameter:VERIFY_SST forKey:KEY_SST];
            
        }
        
    }else{
        if( _numCodeArray!=nil && _numCodeArray.count > 0 ){
            NSString *ptString=[self numArrayToString:_numCodeArray];
            [isvRec setParameter:ptString forKey:KEY_PTXT];
            [isvRec setParameter:TRAIN_SST forKey:KEY_SST];
        }
    }
}


#pragma mark other function
//下载密码
-(NSArray*)downloadPassworld:(int)pwdtParam
{
    //    if( [self netConnectAble] == NO )
    //    {
    //        [resultShow setText:@"无网络连接"];
    //        [self.view addSubview:resultShow];
    //
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //    }
    //
    
    if(pwdtParam != PWDT_NUM_CODE ){
        NSLog(@"in %s,pwdtParam 参数错误",__func__);
        return nil;
    }
    NSArray* tmpArray=[isvRec getPasswordList:pwdtParam];  // attention isv +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    if( tmpArray == nil ){
        //        NSLog(@"in %s,请求数据有误",__func__);
        //        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"获取声纹数字失败" message:@"请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
        //        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        //            [self dismissViewControllerAnimated:YES completion:nil];
        //        }];
        //        [alert addAction:defaultAction];
        //        [self.navigationController presentViewController:alert animated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        
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



#pragma  mark  button enable or disable
-(void)buttonEanble //禁止四个button
{
    trainButt.enabled = YES;
    verifyButt.enabled = YES;
}

-(void)buttonDisable //允许4个button
{
    trainButt.enabled = NO;
    verifyButt.enabled = NO;
}

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
        if( pwdt == PWDT_NUM_CODE ){
            [isvRec setParameter:@"5" forKey:KEY_RGN];
        }else{
            [isvRec setParameter:@"1" forKey:KEY_RGN];
        }
    }else{
        NSLog(@"isvRec is nil\n");
    }
    
}

//删除模型
-(void)deleteButtonHandler:(id)sender
{
    
    [self startRequestNumCode:@"del"];
}

//数字密码查询或者删除
-(void)startRequestNumCode:(NSString *)queryMode
{
    if( ![queryMode isEqualToString: @"que"] && ![queryMode isEqualToString:@"del"] ){
        NSLog(@"in %s,queryMode 参数错误",__func__);
        return;
    }
    int err;
    BOOL ret;
    ret=[isvRec sendRequest:queryMode authid:voiceID pwdt:PWDT_NUM_CODE ptxt:nil vid:nil err:&err];  // attention isv +++++++++++++++++++++
    [self processRequestResult:queryMode ret:ret err:err];
}

//查询或者时删除返回的结果处理
-(void)processRequestResult:(NSString*)requestMode ret:(BOOL)ret err:(int)err
{
    if( ![requestMode isEqualToString:@"del"] && ![requestMode isEqualToString:@"que"]){
        NSLog(@"在%s中，queryMode参数错误",__func__);
        return;
    }
    
    if( [requestMode isEqualToString:@"que"] ){
        if( err != 0 ){
            NSLog(@"查询错误，错误码：%d",err);
            //处理返回值
            if (err == kErrModelNotExist) {
                NSLog(@"模型不存在");
                [[ProfileManager sharedInstance] setVoiceID:@""];
            }
        }else{
            if( ret == NO ){
                NSLog(@"模型不存在");
                //                [resultShow setText:@"模型不存在"];
            }else{
                NSLog(@"查询成功");
                //                [resultShow setText:@"模型存在！"];
            }
        }
    }else if(  [requestMode isEqualToString:@"del"]){
        if( err != 0 ){
            NSLog(@"删除错误，错误码：%d",err);
            //处理返回值
            if (err == kErrModelNotExist) {
                NSLog(@"模型不存在");
                [[ProfileManager sharedInstance] setVoiceID:@""];
            }
        }else{
            if( ret == NO ){
                NSLog(@"模型不存在");
            }else{
                [[ProfileManager sharedInstance] setVoiceID:@""];
                NSLog(@"删除成功");
            }
        }
    }
}

@end
