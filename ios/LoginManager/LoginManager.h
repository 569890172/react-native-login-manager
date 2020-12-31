//
//  LoginManager.h
//  LoginManager
//
//  Created by 放心家 on 2020/12/22.
//  Copyright © 2020 放心家. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <React/RCTUtils.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTBridgeModule.h>

NS_ASSUME_NONNULL_BEGIN

//OC中定义一个枚举并导出
typedef NS_ENUM(NSInteger, MoveDiretion){
    MoveDiretionNone,
    MoveDiretionLeft,
    MoveDiretionRight,
    MoveDiretionBottom,
    MoveDiretionTop
};

@interface LoginManager : NSObject<RCTBridgeModule>

@end

NS_ASSUME_NONNULL_END
