//
//  AddItemViewController.m
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/7/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "AddItemViewController.h"
#import "SDAddItemGridView.h"
#import "SDHomeGridItemModel.h"
#import "SDGridItemCacheTool.h"
#import "AddItemView.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface AddItemViewController ()

//@property (nonatomic, strong) SDAddItemGridView *mainView;
@property (nonatomic, strong) AddItemView *mainView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self mainView]];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMainView];
}

//- (void)setupDataArray
//{
//    NSArray *itemsArray = [SDGridItemCacheTool addItemsArray];
//    NSMutableArray *temp = [NSMutableArray array];
//    for (NSDictionary *itemDict in itemsArray) {
//        SDHomeGridItemModel *model = [[SDHomeGridItemModel alloc] init];
//        model.destinationClass = [SDBasicViewContoller class];
//        model.imageResString =[itemDict.allValues firstObject];
//        model.title = [itemDict.allKeys firstObject];
//        [temp addObject:model];
//    }
//    _dataArray = [temp copy];
//}

//-(SDAddItemGridView*)mainView{
//    if (!_mainView) {
//        _mainView = [[SDAddItemGridView alloc] initWithFrame:self.view.bounds];
//        _mainView.showsVerticalScrollIndicator = NO;
//    }
//    return _mainView;
//}

-(AddItemView*)mainView{
    if (!_mainView) {
        _mainView = [[AddItemView alloc] initWithFrame:self.view.bounds];
    }
    _mainView.delegate = self;
    return _mainView;
}

- (void)setupMainView
{
    //    SDAddItemGridView *mainView = [[SDAddItemGridView alloc] initWithFrame:self.view.bounds];
    //    mainView.showsVerticalScrollIndicator = NO;
    //    NSArray *titleArray = @[@"淘宝",
    //                            @"生活缴费",
    //                            @"教育缴费",
    //                            @"红包",
    //                            @"物流",
    //                            @"信用卡",
    //                            @"转账",
    //                            @"爱心捐款",
    //                            @"彩票",
    //                            @"当面付",
    //                            @"余额宝",
    //                            @"AA付款",
    //                            @"国际汇款",
    //                            @"淘点点",
    //                            @"淘宝电影",
    //                            @"亲密付",
    //                            @"股市行情",
    //                            @"汇率换算",
    //                            ];
    //
    //    NSMutableArray *temp = [NSMutableArray array];
    //    for (int i = 0; i < 18; i++) {
    //        SDHomeGridItemModel *model = [[SDHomeGridItemModel alloc] init];
    //        model.destinationClass = [SDBasicViewContoller class];
    //        model.imageResString = [NSString stringWithFormat:@"i%02d", i];
    //        model.title = titleArray[i];
    //        [temp addObject:model];
    //    }
    //
    //    _dataArray = [temp copy];
    
//    [self setupDataArray];
//    _mainView.gridModelsArray = [_dataArray copy];
    //    [self.view addSubview:mainView];
    //    _mainView = mainView;
    
//    +++++++++++++++++++
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    //    HUD.yOffset = 100.0f;
    //    HUD.xOffset = 100.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(seconds);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

#pragma mark - delegate

- (void)popViewController {
    [self toast:@"已添加"];
    [self performSelector:@selector(popUpController) withObject:nil afterDelay:2.0];
}

- (void)popUpController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
