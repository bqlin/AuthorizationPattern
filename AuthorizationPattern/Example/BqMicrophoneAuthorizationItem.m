//
//  BqMicrophoneAuthorizationItem.m
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/6/2.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "BqMicrophoneAuthorizationItem.h"
#import <AVFoundation/AVFoundation.h>

@implementation BqMicrophoneAuthorizationItem

- (void)commonInit {
	self.authorizationName = @"麦克风";
	self.currentStatusHandler = ^(BqAuthorizationStatusBlock statusHandler) {
		AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
		statusHandler((BqAuthorizationStatus)status);
	};
	self.requestHandler = ^(BqAuthorizationStatusBlock statusHandler) {
		[[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
			BqAuthorizationStatus status = granted ? BqAuthorizationStatusAuthorized : BqAuthorizationStatusDenied;
			statusHandler(status);
		}];
	};
}

@end
