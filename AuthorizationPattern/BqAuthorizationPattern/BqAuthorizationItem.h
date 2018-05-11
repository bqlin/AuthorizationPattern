//
//  BqAuthorizationItem.h
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/5/11.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BqAuthorizationStatus) {
	BqAuthorizationStatusUnknown = 0,
	BqAuthorizationStatusRestricted,
	BqAuthorizationStatusDenied,
	BqAuthorizationStatusAuthorized,
	BqAuthorizationStatusDisabled
};
typedef void(^BqAuthorizationStatusBlock)(BqAuthorizationStatus status);
typedef void(^BqRequestAuthorizationStatusBlock)(BqAuthorizationStatusBlock statusHandler);
typedef void(^BqAuthorizationResultBlock)(BOOL authorized);

@interface BqAuthorizationItem : NSObject

/// 用于呈现 UIAlertViewController 的 UIViewController
@property (nonatomic, weak) UIViewController *viewControllerForAlert;

/// 权限名称
@property (nonatomic, copy) NSString *authorizationName;

/// 异步获取权限当前状态操作
@property (nonatomic, copy) BqRequestAuthorizationStatusBlock currentStatusHandler;

/// 异步请求权限操作
@property (nonatomic, copy) BqRequestAuthorizationStatusBlock requestHandler;

/// 权限请求结果回调
@property (nonatomic, copy) BqAuthorizationResultBlock resultCallback;

/// 通用初始化
- (void)commonInit;

/// 请求权限
- (void)requestAuthorization;

/// 请求权限工具方法
+ (void)requestAuthorization:(BqRequestAuthorizationStatusBlock)authorizationRequestHandler
			   currentStatus:(BqRequestAuthorizationStatusBlock)currentStatusHandler
				resultStatus:(BqAuthorizationStatusBlock)statusCallback;

@end
