//
//  MicrophoneAuthorizationItem.m
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/6/2.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "MicrophoneAuthorizationItem.h"
#import <AVFoundation/AVFoundation.h>

@implementation MicrophoneAuthorizationItem

- (void)commonInit {
	self.authorizationName = @"麦克风";
	self.currentStatusHandler = ^(AuthorizationStatusBlock statusHandler) {
		AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
		statusHandler((AuthorizationStatus)status);
	};
	self.requestHandler = ^(AuthorizationStatusBlock statusHandler) {
		[[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
			AuthorizationStatus status = granted ? AuthorizationStatusAuthorized : AuthorizationStatusDenied;
			statusHandler(status);
		}];
	};
}

@end
