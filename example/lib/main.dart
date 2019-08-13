import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meiqia_plugin/meiqia_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MeiqiaPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    MeiqiaPlugin.initMeiQia("0aff2f19280aa0c2dfa2cc12425a71fd",success: (code,msg) {
                      print("成功------------ $msg -- $code");
                    },failure: (code,msg) {
                      print("失败------------ $msg -- $code");
                    });
                  },
                  child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text('Running on: $_platformVersion\n')),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    MeiqiaPlugin.chat(userID: "112", userInfo: {
                      "name": "柚子",
                      "gender": "男",
                      "tel": "18867626276",
                      "comment":"备注信息"
                    });
                  },
                  child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text("聊天")),
                ),
              ),
            ],
          )),
    );
  }
}
