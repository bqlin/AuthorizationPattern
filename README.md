# BqAuthorizationPattern

## 简述

笔者在 iOS 开发过程中发现，大部分的权限请求都可以遵循以下流图的两步请求流程。

![](https://ws1.sinaimg.cn/large/006tKfTcgy1frzzfkz8vdj30m80lfmz8.jpg)

因此，对于权限请求的结果，用户（开发者）一般只关心权限最终是否授权成功，然后继续原来的业务逻辑。

本项目把通过权限请求逻辑抽取并封装为 `BqAuthorizationItem`，并通过继承该类提供了一些常用权限请求的组件，用户可根据自身的项目需求添加其中权限请求。若在使用过程中有更好的建议或意见，欢迎 issue 我，或直接给我提 pr~

## 实现功能

- 抽取出请求权限的两步模式，用户只需关心与实现 `获取权限当前状态` 和 `请求权限` 这两部分的逻辑代码；
- 使用 block 封装逻辑代码；
- 按需实现或添加权限请求组件；
- 异步 `获取权限当前状态`，异步 `请求权限`；
- ~~可直接通过属性赋值实现 Info.plist 的权限描述；~~

## 从此权限请求变得如此优雅

### 权限请求封装

```objective-c
#import "BqAuthorizationItem.h"

/**
 相册权限请求
 */
@interface BqPhotoAuthorizationItem : BqAuthorizationItem

@end
```

```objective-c
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
```

### 权限请求使用

```objective-c
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
```
