//
//  AppDelegate.h
//  HenryAPP
//
//  Created by Henry on 15/8/4.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <WeiboSDK.h>
#import "WXApi.h"

#import "ViewController.h"


typedef NS_ENUM(NSInteger, PlatformType) {
    PlatformTypeWeibo,//新浪微博
    PlatformTypeWeixin,//微信
    PlatformTypeQQ//QQ
};

@interface AppDelegate : UIResponder <UIApplicationDelegate, WeiboSDKDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
/** 用户当前使用的第三方平台 */
@property(nonatomic, assign) PlatformType platformType;
@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (strong, nonatomic) NSString *wbRefreshToken;

/**
 *  <#Description#>
 */
- (void)requestWeixinUserInfo;

@end

