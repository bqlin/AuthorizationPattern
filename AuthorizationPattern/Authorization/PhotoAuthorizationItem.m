//
//  PhotoAuthorizationItem.m
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/5/11.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "PhotoAuthorizationItem.h"
#import <Photos/Photos.h>

@implementation PhotoAuthorizationItem

- (void)commonInit {
	self.authorizationName = @"相册";
	self.currentStatusHandler = ^(AuthorizationStatusBlock statusHandler) {
		PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
		statusHandler((AuthorizationStatus)status);
	};
	self.requestHandler = ^(AuthorizationStatusBlock statusHandler) {
		[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
			statusHandler((AuthorizationStatus)status);
		}];
	};
}

@end
