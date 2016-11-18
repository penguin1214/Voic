//
//  SetCommandController.m
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/18/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "SetCommandController.h"
#import "SMPagerTabView.h"
#import "SetCommandDetailController.h"
#import "SDGridItemCacheTool.h"
#import "DeviceInfo.h"
#import "Command.h"
#import "ProfileManager.h"

@interface SetCommandController () <SMPagerTabViewDelegate>

@property (nonatomic, strong) NSMutableArray *allVC;
@property (nonatomic, strong) SMPagerTabView *segmentView;

//@property (nonatomic, strong) DeviceInfo* deviceInfo;
@property (nonatomic, strong) NSMutableDictionary* colorStatPair;
@property (nonatomic, strong) NSString* imgResString;

@end

@interface SetCommandController () {
    NSInteger _tabNum;
}

@end

@implementation SetCommandController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexColor:@"ededed"];
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didFinishSetting)];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    NSArray* itemsArray = [SDGridItemCacheTool itemsArray];
    DeviceInfo* _device = [NSKeyedUnarchiver unarchiveObjectWithData:[itemsArray objectAtIndex:[_deviceIndex integerValue]]];
    
    _allVC = [NSMutableArray array];
    _tabNum = _device.colorStatPair.count;
    
    for (int i = 0; i < _tabNum; i++ ) {
        SetCommandDetailController* vc = [[SetCommandDetailController alloc] init];
        vc.tag = @(i);
        
//        vc.delegate = self;
        
        if (i == 0) {
            vc.title = [NSString stringWithFormat:@"状态%@（默认）", @(i+1)];
        }else {
            vc.title = [NSString stringWithFormat:@"状态%@", @(i+1)];
        }
        [_allVC addObject:vc];
    }
    
    self.segmentView.delegate = self;
    //可自定义背景色和tab button的文字颜色等
    //    self.segmentView.tabButtonTitleColorForSelected = kColorMainGreen;
    
    //开始构建UI
    [_segmentView buildUI];
    //起始选择一个tab
    [_segmentView selectTabWithIndex:0 animate:NO];
//    显示红点，点击消失
        [_segmentView showRedDotWithIndex:0];
}


#pragma mark - DBPagerTabView Delegate
- (NSUInteger)numberOfPagers:(SMPagerTabView *)view {
    return [_allVC count];
}
- (UIViewController *)pagerViewOfPagers:(SMPagerTabView *)view indexOfPagers:(NSUInteger)number {
    return _allVC[number];
}

- (void)whenSelectOnPager:(NSUInteger)number {
    NSLog(@"页面 %lu",(unsigned long)number);
}

#pragma mark - setter/getter
- (SMPagerTabView *)segmentView {
    if (!_segmentView) {
        self.segmentView = [[SMPagerTabView alloc]initWithFrame:CGRectMake(10, 20, self.view.width-20, 180)];
        [self.view addSubview:_segmentView];
    }
    return _segmentView;
}

- (void)didFinishSetting {
//    NSString* command = [NSString stringWithString:[self.segmentView[0].command]];
//    NSString* commandCode = [NSString stringWithString:[self.segmentView[0].commandCode]];
    NSMutableArray* temp = [[[ProfileManager sharedInstance] getAllCommand] mutableCopy];
    
    for (SetCommandDetailController* vc in _allVC) {
        NSDictionary* dict = [vc collectCommand];
        NSString* command = [dict objectForKey:@"command"];
        NSString* commandCode = [dict objectForKey:@"commandCode"];
        
        Command* _command = [[Command alloc] init];
        _command.command = command;
        _command.commandCode = commandCode;
        
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:_command];
        [temp addObject:data];
    }
    
    [[ProfileManager sharedInstance] setCommand:temp];

    
//#warning HARD CODE
//    NSString* command = @"开第一盏灯";
//    NSString* commandCode = @"0";
//    Command* _command = [[Command alloc] init];
//    _command.command = command;
//    _command.commandCode = commandCode;
    
//    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:_command];
//    [[ProfileManager sharedInstance] setCommand:[NSArray arrayWithObject:data]];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
