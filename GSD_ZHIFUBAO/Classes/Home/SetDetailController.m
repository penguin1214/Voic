//
//  SetDetailController.m
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/12/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "SetDetailController.h"
#import "UIViewAdditions.h"
//#import "UITableViewController.h"

@interface SetDetailController ()
@property (nonatomic, strong) NSMutableArray *allVC;
@property (nonatomic, strong) SMPagerTabView *segmentView;
@end

@implementation SetDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _allVC = [NSMutableArray array];
    UITableViewController *one = [[UITableViewController alloc]initWithNibName:nil bundle:nil];
    one.title = @"我的";
//    one.webUrlString = @"https://github.com/ming1016";
    [_allVC addObject:one];
    
    UITableViewController *two = [[UITableViewController alloc]initWithNibName:nil bundle:nil];
    two.title = @"已阅";
//    two.webUrlString = @"https://github.com/ming1016/RSSRead";
    [_allVC addObject:two];
    
    UITableViewController *three = [[UITableViewController alloc]initWithNibName:nil bundle:nil];
    three.title = @"文章";
//    three.webUrlString = @"https://github.com/ming1016/study";
    [_allVC addObject:three];
    
    self.segmentView.delegate = self;
    //可自定义背景色和tab button的文字颜色等
    //开始构建UI
    [_segmentView buildUI];
    //起始选择一个tab
    [_segmentView selectTabWithIndex:1 animate:NO];
    //显示红点，点击消失
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
        self.segmentView = [[SMPagerTabView alloc]initWithFrame:CGRectMake(0, 22, self.view.width, self.view.height - 22)];
        [self.view addSubview:_segmentView];
    }
    return _segmentView;
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