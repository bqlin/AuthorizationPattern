//
//  BqPhotoAuthorizationItem.m
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/5/11.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "BqPhotoAuthorizationItem.h"
#import <Photos/Photos.h>

@implementation BqPhotoAuthorizationItem

- (void)commonInit {
	self.authorizationName = @"相册";
	self.currentStatusHandler = ^(BqAuthorizationStatusBlock statusHandler) {
		PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
		statusHandler((BqAuthorizationStatus)status);
	};
	self.requestHandler = ^(BqAuthorizationStatusBlock statusHandler) {
		[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
			statusHandler((BqAuthorizationStatus)status);
		}];
	};
}

@end
