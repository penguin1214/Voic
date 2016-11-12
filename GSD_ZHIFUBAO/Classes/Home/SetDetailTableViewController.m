//
//  SetDetailTableViewController.m
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/12/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "SetDetailTableViewController.h"
#import "NKOColorPickerView.h"
#import "HRColorPickerView.h"

#define kCellIdentifier @"cell"

@interface SetDetailTableViewController ()

//@property (nonatomic, strong) HRColorPickerView* colorPickerView;
@property (nonatomic, strong) NKOColorPickerView* colorPickerView;
@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) UIColor* color;

@end

@implementation SetDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return 1;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([indexPath section] == 0) {
            UITextField *statusTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            statusTextField.adjustsFontSizeToFitWidth = YES;
            statusTextField.textColor = [UIColor blackColor];
            if ([indexPath row] == 0) {
                statusTextField.placeholder = @"将显示在首页";
                statusTextField.keyboardType = UIKeyboardTypeEmailAddress;
                statusTextField.returnKeyType = UIReturnKeyNext;
                
                statusTextField.backgroundColor = [UIColor whiteColor];
                statusTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
                statusTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
                statusTextField.textAlignment = NSTextAlignmentLeft;
                statusTextField.tag = 0;
                //statusTextField.delegate = self;
                
                statusTextField.clearButtonMode = UITextFieldViewModeAlways; // no clear 'x' button to the right
                [statusTextField setEnabled: YES];
                
                [cell.contentView addSubview:statusTextField];

            }
            else {
            }
        }else {
            cell.textLabel.text = @"是否推送状态";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchView;
            [switchView setOn:NO animated:NO];
            [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
    }
    if ([indexPath section] == 0) { // Email & Password Section
        if ([indexPath row] == 0) { // Email
            cell.textLabel.text = @"设备名称";
        }
        else {
            cell.textLabel.text = @"状态颜色";
        }
    }
    
    return cell;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        if ([indexPath row] == 1) {
//            
//            __weak typeof(self) weakSelf = self;
//            id colorDidChangeBlock = ^(UIColor *color){
//                typeof(self) strongSelf = weakSelf;
//                strongSelf.color = color;
//                NSLog(@"change");
//            };
//            
//            self.colorPickerView = [[NKOColorPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 340) color:[UIColor blueColor] andDidChangeColorBlock:colorDidChangeBlock];
//            
//            self.button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [self.button addTarget:self action:@selector(finishSelectColor) forControlEvents:UIControlEventTouchUpInside];
//            [self.button setTitle:@"" forState:UIControlStateNormal];
//            self.button.frame = self.view.frame;
//            [self.view addSubview:self.button];
//            
//            [self.view addSubview:self.colorPickerView];
//            
//            ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//            UIViewController* vc = [[UIViewController alloc] init];
//            self.colorPickerView = [[HRColorPickerView alloc] init];
//            self.colorPickerView.color = [UIColor redColor];
//            [self.colorPickerView addTarget:self
//                                action:@selector(didChangeColor:)
//                      forControlEvents:UIControlEventValueChanged];
//            [vc.view addSubview:self.colorPickerView];
//            
//            [self.navigationController pushViewController:vc animated:YES];
//                        self.colorPickerView = [[HRColorPickerView alloc] init];
//                        self.colorPickerView.color = [UIColor redColor];
//                        [self.colorPickerView addTarget:self
//                                            action:@selector(didChangeColor:)
//                                  forControlEvents:UIControlEventValueChanged];
//                        [self.view addSubview:self.colorPickerView];
            
            self.color = [UIColor redColor];

        }
    }
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}

- (void)didChangeColor:(UIColor*)color {
    self.color = color;
    NSLog(@"change");
}

- (void)finishSelectColor {
    [self.button removeFromSuperview];
    [self.colorPickerView removeFromSuperview];
    NSLog(@"removed");
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
