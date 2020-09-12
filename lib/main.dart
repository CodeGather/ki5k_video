/* 
 * @Author: 21克的爱情
 * @Date: 2020-09-02 15:56:38
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-09 09:57:43
 * @Description: 
 */
import 'dart:io';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ki5k_video/pages/index.dart';
import 'package:ki5k_video/provide/application_provide.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

void main() async {
  
  // WidgetsFlutterBinding.ensureInitialized();
  // // Initialize without device test ids.
  // Admob.initialize();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);

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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApplicationStatus()),
      ],
      child: OKToast(
        child: MaterialApp(
          title: '爱吾影视',
          debugShowCheckedModeBanner: false,
          navigatorKey: ApplicationStatus.navigatorKey,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MainScreen(),
        ),
      ),
    );
  }
}