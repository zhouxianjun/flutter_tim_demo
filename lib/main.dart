import 'dart:io';

import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tim_demo/app.dart';
import 'package:tim_demo/store/index.dart';
import 'package:tim_demo/util/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    // 本地存储初始化
    await Storage.init();

    // 初始化TIM
    await TencentImPlugin.init(appid: '1400352283', enabledLogPrint: true);

    // 尝试静默登录
    await appStore.tryLogin();

    // APP入口并配置Provider
    runApp(MultiProvider(providers: providers, child: MyApp()));

    // 自定义报错页面
    ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
        debugPrint(flutterErrorDetails.toString());
        return Center(child: Text("App错误，快去反馈给作者!"));
    };

    // Android状态栏透明
    if (Platform.isAndroid) {
        SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
}