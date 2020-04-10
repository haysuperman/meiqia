#import "MeiqiaPlugin.h"
#import <MeiQiaSDK/MeiQiaSDK.h>
#import "MQChatViewManager.h"


static NSString const *kMethodRegister = @"register";
static NSString const *kMethodChat = @"goToChat";
static NSString const *kMethodOpenMQServe = @"openMeiQiaServe";
static NSString const *kMethodCloseMQServe = @"closeMeiQiaServe";

@interface MeiqiaPlugin()
@property(nonatomic, strong) FlutterMethodChannel *channel;
@end

@implementation MeiqiaPlugin
- (instancetype)initWithChannel:(FlutterMethodChannel *)channel
{
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"meiqia_plugin"
                                     binaryMessenger:[registrar messenger]];
    MeiqiaPlugin* instance = [[MeiqiaPlugin alloc] initWithChannel:channel];
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
    __weak __typeof(self)weakSelf = self;
    [MQManager initWithAppkey:appKey completion:^(NSString *clientId, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!error) {
            [strongSelf.channel invokeMethod:@"initialResult" arguments:@{@"code":@"1",@"msg":@"注册成功"}];
            result(@{@"code":@"1",@"msg":@"初始化成功"});
        } else {
            [strongSelf.channel invokeMethod:@"initialResult" arguments:@{@"code":@"-1",@"msg":@"注册失败"}];
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
//    [chatViewManager pushMQChatViewControllerInViewController:viewController];
    [chatViewManager presentMQChatViewControllerInViewController:viewController];
}

@end
