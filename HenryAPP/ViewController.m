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
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "AppDelegate.h"

#define XXX @"fff"

const NSString *A = @"A";
NSString * const B = @"B";

static NSString const * C = @"xx";

@interface ViewController ()<TencentSessionDelegate>
/** description */
@property(nonatomic, strong) UITableView *tabelView;
/** 索引 */
@property(nonatomic, assign) NSInteger index;
/** description */
@property(nonatomic, strong) AppDelegate *appDelegate;

/** description */
@property(nonatomic, strong) TencentOAuth *tencentOauth;
@end

@implementation ViewController

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
        
    CGRect frame = CGRectMake(50, 50, 100, 50);
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
    
    
    frame = CGRectMake(200, 50, 100, 50);
    button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:@"QQ登录" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(QQLogin) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:button];
    
    frame.origin.y += 70;
    button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:@"发给好友" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(QQFriend) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:button];
    
    frame.origin.y += 70;
    button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:@"发到QQ空间" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(QQZone) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:button];
    
    A = @"C";
    
    NSLog(@"A %@", A);
    
    C = @"ff";
    
    NSLog(@"C:%@", C);
}
#pragma mark - QQ

- (void)QQLogin
{
    self.appDelegate.platformType = PlatformTypeQQ;
    NSArray* permissions = [NSArray arrayWithObjects:
                            @"get_user_info", @"get_simple_userinfo", @"add_t",                            nil];
    [self.tencentOauth authorize:permissions inSafari:NO];
}

- (TencentOAuth *)tencentOauth{
    if (!_tencentOauth) {
        _tencentOauth = [[TencentOAuth alloc]initWithAppId:@"1104804404" andDelegate:self];
    }
    return _tencentOauth;
}

- (void)QQZone
{
    NSString *urlString = @"http://www.laodong.me/blog-cms/";
    NSString *previewImageUrlString = @"test.jpg";
    
    self.appDelegate.platformType = PlatformTypeQQ;
    self.tencentOauth;
    //这里初始化TencentOAuth 否则会出现 QQApiSendResultCode 会得到 EQQAPIAPPNOTREGISTED 的值 无法调用QQ面板
    
//    QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:urlString] title:@"个人博客搭建" description:@"description" previewImageURL:[NSURL URLWithString:previewImageUrl]];
    QQApiNewsObject *newObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:urlString] title:@"title" description:@"description" previewImageData:[NSData dataWithContentsOfURL:[NSURL URLWithString:previewImageUrlString]]];
    SendMessageToQQReq *request = [SendMessageToQQReq reqWithContent:newObj];
    QQApiSendResultCode code = [QQApiInterface SendReqToQZone:request];
    NSLog(@"code : %d", code);
    
    
}


- (void)QQFriend
{
    /*
    QQApiTextObject *textObject = [QQApiTextObject objectWithText:@"Hello!!!!!"];
    SendMessageToQQReq *request = [SendMessageToQQReq reqWithContent:textObject];
    QQApiSendResultCode sent = [QQApiInterface sendReq:request];
     */
    
    self.appDelegate.platformType = PlatformTypeQQ;
    self.tencentOauth;
    //这里初始化TencentOAuth 否则会出现 QQApiSendResultCode 会得到 EQQAPIAPPNOTREGISTED 的值 无法调用QQ面板
    
    NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"test.jpg"], 1);
    QQApiImageObject *imageObj = [QQApiImageObject objectWithData:data previewImageData:data title:@"title" description:@"description"];
    SendMessageToQQReq *request = [SendMessageToQQReq reqWithContent:imageObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:request];
    
    NSLog(@"sent : %d", sent);
}

- (void)tencentDidLogin
{
    NSLog(@"QQ登录完成");
    if (self.tencentOauth.accessToken.length > 0) {
        NSLog(@"----Tencent----\naccessToken:%@\nopenId:%@expirationDate:%@", self.tencentOauth.accessToken, self.tencentOauth.openId, self.tencentOauth.expirationDate);
        [self QQGetUserInfo];
    }else{
        NSLog(@"登录不成功，没有获取到access_token");
    }
}

- (void)QQGetUserInfo
{
    NSString *urlString = [NSString stringWithFormat:@"https://openmobile.qq.com/user/get_simple_userinfo?access_token=%@&oauth_consumer_key=%@&openid=%@", self.tencentOauth.accessToken, self.tencentOauth.appId, self.tencentOauth.openId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager GET:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取QQ用户资料失败 %@", error.description);
    }];
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {
        NSLog(@"QQ用户取消登录");
    }else {
        NSLog(@"QQ登录失败");
    }
}

- (void)tencentDidNotNetWork
{
    NSLog(@"因为网络问题导致的QQ登录失败");
}

#pragma mark - 微信

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
    self.appDelegate.platformType = PlatformTypeWeibo;
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
