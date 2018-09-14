//
//  CameraAuthorizationItem.m
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/6/2.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "CameraAuthorizationItem.h"
#import <AVFoundation/AVFoundation.h>

@implementation CameraAuthorizationItem

- (void)commonInit {
	self.authorizationName = @"相机";
	self.currentStatusHandler = ^(AuthorizationStatusBlock statusHandler) {
		AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
		statusHandler((AuthorizationStatus)status);
	};
	self.requestHandler = ^(AuthorizationStatusBlock statusHandler) {
		[AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
			AuthorizationStatus status = granted ? AuthorizationStatusAuthorized : AuthorizationStatusDenied;
			statusHandler(status);
		}];
	};
}

@end
