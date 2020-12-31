//
//  LoginManager.m
//  LoginManager
//
//  Created by 放心家 on 2020/12/22.
//  Copyright © 2020 放心家. All rights reserved.
//

#import "LoginManager.h"

#ifdef DEBUG
#define NSLog(format, ...) printf("[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

@implementation LoginManager

//初始化, 添加屏幕旋转监听者
-(instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

//导出模块类
RCT_EXPORT_MODULE();


//重映射，auth为code方法的新名称
RCT_REMAP_METHOD(auth,code:(NSString *)account{
                      NSLog(@"%s---获取验证----",__func__);
                      NSLog(@"account----%@",account);
                  });

//login为方法名
RCT_EXPORT_METHOD(login:(NSString *)account password:(NSString *)password{
                      NSLog(@"%s---登录账号----",__func__);
                      NSLog(@"account----%@",account);
                      NSLog(@"password----%@",password);
                  });

//logout为方法名
RCT_EXPORT_METHOD(logout:(NSString *)account{
                      NSLog(@"%s---退出账号----",__func__);
                      NSLog(@"account----%@",account);
                  });

//设置普通的回调函数
//fetchUserInfoWithToken为方法名，successCallback为成功回调，failureCallback为失败回调
RCT_EXPORT_METHOD(fetchUserInfoWithToken:(NSString *)token success:(RCTResponseSenderBlock)successCallback failure:(RCTResponseErrorBlock)failureCallback
    {
            if(token.length>0 && successCallback){
                  successCallback(@[
                                    @"account = xiayuanquan",
                                    @"password = 123456",
                                    [NSString stringWithFormat:@"token = %@",token]
                                  ]);
            }
            else{
                  if(failureCallback){
                        failureCallback(
                                          [[NSError alloc] initWithDomain:NSOSStatusErrorDomain
                                                                     code:404
                                                                 userInfo: @{NSLocalizedDescriptionKey: @"token exception"}]
                                        );
                  }
            }
    });


//设置异步处理的回调函数
//sendMessage为方法名，successCallback为成功回调，failureCallback为失败回调
RCT_EXPORT_METHOD(sendMessage:(NSString *)message success:(RCTPromiseResolveBlock)successCallback failure:(RCTPromiseRejectBlock)failureCallback
    {
            if(message.length>0 && successCallback){
                  successCallback(@"发送成功!");
            }
            else{
                  if(failureCallback){
                      failureCallback(@"300",@"发送失败",nil);
                  }
            }
    });


//重写constantsToExport, 枚举常量导出
- (NSDictionary<NSString *, id> *)constantsToExport {
   return @{
        @"MoveDiretionNone": @(MoveDiretionNone),
        @"MoveDiretionLeft": @(MoveDiretionLeft),
        @"MoveDiretionRight": @(MoveDiretionRight),
        @"MoveDiretionBottom": @(MoveDiretionBottom),
        @"MoveDiretionTop": @(MoveDiretionTop)
   };
}

//定义一个移动方法，根据传入的枚举值移动
//move为方法名
RCT_EXPORT_METHOD(move:(MoveDiretion)moveDiretion{
                    switch(moveDiretion){
                        case MoveDiretionNone:
                             NSLog(@"仍保持原始位置 --- MoveDiretionNome");
                        break;
                        case MoveDiretionLeft:
                             NSLog(@"向左边移动位置 --- MoveDiretionLeft");
                        break;
                        case MoveDiretionRight:
                             NSLog(@"向右边移动位置 --- MoveDiretionRight");
                        break;
                        case MoveDiretionBottom:
                             NSLog(@"向下边移动位置 --- MoveDiretionBottom");
                        break;
                        case MoveDiretionTop:
                             NSLog(@"向上边移动位置 --- MoveDiretionTop");
                        break;
                    }
                 });


//可以重写队列，给当前模块类指定自定义的串行队列。若不指定，则系统默认会给当前模块类随机分配一个串行队列。
//这个方法一旦重写。当前模块的所有方法均会在该自定义的串行队列中异步执行
-(dispatch_queue_t)methodQueue{
    return dispatch_queue_create("com.facebook.ReactNative.LoginManagerQueue", DISPATCH_QUEUE_SERIAL);
}

//定义一个方法，获取线程和队列信息
//thread为方法名
RCT_EXPORT_METHOD(thread:(BOOL)newQueue{
                  
              const char *queueName = dispatch_queue_get_label([self methodQueue]);
              NSLog(@"当前线程1 ------- %@-----%s", [NSThread currentThread], queueName);
              
              if(newQueue){
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      const char *queueName2 = dispatch_queue_get_label(dispatch_get_main_queue());
                      NSLog(@"当前线程2 ------- %@ -------%s", [NSThread currentThread], queueName2);
                  });
          
                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                      const char *queueName3 = dispatch_queue_get_label(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
                      NSLog(@"当前线程3 ------- %@-------%s", [NSThread currentThread], queueName3);
                  });
              }
          });


//获取当前屏幕的尺寸
static NSDictionary *Dimensions(){
    CGFloat width = MIN(RCTScreenSize().width, RCTScreenSize().height);
    CGFloat height = MAX(RCTScreenSize().width, RCTScreenSize().height);
    CGFloat scale = RCTScreenScale();
    if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
        width = MAX(RCTScreenSize().width, RCTScreenSize().height);
        height = MIN(RCTScreenSize().width, RCTScreenSize().height);
    }
    return @{
        @"width": @(width),
        @"height": @(height),
        @"scale": @(scale)
    };
}
//定义一个方法，获取屏幕信息
//getDimensions为方法名
RCT_EXPORT_METHOD(getDimensions:(RCTResponseSenderBlock)callback{
    if (callback) {
        callback(@[[NSNull null], Dimensions()]);
    }
});

//监听方法，使用RCTEventDispatcher的eventDispatcher调用sendDeviceEventWithName函数发送事件信息
//可以将事件名称作为常量导出，提供给ReactNative中使用，也即添加到constantsToExport方法中的字典中即可。类似上面的枚举。
@synthesize bridge = _bridge;
-(void)orientationDidChange:(NSNotification *)notification {
  [_bridge.eventDispatcher sendDeviceEventWithName:@"orientationDidChange" body:@{
      @"orientation": UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"Landscape": @"Portrait",
      @"Dimensions": Dimensions()}
   ];
}

//移除监听者
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
