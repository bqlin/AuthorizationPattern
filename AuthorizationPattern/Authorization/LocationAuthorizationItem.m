//
//  LocationAuthorizationItem.m
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/5/30.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "LocationAuthorizationItem.h"
#import <CoreLocation/CoreLocation.h>

NS_INLINE AuthorizationStatus authorizationStatusWithCLAuthorizationStatus(CLAuthorizationStatus locationStatus) {
	AuthorizationStatus status = AuthorizationStatusUnknown;
	switch (locationStatus) {
		case kCLAuthorizationStatusAuthorizedAlways:
		case kCLAuthorizationStatusAuthorizedWhenInUse:{
			status = AuthorizationStatusAuthorized;
		} break;
		case kCLAuthorizationStatusDenied:{
			status = AuthorizationStatusDenied;
		} break;
		case kCLAuthorizationStatusRestricted:{
			status = AuthorizationStatusRestricted;
		} break;
		case kCLAuthorizationStatusNotDetermined:{
			status = AuthorizationStatusUnknown;
		} break;
	}
	return status;
}

typedef void(^LocationAuthorizationChangeBlock)(CLAuthorizationStatus locationStatus);

@interface LocationAuthorizationItem ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) LocationAuthorizationChangeBlock locationAuthorizationChangeHandler;

@end

@implementation LocationAuthorizationItem

- (void)commonInit {
	self.authorizationName = @"定位服务";
	self.currentStatusHandler = ^(AuthorizationStatusBlock statusHandler) {
		AuthorizationStatus status = AuthorizationStatusUnknown;
		if (![CLLocationManager locationServicesEnabled]) {
			status = AuthorizationStatusDisabled;
			return;
		}
		status = authorizationStatusWithCLAuthorizationStatus([CLLocationManager authorizationStatus]);
		statusHandler(status);
	};
	__weak typeof(self) weakSelf = self;
	self.requestHandler = ^(AuthorizationStatusBlock statusHandler) {
		//[weakSelf.locationManager requestWhenInUseAuthorization];
		[weakSelf.locationManager requestAlwaysAuthorization];
		weakSelf.locationAuthorizationChangeHandler = ^(CLAuthorizationStatus locationStatus) {
			AuthorizationStatus status = authorizationStatusWithCLAuthorizationStatus(locationStatus);
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
