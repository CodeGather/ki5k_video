/* 
 * @Author: 21克的爱情
 * @Date: 2020-01-26 18:44:34
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-06-25 09:33:37
 * @Description: 
 */
import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';

import 'home_page.dart';
import 'index_page.dart';
import 'provide/application_provide.dart';

void main() {
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    // 显示底部栏(隐藏顶部状态栏)
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    // 显示顶部栏(隐藏底部栏)
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    // 隐藏底部栏和顶部状态栏
    // SystemChrome.setEnabledSystemUIOverlays([]);
  }

  runApp(MyApp());
  setDesignWHD(375.0, 667.0, density: 2);
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> ApplicationStatus()),
      ],
      child: OKToast(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0XFFf60bff),
          ),
          home: IndexPage(),
          routes: {
            
          },
        ),
      ),
    );
  }
}
