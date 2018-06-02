//
//  BqLocationAuthorizationItem.m
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/5/30.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "BqLocationAuthorizationItem.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^BqLocationAuthorizationChangeBlock)(CLAuthorizationStatus locationStatus);

@interface BqLocationAuthorizationItem ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) BqLocationAuthorizationChangeBlock locationAuthorizationChangeHandler;

@end

@implementation BqLocationAuthorizationItem

- (void)commonInit {
	self.authorizationName = @"定位服务";
	self.currentStatusHandler = ^(BqAuthorizationStatusBlock statusHandler) {
		BqAuthorizationStatus status = BqAuthorizationStatusUnknown;
		if (![CLLocationManager locationServicesEnabled]) {
			status = BqAuthorizationStatusDisabled;
			return;
		}
		CLAuthorizationStatus locationStatus = [CLLocationManager authorizationStatus];
		switch (locationStatus) {
			case kCLAuthorizationStatusAuthorizedAlways:
			case kCLAuthorizationStatusAuthorizedWhenInUse:{
				status = BqAuthorizationStatusAuthorized;
			} break;
			case kCLAuthorizationStatusDenied:{
				status = BqAuthorizationStatusDenied;
			} break;
			case kCLAuthorizationStatusRestricted:{
				status = BqAuthorizationStatusRestricted;
			} break;
			case kCLAuthorizationStatusNotDetermined:{
				status = BqAuthorizationStatusUnknown;
			} break;
		}
		statusHandler(status);
	};
	__weak typeof(self) weakSelf = self;
	self.requestHandler = ^(BqAuthorizationStatusBlock statusHandler) {
		//[weakSelf.locationManager requestWhenInUseAuthorization];
		[weakSelf.locationManager requestAlwaysAuthorization];
		weakSelf.locationAuthorizationChangeHandler = ^(CLAuthorizationStatus locationStatus) {
			BqAuthorizationStatus status = BqAuthorizationStatusUnknown;
			switch (locationStatus) {
				case kCLAuthorizationStatusAuthorizedAlways:
				case kCLAuthorizationStatusAuthorizedWhenInUse:{
					status = BqAuthorizationStatusAuthorized;
				} break;
				case kCLAuthorizationStatusDenied:{
					status = BqAuthorizationStatusDenied;
				} break;
				case kCLAuthorizationStatusRestricted:{
					status = BqAuthorizationStatusRestricted;
				} break;
				case kCLAuthorizationStatusNotDetermined:{
					status = BqAuthorizationStatusUnknown;
				} break;
			}
			statusHandler(status);
		};
	};
}

#pragma mark - property

- (CLLocationManager *)locationManager {
	if (!_locationManager) {
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
	}
	return _locationManager;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	if (self.locationAuthorizationChangeHandler) self.locationAuthorizationChangeHandler(status);
}

@end
