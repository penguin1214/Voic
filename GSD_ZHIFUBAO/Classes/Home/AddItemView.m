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
    
    //device imageStr
    UITextField *_vImageStrText;
    UILabel *_vImageStrGridUnderline;
    
    //button grid
    UIButton *_vAddBtn;
}

@end

@implementation AddItemView

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
    
    self.backgroundColor = kColorWhite;
    
    UIView* _vTitleGrid = [[UIView alloc] init];
    UIView* _vImageStrGrid = [[UIView alloc] init];
    UIView* _vButtonGrid = [[UIView alloc] init];
    
    [self addSubview:_vTitleGrid];
    [self addSubview:_vImageStrGrid];
    [self addSubview:_vButtonGrid];
    
    [_vTitleGrid mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(self).with.offset(8);
        make.right.equalTo(self).with.offset(-8);
        make.top.equalTo(self).with.offset(8);
        make.height.mas_equalTo(45);
    }];
    
    [_vImageStrGrid mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vTitleGrid);
        make.right.equalTo(_vTitleGrid);
        make.top.equalTo(_vTitleGrid.mas_bottom);
        make.height.equalTo(_vTitleGrid.mas_height);
    }];
    
    [_vButtonGrid mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vTitleGrid);
        make.right.equalTo(_vTitleGrid);
        make.top.equalTo(_vImageStrGrid.mas_bottom);
        make.height.mas_equalTo(300);   //height 300
    }];
    
    _vTitleText = [[UITextField alloc] init];
    _vTitleText.placeholder = @"手机号";
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
    
    _vImageStrText = [[UITextField alloc] init];
    _vImageStrText.placeholder = @"密码";
    _vImageStrText.keyboardType = UIKeyboardTypeAlphabet;
    _vImageStrText.secureTextEntry = YES;
    [_vImageStrGrid addSubview:_vImageStrText];
    [_vImageStrText mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vImageStrGrid);
        make.centerY.equalTo(_vImageStrGrid);
        make.right.equalTo(_vTitleGrid);
    }];
    
    _vImageStrGridUnderline = [[UILabel alloc] init];
    _vImageStrGridUnderline.backgroundColor = kColorGray;
    [_vImageStrGrid addSubview:_vImageStrGridUnderline];
    [_vImageStrGridUnderline mas_makeConstraints:^(MASConstraintMaker* make){
        make.left.equalTo(_vImageStrGrid);
        make.right.equalTo(_vImageStrGrid);
        make.top.equalTo(_vImageStrGrid.mas_baseline);
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
    NSMutableArray *temp = [NSMutableArray new];
    temp = [[SDGridItemCacheTool itemsArray] mutableCopy];
    [temp addObject:@{_vTitleText.text : _vImageStrText.text}];
//    i12
/*
 检测重复
 */
    [SDGridItemCacheTool saveItemsArray:[temp copy]];
}

@end
