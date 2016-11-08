//
//  AddItemView.h
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/7/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "BaseView.h"

@protocol AddItemViewDelegate <NSObject>

- (void)popViewController;

@end

@interface AddItemView : BaseView

@property (weak) id <AddItemViewDelegate> delegate;

@end
