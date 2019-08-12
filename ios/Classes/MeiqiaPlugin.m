#import "MeiqiaPlugin.h"
#import <MeiQiaSDK/MeiQiaSDK.h>
#import "MQChatViewManager.h"


static NSString const *kMethodRegister = @"register";
static NSString const *kMethodChat = @"goToChat";
static NSString const *kMethodOpenMQServe = @"openMeiQiaServe";
static NSString const *kMethodCloseMQServe = @"closeMeiQiaServe";

@implementation MeiqiaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"meiqia_plugin"
                                     binaryMessenger:[registrar messenger]];
    MeiqiaPlugin* instance = [[MeiqiaPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSArray *array = @[@"getPlatformVersion",kMethodRegister,kMethodChat,kMethodOpenMQServe,kMethodCloseMQServe];
    
    NSUInteger index = [array indexOfObject:call.method];
    switch (index) {
        case 0:result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);break;
        case 1:
            [self initSDKWithAppKey:call.arguments[@"appKey"] result:result];
            break;
        case 2:
            [self chat:call];
            break;
        case 3:
            
            break;
            
        case 4:
            
            break;
        default:
            result(FlutterMethodNotImplemented);
            break;
    }
    
}

-(void)initSDKWithAppKey:(NSString *)appKey result:(FlutterResult)result {
    [MQManager initWithAppkey:appKey completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            result(@{@"code":@"1",@"msg":@"初始化成功"});
        } else {
            NSLog(@"error:%@",error);
            result(@{@"code":@"-1",@"msg":[error description]});
        }
    }];
}

- (void)chat:(FlutterMethodCall *)call {
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    if (call.arguments) {
        if (call.arguments[@"userInfo"]) {
            [chatViewManager setClientInfo:call.arguments[@"userInfo"]];
        }
        if (call.arguments[@"id"]) {
            [chatViewManager setLoginCustomizedId:call.arguments[@"id"]];
        }
    }
    
    [chatViewManager enableSyncServerMessage:true];
    [chatViewManager setoutgoingDefaultAvatarImage:[UIImage imageNamed:@"meiqia-icon"]];
    [chatViewManager pushMQChatViewControllerInViewController:viewController];
}

@end
