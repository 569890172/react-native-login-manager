//
//  RCTConvert+MoveDiretion.m
//  LoginManager
//
//  Created by 放心家 on 2020/12/22.
//  Copyright © 2020 放心家. All rights reserved.
//

#import "RCTConvert+MoveDiretion.h"
#import "LoginManager.h"

@implementation RCTConvert (MoveDiretion)

//给RCTConvert类添加扩展，这样在模块方法调用中使用常量导出的枚举值，通信到Native中时，会从整型自动转换为定义的枚举类型
RCT_ENUM_CONVERTER(MoveDiretion,(@{
   @"MoveDiretionNone": @(MoveDiretionNone),
   @"MoveDiretionLeft": @(MoveDiretionLeft),
   @"MoveDiretionRight": @(MoveDiretionRight),
   @"MoveDiretionBottom": @(MoveDiretionBottom),
   @"MoveDiretionTop": @(MoveDiretionTop),
}), MoveDiretionNone, integerValue)

@end
