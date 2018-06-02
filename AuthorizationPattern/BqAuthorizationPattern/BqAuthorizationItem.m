//
//  BqAuthorizationItem.m
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/5/11.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "BqAuthorizationItem.h"

@implementation BqAuthorizationItem

+ (void)requestAuthorization:(BqRequestAuthorizationStatusBlock)authorizationRequestHandler
			   currentStatus:(BqRequestAuthorizationStatusBlock)currentStatusHandler
				resultStatus:(BqAuthorizationStatusBlock)statusCallback {
	if (currentStatusHandler) currentStatusHandler(^(BqAuthorizationStatus status) {
		//NSLog(@"current: %@", DescriptionForBqAuthorizationStatus(status));
		switch (status) {
			case BqAuthorizationStatusUnknown:{
				if (authorizationRequestHandler) authorizationRequestHandler(^(BqAuthorizationStatus status) {
					if (statusCallback) statusCallback(status);
				});
			} break;
			case BqAuthorizationStatusRestricted:
			case BqAuthorizationStatusDenied:
			case BqAuthorizationStatusDisabled:
			case BqAuthorizationStatusAuthorized: {
				if (statusCallback) statusCallback(status);
			} break;
		}
	});
}

- (instancetype)init {
	if (self = [super init]) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {}

- (void)requestAuthorization {
	//[self checkInfoPlistCocoaKey];
	__weak typeof(self) weakSelf = self;
	[self.class requestAuthorization:self.requestHandler currentStatus:self.currentStatusHandler resultStatus:^(BqAuthorizationStatus status) {
		//NSLog(@"after request: %@", DescriptionForBqAuthorizationStatus(status));
		switch (status) {
			case BqAuthorizationStatusUnknown: {} break;
			case BqAuthorizationStatusRestricted:
			case BqAuthorizationStatusDenied: {
				[weakSelf showDeniedAlert];
				if (weakSelf.resultCallback) weakSelf.resultCallback(weakSelf, NO);
			} break;
			case BqAuthorizationStatusDisabled: {
				[weakSelf showDisableAlert];
				if (weakSelf.resultCallback) weakSelf.resultCallback(weakSelf, NO);
			} break;
			case BqAuthorizationStatusAuthorized: {
				if (weakSelf.resultCallback) weakSelf.resultCallback(weakSelf, YES);
			} break;
		}
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

@end
