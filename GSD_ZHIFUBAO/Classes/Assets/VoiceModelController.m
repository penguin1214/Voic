//
//  VoiceModelController.m
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/5/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "VoiceModelController.h"
#import <iflyMSC/IFlyISVRecognizer.h>

@interface VoiceModelController () {
    NSArray* _titles;
}

@end

@implementation VoiceModelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _titles = [[NSArray alloc] initWithObjects:@"修改模型", @"删除模型", @"识别测试", nil];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20) style:UITableViewStylePlain];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(20,0,0,0)];
    
    // sets the background of the table to be transparent
    self.tableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    // assuming we are inside a navigation or tab controller, set the background
    self.parentViewController.view.backgroundColor = [UIColor hexColor:@"ededed"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 创建一个cellID，用于cell的重用
    NSString *cellID = @"cellID";
    // 从tableview的重用池里通过cellID取一个cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        // 如果tableview的重用池中没有取到，就创建一个新的cell，style为Value2，并用cellID对其进行标记。
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    // set an opaque background for the cells
    cell.contentView.backgroundColor = [UIColor whiteColor];
    // 设置 cell 的标题
    cell.textLabel.text = [NSString stringWithString:[_titles objectAtIndex:(long)indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //修改模型
        NSLog(@"修改模型");
    }else if (indexPath.section == 0 && indexPath.row == 1){
        //删除模型
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        
        NSString* notifyName = @"deleteModel";
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:notifyName, @"NotifyName", nil];
        
        [nc postNotificationName:@"VoiceModelController" object:self userInfo:dict];
    }else if (indexPath.section == 0 && indexPath.row == 2){
        //识别测试
    }
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
