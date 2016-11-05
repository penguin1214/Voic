//
//  LogoutCell.h
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/5/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LogoutCellDelegate <NSObject>

- (void)reloadView;

@end

@interface LogoutCell : UIView

@property (weak, nonatomic) IBOutlet UIButton* logoutBtn;

@property (weak) id <LogoutCellDelegate> delegate;

@end
