//
//  ContactsAuthorizationItem.m
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/6/2.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "ContactsAuthorizationItem.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>

@implementation ContactsAuthorizationItem

- (void)commonInit {
	self.authorizationName = @"联系人";
	if (UNIVERSAL_AVAILABLE(9.0)) {
		self.currentStatusHandler = ^(AuthorizationStatusBlock statusHandler) {
			CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
			statusHandler((AuthorizationStatus)status);
		};
		self.requestHandler = ^(AuthorizationStatusBlock statusHandler) {
			[[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
				if (error) {
					NSLog(@"Contacts authorization request error: %@", error);
					statusHandler(AuthorizationStatusDenied);
					return;
				}
				
				AuthorizationStatus status = AuthorizationStatusUnknown;
				status = granted ? AuthorizationStatusAuthorized : AuthorizationStatusDenied;
				statusHandler(status);
			}];
		};
	} else { // iOS 9 之前
		self.currentStatusHandler = ^(AuthorizationStatusBlock statusHandler) {
			ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
			statusHandler((AuthorizationStatus)status);
		};
		self.requestHandler = ^(AuthorizationStatusBlock statusHandler) {
			ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
			if (!addressBookRef) {
				statusHandler(AuthorizationStatusDisabled);
				return;
			}
			ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
				if (error) {
					NSLog(@"Contacts authorization request error: %@", error);
					statusHandler(AuthorizationStatusDenied);
					return;
				}
				
				AuthorizationStatus status = AuthorizationStatusUnknown;
				status = granted ? AuthorizationStatusAuthorized : AuthorizationStatusDenied;
				statusHandler(status);
				CFRelease(addressBookRef);
			});
		};
	}
}

@end
