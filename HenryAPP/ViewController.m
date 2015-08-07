//
//  ViewController.m
//  HenryAPP
//
//  Created by Henry on 15/8/4.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <WeiboSDK.h>
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"

@interface ViewController ()
/** description */
@property(nonatomic, strong) UITableView *tabelView;
/** 索引 */
@property(nonatomic, assign) NSInteger index;
/** description */
@property(nonatomic, strong) AppDelegate *appDelegate;
@end

@implementation ViewController

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect frame = CGRectMake(100, 50, 100, 50);
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:@"微博登陆" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionName) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:button];
    
    frame.origin.y += 70;
    UIButton *button1 = [[UIButton alloc]initWithFrame:frame];
    [button1 setTitle:@"微博分享" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(shareToWeibo) forControlEvents:UIControlEventTouchUpInside];
    [button1 setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:button1];
    
    frame.origin.y += 90;
    button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:@"微信登陆" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(weixinlogin) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:button];
    
    frame.origin.y += 70;
    button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:@"微信朋友圈" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(weixinpengyou) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:button];
    
    frame.origin.y += 70;
    button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:@"微信好友" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(weixinhaoyou) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:button];
}

- (void)weixinhaoyou
{
    [self weixinmessagewithscene:WXSceneSession];
}

- (void)weixinpengyou
{
    [self weixinmessagewithscene:WXSceneTimeline];
}

- (void)weixinmessagewithscene:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"test.jpg"]];
    
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    NSLog(@"filepath :%@",filePath);
    ext.imageData = [NSData dataWithContentsOfFile:filePath];
    
    //UIImage* image = [UIImage imageWithContentsOfFile:filePath];
    UIImage* image = [UIImage imageWithData:ext.imageData];
    ext.imageData = UIImagePNGRepresentation(image);
    
    //    UIImage* image = [UIImage imageNamed:@"res5thumb.png"];
    //    ext.imageData = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

- (void)weixinlogin
{
    self.appDelegate.platformType = PlatformTypeWeixin;
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSString *openId = [[NSUserDefaults standardUserDefaults] objectForKey:@"openid"];
    //如果已经请求过微信授权登录，那么考虑用已经得到的access_token
    if (accessToken && openId) {
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_token"];
        NSString *refreshUrlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", @"wxd930ea5d5a258f4f", refreshToken];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:refreshUrlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *refreshDict = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *reAccessToken = [refreshDict objectForKey:@"access_token"];
            if (reAccessToken) {
                [[NSUserDefaults standardUserDefaults] setObject:reAccessToken forKey:@"access_token"];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:@"openid"] forKey:@"openid"];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:@"refresh_token"] forKey:@"refresh_token"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.appDelegate requestWeixinUserInfo];
            }else{
                [self wxLogin];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"用refresh——token来更新accessToken时出错 ＝ %@", error);
        }];
    }else{
        [self wxLogin];
    }
}

- (void)wxLogin
{
    SendAuthReq *req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"123";
    [WXApi sendReq:req];
}

- (void)shareToWeibo
{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
//        request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = @"Message from henry's APP";
    
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"]];
    message.imageObject = image;
    
    return message;
}

- (void)actionName
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"ViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}
@end
