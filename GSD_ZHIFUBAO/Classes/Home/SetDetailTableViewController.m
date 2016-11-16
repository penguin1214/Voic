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
#import "MKDropdownMenu.h"

#define kCellIdentifier @"cell"

@interface SetDetailTableViewController ()

//@property (nonatomic, strong) HRColorPickerView* colorPickerView;
//@property (nonatomic, strong) NKOColorPickerView* colorPickerView;
@property (nonatomic, strong) NSString* statName;
@property (nonatomic, strong) UITextField* statusTextField;
@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) NSNumber* statColor;
@property (nonatomic, strong) NSNumber* pushable;

@property (nonatomic, strong) MKDropdownMenu* colorPicker;
@property (nonatomic, strong) NSArray* colorArray;

@end

@interface SetDetailTableViewController () {
    NSString* _deviceName;
    NSInteger _nStat;
}

@end

@implementation SetDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.pushable = @(0);
    self.colorArray = @[@"红色", @"黄色", @"绿色", @"蓝色"];
    //        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    //        [nc addObserver:self selector:@selector(recvNotif:) name:@"Check" object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.statusTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
    self.statusTextField.adjustsFontSizeToFitWidth = YES;
    _statusTextField.textColor = [UIColor blackColor];
    _statusTextField.placeholder = @"将显示在首页";
    //                _statusTextField.keyboardType = UIKeyboardTypeEmailAddress;
    //                _statusTextField.returnKeyType = UIReturnKeyNext;
    
    _statusTextField.backgroundColor = [UIColor whiteColor];
    _statusTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    _statusTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
    _statusTextField.textAlignment = NSTextAlignmentLeft;
    _statusTextField.tag = 0;
    //statusTextField.delegate = self;
    
    _statusTextField.clearButtonMode = UITextFieldViewModeAlways; // no clear 'x' button to the right
    [_statusTextField setEnabled: YES];
    [self.view addSubview:_statusTextField];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)collectDetail {
    
    NSArray* statColorArray = [NSArray arrayWithObjects:self.statName, self.statColor,self.pushable, nil];
    return statColorArray;
}

- (NSInteger)check {
    self.statName = _statusTextField.text;
    if (_statusTextField.text && self.statColor) {
        return 1;
    }else {
        return 0;
    }
}
//- (void)recvNotif:(NSNotification*)notify {
//    //Collect details
//    NSDictionary* info = [notify userInfo];
//    _deviceName = [info objectForKey:@"deviceName"];
//    _nStat = [[info objectForKey:@"nStat"] integerValue];
//    NSDictionary* statColorPair = [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:self.statName, self.statColor,self.pushable, nil] forKey: _tag];
//
//};

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
        
        if ([indexPath section] == 0) {
            if ([indexPath row] == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else {
#warning color picker not set
                _colorPicker = [[MKDropdownMenu alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
                _colorPicker.dataSource = self;
                _colorPicker.delegate = self;
                _colorPicker.backgroundColor = kColorWhite;
                [cell addSubview:_colorPicker];
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
            cell.textLabel.text = @"状态名称";
        }
        else {
            //            cell.textLabel.text = @"状态颜色";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        if ([indexPath row] == 1) {
            
        }
    }
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    self.pushable = switchControl.on ? @(1):@(0);
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return 4;
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component {
    if (self.statColor) {
        return [[NSAttributedString alloc] initWithString:[self.colorArray objectAtIndex:[self.statColor integerValue]]
                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18 weight:UIFontWeightRegular],
                                                            NSForegroundColorAttributeName: [UIColor blackColor]}];
    }else {
    return [[NSAttributedString alloc] initWithString:@"请选择状态颜色"
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18 weight:UIFontWeightRegular],
                                                        NSForegroundColorAttributeName: [UIColor blackColor]}];
    }
}

-(NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //    NSArray* titles = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", nil];
    
    NSAttributedString* title = [[NSAttributedString alloc] initWithString:self.colorArray[row] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20 weight:UIFontWeightLight],
                                                                                                             NSForegroundColorAttributeName: [UIColor grayColor]}];
    return title;
    
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.statColor = @(row);
    [dropdownMenu closeAllComponentsAnimated:YES];
    [dropdownMenu reloadComponent:0];
}

//- (void)didChangeColor:(UIColor*)color {
//    self.statColor = color;
//    NSLog(@"change");
//}

//- (void)finishSelectColor {
//    [self.button removeFromSuperview];
//    [self.colorPickerView removeFromSuperview];
//    NSLog(@"removed");
//}
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
