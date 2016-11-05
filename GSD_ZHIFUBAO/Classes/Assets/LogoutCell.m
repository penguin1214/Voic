//
//  LogoutCell.m
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/5/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "LogoutCell.h"
#import "ProfileManager.h"

@implementation LogoutCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    LogoutCell* logoutCell = [[[NSBundle mainBundle] loadNibNamed:@"LogoutCell" owner:self options:nil] lastObject];
    if (frame.size.width != 0) {
        logoutCell.frame = frame;
    }
    return logoutCell;
}

- (IBAction)logoutBtnClicked:(id)sender {
    NSLog(@"logout.");
    [[ProfileManager sharedInstance] logOut];
    [self.delegate reloadView];
}

@end
