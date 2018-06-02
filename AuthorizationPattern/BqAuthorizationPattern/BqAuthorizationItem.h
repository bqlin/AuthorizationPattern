//
//  BqAuthorizationItem.h
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/5/11.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Xcode9 __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
#if Xcode9
/// 可用版本
#define BQ_AVAILABLE(v) @available(iOS v, *)
#else
/// 可用版本
#define BQ_AVAILABLE(v) ([UIDevice currentDevice].systemVersion.floatValue >= (v))
#endif

typedef NS_ENUM(NSInteger, BqAuthorizationStatus) {
	BqAuthorizationStatusUnknown = 0,
	BqAuthorizationStatusRestricted,
	BqAuthorizationStatusDenied,
	BqAuthorizationStatusAuthorized,
	BqAuthorizationStatusDisabled
};
NS_INLINE NSString *DescriptionForBqAuthorizationStatus(BqAuthorizationStatus status) {
	switch (status) {
		case BqAuthorizationStatusUnknown:{
			return @"Authorization Unknown";
		} break;
		case BqAuthorizationStatusRestricted:{
			return @"Authorization Restricted";
		} break;
		case BqAuthorizationStatusDenied:{
			return @"Authorization Denied";
		} break;
		case BqAuthorizationStatusAuthorized:{
			return @"Authorization Authorized";
		} break;
		case BqAuthorizationStatusDisabled:{
			return @"Authorization Disabled";
		} break;
	}
}

@class BqAuthorizationItem;
typedef void(^BqAuthorizationStatusBlock)(BqAuthorizationStatus status);
typedef void(^BqRequestAuthorizationStatusBlock)(BqAuthorizationStatusBlock statusHandler);
typedef void(^BqAuthorizationResultBlock)(BqAuthorizationItem *authorizationItem, BOOL authorized);

@interface BqAuthorizationItem : NSObject

/// 用于呈现 UIAlertViewController 的 UIViewController
@property (nonatomic, weak) UIViewController *viewControllerForAlert;

/// 权限名称
@property (nonatomic, copy) NSString *authorizationName;

/// Info.plist 中权限用途描述，如已在 Info.plist 中填写，则无需赋值，赋值也不会覆盖
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *authorizationUsageDescriptions;

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
