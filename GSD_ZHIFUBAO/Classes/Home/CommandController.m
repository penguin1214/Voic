//
//  CommandController.m
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/16/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "CommandController.h"
//#import "ISRDataHelper.m"
#import "ProfileManager.h"
#import "Command.h"

@interface CommandController () {
    NSString* _code;
}

@end

@implementation CommandController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initRecognizer];
    
    _startRecBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 220, 30)];
    _startRecBtn.backgroundColor = kColorMainGreen;
    [_startRecBtn setTitle:@"发送命令" forState:UIControlStateNormal];
    [_startRecBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_startRecBtn];
    
    [_startRecBtn addTarget:self action:@selector(startBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    
    [_startRecBtn setEnabled:YES];
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    NSLog(@"%s",__func__);
    [_iFlySpeechRecognizer cancel]; //取消识别
    [_pcmRecorder stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 设置识别参数
 ****/
-(void)initRecognizer
{
    NSLog(@"%s",__func__);
    
    _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
    
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    _iFlySpeechRecognizer.delegate = self;
    
    [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    
    //设置是否返回标点符号
    [_iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
    
    //设置语言
    [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
    
    //设置采样率，推荐使用16K
    [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    
    //初始化录音器
    if (_pcmRecorder == nil)
    {
        _pcmRecorder = [IFlyPcmRecorder sharedInstance];
    }
    
    _pcmRecorder.delegate = self;
    
    [_pcmRecorder setSaveAudioPath:nil];    //不保存录音文件
}

/**
 启动听写
 *****/
- (void)startBtnHandler {
    
    NSLog(@"%s[IN]",__func__);
    
    
    self.isCanceled = NO;
    self.isStreamRec = NO;
    
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    
    [_iFlySpeechRecognizer cancel];
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    BOOL ret = [_iFlySpeechRecognizer startListening];
    
    if (!ret) {
        [self toast:@"启动识别服务失败，请稍后重试"];
    }
    
//    _startRecBtn.enabled = NO;
    
}

/**
 停止录音
 *****/
- (void)stopBtnHandler {
    
    NSLog(@"%s",__func__);
    
    [_iFlySpeechRecognizer stopListening];
}

/**
 取消听写
 *****/
- (void)cancelBtnHandler {
    
    NSLog(@"%s",__func__);
    
    self.isCanceled = YES;
    
    [_iFlySpeechRecognizer cancel];
    
}

#pragma mark - IFlySpeechRecognizerDelegate

/**
 音量回调函数
 volume 0－30
 ****/
- (void) onVolumeChanged: (int)volume
{
    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
}


/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech
{
    NSLog(@"onBeginOfSpeech");
    
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
    NSLog(@"onEndOfSpeech");
    
    [_pcmRecorder stop];
//    [self toast:@"停止录音"];
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    NSLog(@"%s",__func__);
    
    NSString *text ;
    
    if (self.isCanceled) {
        text = @"识别取消";
        
    } else if (error.errorCode == 0 ) {
        if (_result.length == 0) {
            text = @"无识别结果";
        }else {
            text = @"识别成功";
            //清空识别结果
            _result = nil;
        }
    }else {
        text = [NSString stringWithFormat:@"发生错误：%d %@", error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
    }
    
//    [self toast:text];
    
    
    [_startRecBtn setEnabled:YES];
    NSLog(@"22222222");
}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSString * resultFromJson =  [self stringFromJson:resultString];
    
    if (isLast){
        NSLog(@"听写结果(json)：%@测试",  self.result);
    }
    NSLog(@"_result=%@",_result);
    NSLog(@"resultFromJson=%@",resultFromJson);
    [self toast:[NSString stringWithFormat:@"%@",resultFromJson]];
    
#warning test code
//    [self sendCommand:@"1"];
    
    NSArray* commandArray = [[ProfileManager sharedInstance] getAllCommand];
    
    NSArray* commands = [NSMutableArray new];
    for (NSData* aCom in commandArray) {
        Command* com = [NSKeyedUnarchiver unarchiveObjectWithData:aCom];
        if ([com.command isEqualToString:resultFromJson]) {
            _code = [NSString stringWithString:com.commandCode];
            break;
        }
    }
    [self sendCommand:_code];
    
//    _startRecBtn.enabled = YES;
    
}

/**
 听写取消回调
 ****/
- (void) onCancel
{
    NSLog(@"识别取消");
}


#pragma mark - IFlyDataUploaderDelegate

/**
 设置UIButton的ExclusiveTouch属性
 ****/
-(void)setExclusiveTouchForButtons:(UIView *)myView
{
    for (UIView * button in [myView subviews]) {
        if([button isKindOfClass:[UIButton class]])
        {
            [((UIButton *)button) setExclusiveTouch:YES];
        }
        else if ([button isKindOfClass:[UIView class]])
        {
            [self setExclusiveTouchForButtons:button];
        }
    }
}


#pragma mark - IFlyPcmRecorderDelegate

- (void) onIFlyRecorderBuffer: (const void *)buffer bufferSize:(int)size
{
    NSData *audioBuffer = [NSData dataWithBytes:buffer length:size];
    
    int ret = [self.iFlySpeechRecognizer writeAudio:audioBuffer];
    if (!ret)
    {
        [self.iFlySpeechRecognizer stopListening];
        
        [_startRecBtn setEnabled:YES];
        
        
    }
}


//power:0-100,注意控件返回的音频值为0-30
- (void) onIFlyRecorderVolumeChanged:(int) power
{
    //    NSLog(@"%s,power=%d",__func__,power);
    
    if (self.isCanceled) {
        return;
    }
    
    NSString * vol = [NSString stringWithFormat:@"音量：%d",power];
}

/**
 解析听写json格式的数据
 params例如：
 {"sn":1,"ls":true,"bg":0,"ed":0,"ws":[{"bg":0,"cw":[{"w":"白日","sc":0}]},{"bg":0,"cw":[{"w":"依山","sc":0}]},{"bg":0,"cw":[{"w":"尽","sc":0}]},{"bg":0,"cw":[{"w":"黄河入海流","sc":0}]},{"bg":0,"cw":[{"w":"。","sc":0}]}]}
 ****/
- (NSString *)stringFromJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}

#pragma mark - send command

- (void)sendCommand:(NSString*)commandCode {
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    
    NSString* notifyName = @"send command";
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:notifyName, @"NotifyName",commandCode, @"Data", nil];
    
    
    [nc postNotificationName:@"Socket" object:self userInfo:dict];
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
