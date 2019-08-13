import 'dart:async';

import 'package:flutter/services.dart';

typedef CommonResultCallback = Function(int code, String msg);

class MeiqiaPlugin {
  static const MethodChannel _channel = const MethodChannel('meiqia_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // 初始化SDK
  static Future<dynamic> initMeiQia(String appKey,
      {CommonResultCallback success, CommonResultCallback failure}) async {
    _channel.setMethodCallHandler((MethodCall call) {
      if ("initialResult" == call.method) {
        /// 状态码
        ///
        /// -1：失败  1：成功
        /// {
        ///   "code":1,
        ///   "msg":"注册成功"
        ///  }
        Map result = call.arguments;
        handleInitialResult(result, success, failure);
      }
      return null;
    });
    dynamic object =
        await _channel.invokeMethod("register", {"appKey": appKey});
    return object;
  }

  /*

  Key     	说明
  name	    真实姓名
  gender  	性别
  age	      年龄
  tel	      电话
  weixin	  微信
  weibo	    微博
  address	  地址
  email   	邮件
  weibo   	微博
  avatar  	头像 URL
  tags	    标签，数组形式，且必须是企业中已经存在的标签
  source  	顾客来源
  comment	  备注1111
  */
  // 进入聊天界面
  static Future<MeiQiaResult> chat(
      {String userID, Map<String, String> userInfo}) async {
    await _channel
        .invokeMethod("goToChat", {"id": userID, "userInfo": userInfo});
  }

  static handleInitialResult(
      Map result, CommonResultCallback success, CommonResultCallback failure) {
    int code = int.parse(result["code"]);
    if (code == 1) {
      if (success != null) success(code, result["msg"]);
    } else {
      if (failure != null) failure(code, result["msg"]);
    }
  }
}

class MeiQiaResult {
  /// 状态码
  ///
  /// -1：失败  1：成功
  int code;
  String msg;

  MeiQiaResult(this.code, this.msg);
}
