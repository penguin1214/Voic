//
//  AddItemView.m
//  GSD_ZHIFUBAO
//
//  Created by 杨京蕾 on 11/7/16.
//  Copyright © 2016 GSD. All rights reserved.
//

#import "AddItemView.h"
#import "SDGridItemCacheTool.h"

@interface AddItemView () {
    //device title
    UITextField *_vTitleText;
    UILabel *_vTitleGridUnderline;
    
    //device StatusNumMenu
    UITextField *_vStatusNumMenuText;
    UILabel *_vStatusNumMenuGridUnderline;
    
    //pickerview grid
    UILabel *_vIconPickerViewGridUnderline;
    
    //button grid
    UIButton *_vAddBtn;
}

@end

@implementation AddItemView

//@synthesize statusNumMenu;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor hexColor:@"ededed"];
    //    self.backgroundColor = kColorWhite;
    
    UIView* _vTitleGrid = [[UIView alloc] init];
    _vTitleGrid.backgroundColor = kColorWhite;
    
    UIView* _vStatusNumMenuGrid = [[UIView alloc] init];
    UIView* _vIconPickerGrid = [[UIView alloc] init];
    UIView* _vButtonGrid = [[UIView alloc] init];
    
    [self addSubview:_vTitleGrid];
    [self addSubview:_vStatusNumMenuGrid];
    [self addSubview:_vIconPickerGrid];
    [self addSubview:_vButtonGrid];
    
    [_vTitleGrid mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.top.equalTo(self).with.offset(10);
        make.height.mas_equalTo(45);
    }];
    
    [_vStatusNumMenuGrid mas_makeConstraints:^(MASConstraintMaker* make){
        //        make.right.equalTo(self);
        //        make.left.equalTo(self);
        make.left.equalTo(_vTitleGrid);
        make.right.equalTo(_vTitleGrid);
        make.top.equalTo(_vTitleGrid.mas_bottom).with.offset(1);
        make.height.equalTo(_vTitleGrid.mas_height);
    }];
    
    [_vIconPickerGrid mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vStatusNumMenuGrid);
        make.right.equalTo(_vStatusNumMenuGrid);
        make.top.equalTo(_vStatusNumMenuGrid.mas_bottom).with.offset(1);
        make.height.equalTo(_vStatusNumMenuGrid.mas_height);
    }];
    
    [_vButtonGrid mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vIconPickerGrid);
        make.right.equalTo(_vIconPickerGrid);
        make.top.equalTo(_vIconPickerGrid.mas_bottom);
        make.height.mas_equalTo(300);   //height 300
    }];
    
    _vTitleText = [[UITextField alloc] init];
    [_vTitleText setBackgroundColor:kColorWhite];
    _vTitleText.textAlignment = NSTextAlignmentCenter;
    _vTitleText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"设备名称" attributes:@{NSForegroundColorAttributeName: kColorGray}];

//    _vTitleText.placeholder = @"设备名称（将用于语音控制）";
    _vTitleText.keyboardType = UIKeyboardTypePhonePad;
    [_vTitleGrid addSubview:_vTitleText];
    [_vTitleText mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vTitleGrid);
        make.centerY.equalTo(_vTitleGrid);
        make.right.equalTo(_vTitleGrid);
    }];
    
    _vTitleGridUnderline = [[UILabel alloc] init];
    _vTitleGridUnderline.backgroundColor = kColorGray;
    [_vTitleGrid addSubview:_vTitleGridUnderline];
    [_vTitleGridUnderline mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vTitleGrid);
        make.right.equalTo(_vTitleGrid);
        make.top.equalTo(_vTitleGrid.mas_baseline);
        make.height.mas_equalTo(1);
    }];
    
    _statusNumMenu = [[MKDropdownMenu alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    _statusNumMenu.backgroundColor = kColorWhite;
    [_vStatusNumMenuGrid addSubview:_statusNumMenu];
    
    _vStatusNumMenuGridUnderline = [[UILabel alloc] init];
    _vStatusNumMenuGridUnderline.backgroundColor = kColorGray;
    [_vStatusNumMenuGrid addSubview:_vStatusNumMenuGridUnderline];
    [_vStatusNumMenuGridUnderline mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vStatusNumMenuGrid);
        make.right.equalTo(_vStatusNumMenuGrid);
        make.top.equalTo(_vStatusNumMenuGrid.mas_baseline);
        make.height.mas_equalTo(1);
    }];
    
    
    _iconPicker = [[AKPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    _iconPicker.backgroundColor = kColorWhite;
    _iconPicker.interitemSpacing = 20.0;
    _iconPicker.pickerViewStyle = AKPickerViewStyle3D;
    _iconPicker.fisheyeFactor = 0.003;
    _iconPicker.maskDisabled = false;
    [_iconPicker reloadData];
    
    [_vIconPickerGrid addSubview:_iconPicker];
    
    _vIconPickerViewGridUnderline = [[UILabel alloc] init];
    _vIconPickerViewGridUnderline.backgroundColor = kColorGray;
    [_vIconPickerGrid addSubview:_vIconPickerViewGridUnderline];
    [_vIconPickerViewGridUnderline mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vIconPickerGrid);
        make.right.equalTo(_vIconPickerGrid);
        make.top.equalTo(_vIconPickerGrid.mas_baseline);
        make.height.mas_equalTo(1);
    }];
    
    _vAddBtn = [[UIButton alloc] init];
    [_vAddBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_vAddBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [_vAddBtn setBackgroundColor:kColorMainGreen];
    [_vButtonGrid addSubview:_vAddBtn];
    [_vAddBtn mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vButtonGrid);
        make.right.equalTo(_vButtonGrid);
        make.top.equalTo(_vButtonGrid).with.offset(20);
    }];
    
    //  bind event to buttons
    [_vAddBtn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)clickAddBtn {
    //    将item添加到home
//    NSMutableArray *temp = [NSMutableArray new];
//    temp = [[SDGridItemCacheTool itemsArray] mutableCopy];
//    [temp addObject:@{_vTitleText.text : _vStatusNumMenuText.text}];
    /*
     检测重复
     */
    
    //    [SDGridItemCacheTool saveItemsArray:[temp copy]];
    [self.delegate didClickedAddBtnWithDeviceName:_vTitleText.text];
}

- (void)setPickerTitle:(NSString *)title {
    
}

- (NSString *)getDeviceName {
    return _vTitleText.text;
}

@end
