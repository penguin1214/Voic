//
//  SDHomeViewController.m
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


#import "SDHomeViewController.h"
#import "UIView+SDExtension.h"
#import "SDHomeGridView.h"
#import "SDHomeGridItemModel.h"
#import "SDAddItemViewController.h"
#import "SDGridItemCacheTool.h"
#import "AddItemViewController.h"
#import "DeviceInfo.h"

#define kHomeHeaderViewHeight 110

#define kTitleIndexInPair 0
#define kColorIndexInPair 1

#define kTitleIndex 0
#define kImageResStringIndex 1
#define kCurrentStatIndex 2
#define kColorStatPairIndex 3
#define kDestinationClassIndex 4

@interface SDHomeViewController () <SDHomeGridViewDeleate>

@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, strong) SDHomeGridView *mainView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SDHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupHeader];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [self setupMainView];
    [self.view addSubview:[self mainView]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_mainView removeFromSuperview];
    _mainView = nil;
}

- (void)viewDidLayoutSubviews {
    //    Called to notify the view controller that its view has just laid out its subviews.
    [super viewDidLayoutSubviews];
    CGFloat tabbarHeight = [[self.tabBarController tabBar] sd_height];
    CGFloat headerY = 0;
    headerY = ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) ? 64 : 0;
    _headerView.frame = CGRectMake(0, headerY, self.view.sd_width, kHomeHeaderViewHeight);
    
    _mainView.frame = CGRectMake(0, _headerView.sd_y + kHomeHeaderViewHeight, self.view.sd_width, self.view.sd_height - kHomeHeaderViewHeight - tabbarHeight);
}

#pragma mark - private actions
- (void)setupHeader
{
    UIView *header = [[UIView alloc] init];
    header.bounds = CGRectMake(0, 0, self.view.sd_width, kHomeHeaderViewHeight);
    header.backgroundColor = [UIColor colorWithRed:(38 / 255.0) green:(42 / 255.0) blue:(59 / 255.0) alpha:1];
    [self.view addSubview:header];
    _headerView = header;
    
    UIButton* addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, header.sd_width * 0.5, header.sd_height)];
    [addBtn setImage:[UIImage imageNamed:@"home_scan"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:addBtn];
    
    UIButton *commandBtn = [[UIButton alloc] initWithFrame:CGRectMake(addBtn.sd_width, 0, header.sd_width * 0.5, header.sd_height)];
    [commandBtn setImage:[UIImage imageNamed:@"home_pay"] forState:UIControlStateNormal];
    [commandBtn addTarget:self action:@selector(commandBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:commandBtn];
}

- (void)addBtnClicked {
    NSLog(@"add button clicked");
    
    //    needed code!!!!+++++++++++++++
    //    SDAddItemViewController *addVc = [[SDAddItemViewController alloc] init];
    //    addVc.title = @"添加设备";
    //    [self.navigationController pushViewController:addVc animated:YES];
    
    //test code
    AddItemViewController *addVc = [[AddItemViewController alloc] init];
    addVc.title = @"添加设备";
    [self.navigationController pushViewController:addVc animated:YES];
    
}

- (void)commandBtnClicked {
    NSLog(@"command button clicked");
}

-(SDHomeGridView*)mainView{
    if (!_mainView) {
        _mainView = [[SDHomeGridView alloc] init];
        _mainView.gridViewDelegate = self;
        _mainView.showsVerticalScrollIndicator = NO;
        
        [self setupDataArray];
        _mainView.gridModelsArray = _dataArray;
    }
    return _mainView;
}

- (void)setupDataArray {
    NSArray *itemsArray = [SDGridItemCacheTool itemsArray];
//    [SDGridItemCacheTool saveItemsArray:itemsArray[1]];
    NSMutableArray *temp = [NSMutableArray array];
    if (![itemsArray count]) {
        return;
    }
    
    for (NSData* aDevice in itemsArray) {
        DeviceInfo* deviceInfo = [NSKeyedUnarchiver unarchiveObjectWithData:aDevice];
        SDHomeGridItemModel *model = [[SDHomeGridItemModel alloc] init];
        model.destinationClass = [SDBasicViewContoller class];
        model.imageResString = deviceInfo.imageResString;
        model.title = deviceInfo.title;
        model.currentStat = deviceInfo.currentStat;
        model.colorStatPair = deviceInfo.colorStatPair;
        
        [temp addObject:model];
    
    }
    //    for (NSDictionary *itemDict in itemsArray) {
    //        SDHomeGridItemModel *model = [[SDHomeGridItemModel alloc] init];
    //        model.destinationClass = [SDBasicViewContoller class];
    //        model.imageResString =[itemDict.allValues firstObject];
    ////        model.imageColor = [itemDict.all]
    //        model.title = [itemDict.allKeys firstObject];
    //        [temp addObject:model];
    //    }
    
    //    for (NSArray* itemArr in itemsArray) {
    //        SDHomeGridItemModel *model = [[SDHomeGridItemModel alloc] init];
    //        model.destinationClass = [SDBasicViewContoller class];
    //        model.imageResString = itemArr[kImageResStringIndex];;
    //        model.currentStat = itemArr[kCurrentStatIndex];
    //        model.colorStatPair = itemArr[kColorStatPairIndex];
    //        [temp addObject:model];
    //    }
    
//    SDHomeGridItemModel *model = [[SDHomeGridItemModel alloc] init];
////    model.title = itemsArray[kTitleIndex];
//    model.destinationClass = [SDBasicViewContoller class];
//    model.imageResString = @"fa-github";
//    //            model.imageResString = itemsArray[kImageResStringIndex];;
//    model.currentStat = 0;
//    //            model.colorStatPair = itemsArray[kColorStatPairIndex];
//    [temp addObject:model];

    
    _dataArray = [temp copy];
    NSLog(@"_dataArray%lu",(unsigned long)_dataArray.count);
}

#pragma mark - SDHomeGridViewDelegate

- (void)homeGrideView:(SDHomeGridView *)gridView selectItemAtIndex:(NSInteger)index
{
    SDHomeGridItemModel *model = _dataArray[index];
    UIViewController *vc = [[model.destinationClass alloc] init];
    vc.title = model.title;
    //    vc.title = model.colorStatPair[model.currentStat][kTitleIndexInPair];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)homeGrideViewmoreItemButtonClicked:(SDHomeGridView *)gridView
{
    SDAddItemViewController *addVc = [[SDAddItemViewController alloc] init];
    addVc.title = @"添加设备到首页";
    [self.navigationController pushViewController:addVc animated:YES];
}

- (void)homeGrideViewDidChangeItems:(SDHomeGridView *)gridView
{
    NSLog(@"22222222");
    [self setupDataArray];
}


@end
