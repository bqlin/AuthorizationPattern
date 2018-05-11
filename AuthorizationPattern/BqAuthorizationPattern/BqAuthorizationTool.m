//
//  BqAuthorizationTool.m
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/5/11.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "BqAuthorizationTool.h"

@implementation BqAuthorizationTool

+ (void)requestAuthorization:(void (^)(BqAuthorizationStatusBlock statusHandler))authorizationRequestHandler
			   currentStatus:(void (^)(BqAuthorizationStatusBlock statusHandler))currentStatusHandler
		 authorizationResult:(BqAuthorizationStatusBlock)resultCallback {
	if (currentStatusHandler) currentStatusHandler(^(BqAuthorizationStatus status) {
		switch (status) {
			case BqAuthorizationStatusUnknown:{
				if (authorizationRequestHandler) authorizationRequestHandler(^(BqAuthorizationStatus status) {
					if (resultCallback) resultCallback(status);
				});
			} break;
			case BqAuthorizationStatusRestricted:
			case BqAuthorizationStatusDenied:{
				[self showDeniedAlert];
			} break;
			case BqAuthorizationStatusDisabled:{
				[self showDisableAlert];
			} break;
			case BqAuthorizationStatusAuthorized:{
				if (resultCallback) resultCallback(status);
			} break;
		}
	});
}

+ (void)showDisableAlert {
	
}
+ (void)showDeniedAlert {
	
}

@end
