//
//  BqDemoTableViewController.m
//  AuthorizationPattern
//
//  Created by Bq Lin on 2018/5/11.
//  Copyright © 2018年 Bq. All rights reserved.
//

#import "BqDemoTableViewController.h"
#import "BqAuthorizationItem.h"
#import "BqPhotoAuthorizationItem.h"
#import "BqLocationAuthorizationItem.h"

@interface BqDemoTableViewController ()

@property (nonatomic, strong) NSArray<BqAuthorizationItem *> *authorizationItems;

@end

@implementation BqDemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self prepareData];
}

- (void)prepareData {
	__weak typeof(self) weakSelf = self;
	NSMutableArray *authorizationItems = [NSMutableArray array];
	
	/// 相册
	BqPhotoAuthorizationItem *photoAuthorization = [[BqPhotoAuthorizationItem alloc] init];
	photoAuthorization.viewControllerForAlert = self;
	photoAuthorization.resultCallback = ^(BqAuthorizationItem *authorizationItem, BOOL authorized) {
		NSLog(@"%@%@", authorizationItem.authorizationName, authorized ? @"授权成功" : @"未授权");
		if (!authorized) return;
		// 后续操作
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
		imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[weakSelf presentViewController:imagePickerController animated:YES completion:nil];
	};
	[authorizationItems addObject:photoAuthorization];
	
	/// 定位
	BqLocationAuthorizationItem *locationAuthorization = [[BqLocationAuthorizationItem alloc] init];
	locationAuthorization.viewControllerForAlert = self;
	locationAuthorization.resultCallback = ^(BqAuthorizationItem *authorizationItem, BOOL authorized) {
		NSLog(@"%@%@", authorizationItem.authorizationName, authorized ? @"授权成功" : @"未授权");
		if (!authorized) return;
	};
	[authorizationItems addObject:locationAuthorization];
	
	self.authorizationItems = authorizationItems.copy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.authorizationItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BqAuthorizationItem *item = self.authorizationItems[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
	cell.textLabel.text = item.authorizationName;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	BqAuthorizationItem *item = self.authorizationItems[indexPath.row];
	[item requestAuthorization];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
