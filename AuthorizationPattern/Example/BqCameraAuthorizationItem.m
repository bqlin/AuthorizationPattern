//
//  BqCameraAuthorizationItem.m
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/6/2.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "BqCameraAuthorizationItem.h"
#import <AVFoundation/AVFoundation.h>

@implementation BqCameraAuthorizationItem

- (void)commonInit {
	self.authorizationName = @"相机";
	self.currentStatusHandler = ^(BqAuthorizationStatusBlock statusHandler) {
		AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
		statusHandler((BqAuthorizationStatus)status);
	};
	self.requestHandler = ^(BqAuthorizationStatusBlock statusHandler) {
		[AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
			BqAuthorizationStatus status = granted ? BqAuthorizationStatusAuthorized : BqAuthorizationStatusDenied;
			statusHandler(status);
		}];
	};
}

@end
