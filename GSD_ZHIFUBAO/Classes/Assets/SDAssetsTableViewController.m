//
//  SDAssetsTableViewController.m
//  GSD_ZHIFUBAO
//
//  Created by aier on 15-6-4.
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

#import "SDAssetsTableViewController.h"
#import "SDAssetsTableViewControllerCell.h"
#import "SDAssetsTableViewControllerCellModel.h"
#import "SDAssetsTableViewHeader.h"
#import "LogoutCell.h"
#import "SDYuEBaoTableViewController.h"
#import "LogginController.h"
#import "ProfileManager.h"

@implementation SDAssetsTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];

    if ([[ProfileManager sharedInstance] checkLogin]) {
//        [self toast:@"logged in"];
    }else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please log in" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"log in" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            
            LogginController* loginController = [[LogginController alloc] init];
            loginController.hidesBottomBarWhenPushed = NO;
            loginController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismissLoginView)];
            
            UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:loginController];
            navController.hidesBottomBarWhenPushed = NO;
            
            loginController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismissLoginView)];
            
            [self presentViewController:navController animated:YES completion:nil];
            
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sectionsNumber = 2;
    self.cellClass = [SDAssetsTableViewControllerCell class];
    
    [self setupModel];
    [self setUpHeader];
    [self setUpFooter];
    
//    SDAssetsTableViewHeader *header = [[SDAssetsTableViewHeader alloc] init];
//    header.iconView.image = [UIImage imageNamed:@"tmall_icon"];
//    self.tableView.tableHeaderView = header;
    NSLog(@"view loaded");
}

- (void)setUpHeader{
    SDAssetsTableViewHeader *header = [[SDAssetsTableViewHeader alloc] init];
    header.iconView.image = [UIImage imageNamed:@"tmall_icon"];
    self.tableView.tableHeaderView = header;
}

- (void)setUpFooter{
    LogoutCell* footer = [[LogoutCell alloc] init];
    footer.delegate = self;
    self.tableView.tableFooterView = footer;
}

- (void)setupModel
{
    // section 0 的model
    SDAssetsTableViewControllerCellModel *model01 = [SDAssetsTableViewControllerCellModel modelWithTitle:@"声纹模型" iconImageName:@"20000032Icon" destinationControllerClass:[SDYuEBaoTableViewController class]];

    SDAssetsTableViewControllerCellModel *model02 = [SDAssetsTableViewControllerCellModel modelWithTitle:@"指纹" iconImageName:@"20000059Icon" destinationControllerClass:[SDBasicTableViewController class]];
    
    // section 1 的model
    SDAssetsTableViewControllerCellModel *model11 = [SDAssetsTableViewControllerCellModel modelWithTitle:@"个人设置" iconImageName:@"20000118Icon" destinationControllerClass:[SDBasicTableViewController class]];
    
    SDAssetsTableViewControllerCellModel *model12 = [SDAssetsTableViewControllerCellModel modelWithTitle:@"安全设置" iconImageName:@"20000180Icon" destinationControllerClass:[SDBasicTableViewController class]];
    
    self.dataArray = @[@[model01, model02],
                       @[model11, model12]];
}

#pragma mark - delegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDAssetsTableViewControllerCellModel *model = [self.dataArray[indexPath.section] objectAtIndex:indexPath.row];
    UIViewController *vc = [[model.destinationControllerClass alloc] init];
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (section == self.dataArray.count - 1) ? 10 : 0;
}

- (void)dismissLoginView {
    NSLog(@"dissmiss");
}

- (void)reloadView {
    [self viewWillAppear:YES];
}
@end
