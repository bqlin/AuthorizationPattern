//
//  AuthorizationItem.h
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/5/11.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Xcode9 __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
#if Xcode9
#define UNIVERSAL_AVAILABLE(version) @available(iOS version, *)
#else
#define UNIVERSAL_AVAILABLE(version) ([UIDevice currentDevice].systemVersion.floatValue >= (version))
#endif

typedef NS_ENUM(NSInteger, AuthorizationStatus) {
	AuthorizationStatusUnknown = 0,
	AuthorizationStatusRestricted,
	AuthorizationStatusDenied,
	AuthorizationStatusAuthorized,
	AuthorizationStatusDisabled
};
NS_INLINE NSString *DescriptionForBqAuthorizationStatus(AuthorizationStatus status) {
	switch (status) {
		case AuthorizationStatusUnknown:{
			return @"Authorization Unknown";
		} break;
		case AuthorizationStatusRestricted:{
			return @"Authorization Restricted";
		} break;
		case AuthorizationStatusDenied:{
			return @"Authorization Denied";
		} break;
		case AuthorizationStatusAuthorized:{
			return @"Authorization Authorized";
		} break;
		case AuthorizationStatusDisabled:{
			return @"Authorization Disabled";
		} break;
	}
}

@class AuthorizationItem;
typedef void(^AuthorizationStatusBlock)(AuthorizationStatus status);
typedef void(^RequestAuthorizationStatusBlock)(AuthorizationStatusBlock statusHandler);
typedef void(^AuthorizationResultBlock)(AuthorizationItem *authorizationItem, BOOL authorized);

/**
 权限请求封装类
 */
@interface AuthorizationItem : NSObject

/// 用于呈现 UIAlertViewController 的 UIViewController
@property (nonatomic, weak) UIViewController *viewControllerForAlert;

/// 权限名称
@property (nonatomic, copy) NSString *authorizationName;

/// Info.plist 中权限用途描述，如已在 Info.plist 中填写，则无需赋值，赋值也不会覆盖（真机无效）
//@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *authorizationUsageDescriptions;

/// 异步获取权限当前状态操作
@property (nonatomic, copy) RequestAuthorizationStatusBlock currentStatusHandler;

/// 异步请求权限操作
@property (nonatomic, copy) RequestAuthorizationStatusBlock requestHandler;

/// 权限请求结果回调
@property (nonatomic, copy) AuthorizationResultBlock resultCallback;

/// 通用初始化
- (void)commonInit;

/// 请求权限
- (void)requestAuthorization;

@end

@interface AuthorizationItem (Convenience)

+ (instancetype)authorizationItemOnViewController:(UIViewController *)viewControllerForAlert requestNow:(BOOL)requestNow completion:(AuthorizationResultBlock)completion;

@end
