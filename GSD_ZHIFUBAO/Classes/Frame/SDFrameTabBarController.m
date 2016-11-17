//
//  SDFrameTabBarController.m
//  GSD_ZHIFUBAO
//
//  Created by aier on 15-6-3.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 *********************************************************************************
 
 */

#import "SDFrameTabBarController.h"
#import "SDBasicNavigationController.h"
#import "SDBasicViewContoller.h"
#import "SDHomeViewController.h"
#import "SDAssetsTableViewController.h"
#import "MBProgressHUD.h"


#define HOST @"127.0.0.1"
#define PORT  8808

@interface SDFrameTabBarController ()

@property (nonatomic, retain) NSTimer        *connectTimer; // 计时器
@property (nonatomic, strong) GCDAsyncSocket* asyncSocket;

@end

@implementation SDFrameTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupChildControllers];
    [self connectTCP];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(recvNotif:) name:@"Socket" object:nil];
    
    self.selectedIndex = 1;
    
}

- (void)setupChildControllers
{
    [self setupChildNavigationControllerWithClass:[SDBasicNavigationController class] tabBarImageName:@"TabBar_HomeBar" rootViewControllerClass:[SDHomeViewController class] rootViewControllerTitle:@"首页"];
    
    [self setupChildNavigationControllerWithClass:[SDBasicNavigationController class] tabBarImageName:@"TabBar_Assets" rootViewControllerClass:[SDAssetsTableViewController class] rootViewControllerTitle:@"我的"];
}

- (void)setupChildNavigationControllerWithClass:(Class)class tabBarImageName:(NSString *)name rootViewControllerClass:(Class)rootViewControllerClass rootViewControllerTitle:(NSString *)title
{
    UIViewController *rootVC = [[rootViewControllerClass alloc] init];
    rootVC.title = title;
    UINavigationController *navVc = [[class  alloc] initWithRootViewController:rootVC];
    navVc.tabBarItem.image = [UIImage imageNamed:name];
    navVc.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Sel", name]];
    [self addChildViewController:navVc];
}

#pragma mark - Socket

- (void)connectTCP {
    if (!_asyncSocket)
    {
        _asyncSocket=nil;
    }
    
    _asyncSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    _asyncSocket.delegate = self;
    
    NSError *error = nil;
    [_asyncSocket connectToHost:HOST onPort:PORT withTimeout:-1 error:&error];
    if (error!=nil) {
        NSLog(@"连接失败：%@",error);
    }else{
        NSLog(@"连接成功");
    }
}

- (void)socket:(GCDAsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"willDisconnectWithError");
    //[self logInfo:FORMAT(@"Client Disconnected: %@:%hu", [sock connectedHost], [sock connectedPort])];
    if (err) {
        NSLog(@"错误报告：%@",err);
    }else{
        NSLog(@"连接工作正常");
    }
    _asyncSocket = nil;
}

//连接成功回调
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"didConnectToHost");
    //    NSData *writeData = [@"connected\r\n" dataUsingEncoding:NSUTF8StringEncoding];
    //    [sock writeData:writeData withTimeout:-1 tag:0];
    
    // 每隔30s像服务器发送心跳包
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];// 在longConnectToSocket方法中进行长连接需要向服务器发送的讯息
    
    [self.connectTimer fire];//    [sock readDataWithTimeout:0.5 tag:0];
    
    [_asyncSocket readDataWithTimeout:-1 tag:0];

}

// 心跳连接
-(void)longConnectToSocket{
    
    // 根据服务器要求发送固定格式的数据，假设为指令@"longConnect"，但是一般不会是这么简单的指令
    
    NSString *longConnect = @"longConnect";
    
#warning need \r\n or not
    
    NSData   *dataStream  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    
    [_asyncSocket writeData:dataStream withTimeout:1 tag:1];
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"didReadData");
    NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length])];
    NSString *msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    if(msg)
    {
        NSLog(@"%@",msg);
        //处理接收数据
        
    }
    else
    {
        NSLog(@"错误");
    }
    
    [sock readDataWithTimeout:-1 tag:0]; //一直监听网络
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    
    
}

- (void)recvNotif:(NSNotification*)notify {
    // 取得广播内容
    NSDictionary *dict = [notify userInfo];
    NSString* name = [dict objectForKey:@"NotifyName"];
    NSString* data= [dict objectForKey:@"Data"];
    
    if ([name isEqualToString:@"send cammand"]) {
        //发送命令
    }else if ([name isEqualToString:@"receive data"]) {
        //接收数据
    }
    
}

#pragma mark - Other Methods

-(void)toast:(NSString *)title
{
    int seconds = 3;
    [self toast:title seconds:seconds];
}

-(void)toast:(NSString *)title seconds:(int)seconds
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.detailsLabelText = title;
    HUD.mode = MBProgressHUDModeText;
    
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(seconds);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

@end
