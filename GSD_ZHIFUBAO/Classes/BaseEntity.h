//
//  BaseEntity.h
//  SCUxCHG
//
//  Created by 杨京蕾 on 5/13/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BaseEntity : JSONModel
/**
 * 根实体，所有实体都必须继承它
 *  自定义的对象必须用strong属性，如果用copy属性将会导致错误（WhichEntity copyWithZone:]: unrecognized selector sent to instance）
 */
@property (nonatomic, copy) NSNumber* id;   //long int

@end
