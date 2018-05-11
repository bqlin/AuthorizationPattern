//
//  BqAuthorizationTool.h
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/5/11.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BqAuthorizationStatus) {
	BqAuthorizationStatusUnknown = 0,
	BqAuthorizationStatusDenied = 2,
	BqAuthorizationStatusAuthorized = 3,
	BqAuthorizationStatusDisabled
};
typedef void(^BqAuthorizationStatusBlock)(BqAuthorizationStatus status);

@interface BqAuthorizationTool : NSObject

@end
