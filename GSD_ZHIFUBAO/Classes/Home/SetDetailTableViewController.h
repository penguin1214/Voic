//
//  SetDetailTableViewController.h
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/12/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetDetailView.h"
#import "MKDropdownMenu.h"

@protocol SetDetailTableViewControllerDelegate <NSObject>

- (void)popUpColorPicker;

@end

@interface SetDetailTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, MKDropdownMenuDelegate, MKDropdownMenuDataSource>

@property NSNumber* tag;

@property (weak) id<SetDetailTableViewControllerDelegate> delegate;

- (NSArray*)collectDetail;
- (NSInteger)check;

@end
