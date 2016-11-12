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
#import "SetDetailController.h"

@interface AddItemViewController ()

//@property (nonatomic, strong) SDAddItemGridView *mainView;
@property (nonatomic, strong) AddItemView *mainView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray* iconNameArray;
@property (nonatomic, strong) NSString* iconName;

@end

@interface AddItemViewController () {
    NSInteger _nStat;
}

@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.parentViewController.view setBackgroundColor:[UIColor hexColor:@"ededed"]];
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
    _mainView.statusNumMenu.delegate = self;
    _mainView.statusNumMenu.dataSource = self;
    _mainView.iconPicker.delegate = self;
    _mainView.iconPicker.dataSource = self;
    return _mainView;
}

- (void)setupMainView
{

    _iconNameArray = [[NSArray alloc] initWithObjects:@"fa-automobile",@"fa-bell", @"fa-camera", @"fa-clock-o", @"fa-cloud-download", @"fa-desktop", @"fa-lightbulb-o", nil];
    _nStat = -1;
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

- (void) didClickedAddBtnWithDeviceName:(NSString *)name{
    //    将item添加到home
    //    NSMutableArray *temp = [NSMutableArray new];
    //    temp = [[SDGridItemCacheTool itemsArray] mutableCopy];
    //    [temp addObject:@{name}];
    /*
     检测重复
     */
    
    //    [SDGridItemCacheTool saveItemsArray:[temp copy]];
    //    [self toast:@"已添加"];
    //    [self performSelector:@selector(popUpController) withObject:nil afterDelay:2.0];
    
    SetDetailController* setDetailController = [[SetDetailController alloc] init];
    [self.navigationController pushViewController:setDetailController animated:YES];
}

- (void)popUpController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MKDropdownMenu Delegate & Datasource

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component {
    if ((_nStat + 1)) {
        return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",((long)(_nStat + 1))]
                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18 weight:UIFontWeightRegular],
                                                            NSForegroundColorAttributeName: kColorGray}];
        
    }else{
        return [[NSAttributedString alloc] initWithString:@"请选择该设备的状态数"
                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18 weight:UIFontWeightRegular],
                                                            NSForegroundColorAttributeName: kColorGray}];
    }
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForSelectedComponent:(NSInteger)component {
    if ((_nStat + 1)) {
        return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld",((long)(_nStat + 1))]
                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightRegular],
                                                            NSForegroundColorAttributeName: self.view.tintColor}];
    }else{
        return [[NSAttributedString alloc] initWithString:@"请选择该设备的状态数"
                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightRegular],
                                                            NSForegroundColorAttributeName: self.view.tintColor}];
    }
    
}

-(NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray* titles = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", nil];
    NSAttributedString* title = [[NSAttributedString alloc] initWithString:titles[row] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20 weight:UIFontWeightLight],
                                                                                                    NSForegroundColorAttributeName: [UIColor grayColor]}];
    return title;
    
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _nStat = row;
        [dropdownMenu closeAllComponentsAnimated:YES];
        [dropdownMenu reloadComponent:component];
    }
}

#pragma mark - AKPickerView Delegate & Datasource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView {
    return [_iconNameArray count];
}

- (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item {
    UIImage* icon = [UIImage imageWithIcon:_iconNameArray[item] backgroundColor:kColorWhite iconColor:[UIColor grayColor] fontSize:20];
    return icon;
}

-(void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item {
    NSLog(@"selected icon: %@", _iconNameArray[item]);
    _iconName = _iconNameArray[item];
}

@end
