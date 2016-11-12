//
//  SetDetailController.h
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/12/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "SMPagerTabView.h"
#import "SetDetailTableViewController.h"

@interface SetDetailController : BaseController <SMPagerTabViewDelegate>

- (void)setTabNumber:(NSInteger)tabNum;

@end
