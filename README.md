# AuthorizationPattern

## 简述

笔者在 iOS 开发过程中发现，大部分的权限请求都可以遵循以下流图的两步请求流程。

![](https://ws1.sinaimg.cn/large/006tKfTcgy1frzzfkz8vdj30m80lfmz8.jpg)

可见，一个简单的权限请求，开发者是需要处理如此多的分支，然而，权限请求的形象应当是充当一个一夫当关的一个大门。对于权限请求的结果，用户（开发者）一般只关心权限最终是否授权成功，然后继续原来的业务逻辑。因此用户（开发者）希望流程可能是这样的：

![](https://ws1.sinaimg.cn/large/006tKfTcgy1fs0pkhxordj30m809caam.jpg)

本项目把通过权限请求逻辑抽取并封装为 `AuthorizationItem`，封装了权限请求中可通用的分支处理等胶水代码。并通过继承该类提供了一些常用权限请求的组件，用户可根据自身的项目需求添加其中权限请求。若在使用过程中有更好的建议或意见，欢迎 issue 我，或直接给我提 pr~

## 实现功能

- 抽取出请求权限的两步模式，用户只需关心与实现 `获取权限当前状态` 和 `请求权限` 这两部分的逻辑代码；
- 使用 block 封装逻辑代码；
- 按需实现或添加权限请求组件；
- 可在权限请求对象 `AuthorizationItem` 独立处理权限回调；
- 异步 `获取权限当前状态`，异步 `请求权限`；
- ~~可直接通过属性赋值实现 Info.plist 的权限描述；~~
- 提供常用权限权限封装示例（图库、相机、麦克风、定位、联系人，其他权限等笔者用到再加上去吧。。）；

为减少个人标签，近期去掉了命名中所有前缀，甚至连添加 Cocoapods 的必要都没有，各开发者用户可根据自己的项目自行添加前缀吧~

## 从此权限请求变得如此优雅

### 权限请求封装

```objective-c
#import "AuthorizationItem.h"

/**
 相册权限请求
 */
@interface PhotoAuthorizationItem : AuthorizationItem

@end
```

```objective-c
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
```

### 权限请求使用

```objective-c
PhotoAuthorizationItem *photoAuthorization = [[PhotoAuthorizationItem alloc] init];
photoAuthorization.viewControllerForAlert = self;
photoAuthorization.resultCallback = ^(AuthorizationItem *authorizationItem, BOOL authorized) {
	NSLog(@"%@%@", authorizationItem.authorizationName, authorized ? @"授权成功" : @"未授权");
	if (!authorized) return;
	// 后续操作
};
[photoAuthorization requestAuthorization];
```
