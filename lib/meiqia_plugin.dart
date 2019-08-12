import 'dart:async';

import 'package:flutter/services.dart';

class MeiqiaPlugin {
  static const MethodChannel _channel = const MethodChannel('meiqia_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // 初始化SDK
  static Future<MeiQiaResult> initMeiQia(String appKey) async {
    Map result = await _channel.invokeMethod("register", {"appKey": appKey});
    return MeiQiaResult(result["code"], result["msg"]);
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
  comment	  备注
  */
  // 进入聊天界面
  static Future<MeiQiaResult> chat(
      {String userID, Map<String, String> userInfo}) async {
    await _channel.invokeMethod("goToChat", {"id": userID, "userInfo": userInfo});
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
