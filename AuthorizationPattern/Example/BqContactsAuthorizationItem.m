//
//  BqContactsAuthorizationItem.m
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/6/2.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "BqContactsAuthorizationItem.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>

@implementation BqContactsAuthorizationItem

- (void)commonInit {
	self.authorizationName = @"联系人";
	if (BQ_AVAILABLE(9.0)) {
		self.currentStatusHandler = ^(BqAuthorizationStatusBlock statusHandler) {
			CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
			statusHandler((BqAuthorizationStatus)status);
		};
		self.requestHandler = ^(BqAuthorizationStatusBlock statusHandler) {
			[[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
				if (error) {
					NSLog(@"Contacts authorization request error: %@", error);
					statusHandler(BqAuthorizationStatusDenied);
					return;
				}
				
				BqAuthorizationStatus status = BqAuthorizationStatusUnknown;
				status = granted ? BqAuthorizationStatusAuthorized : BqAuthorizationStatusDenied;
				statusHandler(status);
			}];
		};
	} else { // iOS 9 之前
		self.currentStatusHandler = ^(BqAuthorizationStatusBlock statusHandler) {
			ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
			statusHandler((BqAuthorizationStatus)status);
		};
		self.requestHandler = ^(BqAuthorizationStatusBlock statusHandler) {
			ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
			if (!addressBookRef) {
				statusHandler(BqAuthorizationStatusDisabled);
				return;
			}
			ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
				if (error) {
					NSLog(@"Contacts authorization request error: %@", error);
					statusHandler(BqAuthorizationStatusDenied);
					return;
				}
				
				BqAuthorizationStatus status = BqAuthorizationStatusUnknown;
				status = granted ? BqAuthorizationStatusAuthorized : BqAuthorizationStatusDenied;
				statusHandler(status);
				CFRelease(addressBookRef);
			});
		};
	}
}

@end
