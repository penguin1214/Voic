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

@implementation SDFrameTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupChildControllers];
    
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
