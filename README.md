
# meiqia_plugin

a flutter plugin for meiqiaSDK

## Getting Started
初始化
 ```dart
MeiqiaPlugin.initMeiQia("YourAppKey");
 ```
 跳转聊天界面
 ```dart
   MeiqiaPlugin.chat(userID: "userId", userInfo: {
                      "name": "金甲战士",
                      "gender": "男",
                      "tel": "18812345678",
                      "comment":"备注信息"
                    });
 ```
