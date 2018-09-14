//
//  AuthorizationItem.m
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/5/11.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "AuthorizationItem.h"

@implementation AuthorizationItem

#pragma mark - init

- (instancetype)init {
	if (self = [super init]) {
		[self commonInit];
	}
	return self;
}

- (UIViewController *)viewControllerForAlert {
    if (!_viewControllerForAlert) {
        _viewControllerForAlert = [self topViewController];
    }
    return _viewControllerForAlert;
}

#pragma mark - public

- (void)commonInit {}

- (void)requestAuthorization {
	//[self checkInfoPlistCocoaKey];
	__weak typeof(self) weakSelf = self;
	[self requestAuthorization:self.requestHandler currentStatus:self.currentStatusHandler resultStatus:^(AuthorizationStatus status) {
		//NSLog(@"after request: %@", DescriptionForBqAuthorizationStatus(status));
        BOOL authorized = NO;
		switch (status) {
			case AuthorizationStatusAuthorized: {
                authorized = YES;
			} break;
            default: {
                authorized = NO;
            } break;
		}
        if (weakSelf.resultCallback) weakSelf.resultCallback(weakSelf, authorized);
	}];
}

//- (void)checkInfoPlistCocoaKey {
//	NSString *infoPlistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
//	NSMutableDictionary *infoDic = [[NSDictionary dictionaryWithContentsOfFile:infoPlistPath] mutableCopy];
//	for (NSString *key in self.authorizationUsageDescriptions.allKeys) {
//		if (!key.length) continue;
//		if (infoDic[key]) continue;
//		infoDic[key] = self.authorizationUsageDescriptions[key];
//	}
//	[infoDic writeToFile:infoPlistPath atomically:YES];
//}

- (void)showDeniedAlert {
    NSString *title = [NSString stringWithFormat:@"%@访问受限", self.authorizationName];
    NSString *message = [NSString stringWithFormat:@"请前往设置允许访问%@", self.authorizationName];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewControllerForAlert presentViewController:alert animated:YES completion:nil];
    });
}
- (void)showDisableAlert {
    NSString *title = [NSString stringWithFormat:@"%@未启用", self.authorizationName];
    NSString *message = [NSString stringWithFormat:@"请前往设置启用%@", self.authorizationName];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewControllerForAlert presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - private

- (UIViewController *)topViewController {
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *presentedViewController = topViewController.presentedViewController;
    while (presentedViewController) {
        presentedViewController = presentedViewController.presentedViewController;
        if (!presentedViewController) break;
        topViewController = presentedViewController;
    }
    
    if ([topViewController isKindOfClass:[UITabBarController class]]) {
        topViewController = [(UITabBarController *)topViewController selectedViewController];
    } else if ([topViewController isKindOfClass:[UINavigationController class]]) {
        topViewController = [(UINavigationController *)topViewController visibleViewController];
    }
    
    return topViewController;
}

- (void)requestAuthorization:(RequestAuthorizationStatusBlock)authorizationRequestHandler
               currentStatus:(RequestAuthorizationStatusBlock)currentStatusHandler
                resultStatus:(AuthorizationStatusBlock)statusCallback {
    if (currentStatusHandler) currentStatusHandler(^(AuthorizationStatus status) {
        //NSLog(@"current: %@", DescriptionForBqAuthorizationStatus(status));
        switch (status) {
            case AuthorizationStatusUnknown: {
                if (authorizationRequestHandler) authorizationRequestHandler(^(AuthorizationStatus status) {
                    if (statusCallback) statusCallback(status);
                });
            } break;
            case AuthorizationStatusRestricted:
            case AuthorizationStatusDenied: {
                [self showDeniedAlert];
                if (self.resultCallback) self.resultCallback(self, NO);
            } break;
            case AuthorizationStatusDisabled: {
                [self showDisableAlert];
                if (self.resultCallback) self.resultCallback(self, NO);
            } break;
            case AuthorizationStatusAuthorized: {
                if (statusCallback) statusCallback(status);
            } break;
        }
    });
}

@end

@implementation AuthorizationItem (Convenience)

+ (instancetype)authorizationItemOnViewController:(UIViewController *)viewControllerForAlert requestNow:(BOOL)requestNow completion:(AuthorizationResultBlock)completion {
    AuthorizationItem *authorization = [[self alloc] init];
    authorization.viewControllerForAlert = viewControllerForAlert;
    authorization.resultCallback = completion;
    if (requestNow) [authorization requestAuthorization];
    return authorization;
}

@end
