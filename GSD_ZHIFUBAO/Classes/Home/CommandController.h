//
//  CommandController.h
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/16/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "BaseController.h"
#import "iflyMSC/iflyMSC.h"

@class IFlySpeechRecognizer;
@class IFlyPcmRecorder;

/**
 语音听写
 使用该功能仅仅需要四步
 1.创建识别对象；
 2.设置识别参数；
 3.有选择的实现识别回调；
 4.启动识别
 */

@interface CommandController : BaseController <IFlySpeechRecognizerDelegate, IFlyPcmRecorderDelegate>

@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic, strong) NSString * result;
@property (nonatomic, assign) BOOL isCanceled;

@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//录音器，用于音频流识别的数据传入
@property (nonatomic,assign) BOOL isStreamRec;//是否是音频流识别

@property (nonatomic, strong) UIButton* startRecBtn;
@property (nonatomic, strong) UIButton* stopRecBtn;

@end
