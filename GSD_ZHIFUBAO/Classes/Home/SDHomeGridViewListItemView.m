//
//  SDHomeGridViewListItemView.m
//  GSD_ZHIFUBAO
//
//  Created by aier on 15-6-3.
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

#import "SDHomeGridViewListItemView.h"
#import "SDHomeGridItemModel.h"
#import "UIButton+WebCache.h"
#import "UIView+SDExtension.h"
#import "SDHomeGridViewListItemViewButton.h"

#define kTitleIndexInPair 0
#define kColorIndexInPair 1

@implementation SDHomeGridViewListItemView
{
    SDHomeGridViewListItemViewButton *_button;
    UIButton *_iconView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.colorArray = [NSArray arrayWithObjects:kColorDeviceRed, kColorDeviceYellow, kColorDeviceGreen, kColorMainGreen, nil];
    
    SDHomeGridViewListItemViewButton *button = [[SDHomeGridViewListItemViewButton alloc] init];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    _button = button;
    
    UIButton *icon = [[UIButton alloc] init];
    [icon setImage:[UIImage imageNamed:@"Home_delete_icon"] forState:UIControlStateNormal];
    [icon addTarget:self action:@selector(iconViewClicked) forControlEvents:UIControlEventTouchUpInside];
    icon.hidden = YES;
    [self addSubview:icon];
    _iconView = icon;
    
    UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(itemLongPressed:)];
    [self addGestureRecognizer:longPressed];
}

#pragma mark - actions

- (void)itemLongPressed:(UILongPressGestureRecognizer *)longPressed
{
    if (self.itemLongPressedOperationBlock) {
        self.itemLongPressedOperationBlock(longPressed);
    }
}

- (void)buttonClicked
{
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"您确定要删除该设备吗" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
//    
//            if (self.buttonClickedOperationBlock) {
//                self.buttonClickedOperationBlock(self);
//            }
//    
//        }];
//    
//        [alert addAction:defaultAction];
//        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
//    NSLog(@"delete button clicked");
    
    NSLog(@"button clicked");
    
}


- (void)iconViewClicked
{
    
    if (self.iconViewClickedOperationBlock) {
        self.iconViewClickedOperationBlock(self);
    }
}

#pragma mark - properties

- (void)setItemModel:(SDHomeGridItemModel *)itemModel
{
    _itemModel = itemModel;
    
//    NSString* t = [[NSString alloc] initWithFormat:@"%@[测试]", itemModel.title];
    NSString* st = [itemModel.colorStatPair objectForKey:itemModel.currentStat][kTitleIndexInPair];
        NSString* t = [[NSString alloc] initWithFormat:@"%@[%@]", itemModel.title, st];
    
    if (itemModel.title) {
        [_button setTitle:t forState:UIControlStateNormal];
    }
    
    _button.titleLabel.font = [UIFont systemFontOfSize:10];
    
    if (itemModel.imageResString) {
        if ([itemModel.imageResString hasPrefix:@"http:"]) {
            [_button setImageWithURL:[NSURL URLWithString:itemModel.imageResString] forState:UIControlStateNormal placeholderImage:nil];
        } else {
//            itemModel.currentStat = @(0);
            NSNumber* i = [itemModel.colorStatPair objectForKey:itemModel.currentStat][kColorIndexInPair];
            UIColor* col = [self.colorArray objectAtIndex:[i integerValue]];
            [_button setImage:[UIImage imageWithIcon:itemModel.imageResString backgroundColor:kColorWhite iconColor:[self.colorArray objectAtIndex:[[itemModel.colorStatPair objectForKey:itemModel.currentStat][kColorIndexInPair] integerValue]] fontSize:50] forState:UIControlStateNormal];
            
//            [_button setImage:[UIImage imageWithIcon:itemModel.imageResString backgroundColor:kColorWhite iconColor:[UIColor redColor] fontSize:50] forState:UIControlStateNormal];
            
            //                        [_button setImage:[UIImage imageWithIcon:@"fa-github" backgroundColor:kColorWhite iconColor:kColorMainGreen fontSize:50] forState:UIControlStateNormal];
        }
    }
}

- (void)setHidenIcon:(BOOL)hidenIcon
{
    _hidenIcon = hidenIcon;
    _iconView.hidden = hidenIcon;
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    
    [_iconView setImage:iconImage forState:UIControlStateNormal];
}

#pragma mark - life circles

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    _button.frame = self.bounds;
    _iconView.frame = CGRectMake(self.sd_width - _iconView.sd_width - margin, margin, 20, 20);
}

@end
