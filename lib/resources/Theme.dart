/* 
 * @Author: 21克的爱情
 * @Date: 2020-03-19 10:10:41
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-03 09:35:07
 * @Description: 自定义主题的切换
 */

import 'package:flutter/material.dart';

import './ThemeUtils.dart';

class JokuiTheme{
  static ThemeData appTheme( {bool isDark = false} ){
    return isDark ? darkTheme : lightTheme;
  }

  // 自定义黑暗主题
  static ThemeData get darkTheme{
    return ThemeData(
      brightness: Brightness.dark,
      accentColor: ThemeUtils.blockColor,
      primaryColor: ThemeUtils.blockColor,
      backgroundColor: Colors.black,
      dialogBackgroundColor: Colors.grey[900],
      scaffoldBackgroundColor: ThemeUtils.blockColor,
      unselectedWidgetColor: ThemeUtils.mainTxtColor,
      dividerColor: Colors.white24,
      platform: TargetPlatform.iOS, // 该属性可使页面右划返回
      appBarTheme: AppBarTheme(
        elevation: 0,
        iconTheme: IconThemeData(  // appBar 图标颜色
          color: ThemeUtils.mainTxtColor
        ),
      ),
      primaryTextTheme: TextTheme(
        headline1: TextStyle(
          color: ThemeUtils.mainTxtColor
        ),
      ),
      textTheme: TextTheme( // 全局字体样式
        button: TextStyle(
          color: ThemeUtils.blueColor
        ),
      ),
      iconTheme: IconThemeData(
        color: ThemeUtils.mainTxtColor
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: ThemeUtils.blueColor,
        disabledColor: ThemeUtils.mainBtnDisColor,
      ),
    );
  }

  // 自定义默认主题
  static ThemeData get lightTheme{
    return ThemeData(
      brightness: Brightness.light,
      accentColor: ThemeUtils.blueColor,
      primaryColor: ThemeUtils.whiteColor,
      backgroundColor: ThemeUtils.mainBgColor,
      dialogBackgroundColor: ThemeUtils.whiteColor,
      scaffoldBackgroundColor: ThemeUtils.mainBgColor,
      unselectedWidgetColor: ThemeUtils.blueColor,
      dividerColor: Colors.grey[300],
      platform: TargetPlatform.iOS, // 该属性可使页面右划返回
      appBarTheme: AppBarTheme(
        elevation: 0,
        iconTheme: IconThemeData(  // appBar 图标颜色
          color: ThemeUtils.mainTxtColor
        ),
        textTheme: TextTheme(   // appBar 字体样式
          title: TextStyle(
            fontSize: 16,
            color: ThemeUtils.mainTxtColor
          )
        ),
      ),
      primaryTextTheme: TextTheme(
        headline1: TextStyle(
          color: ThemeUtils.mainTxtColor
        ),
      ),
      textTheme: TextTheme( // 全局字体样式
        button: TextStyle(
          color: ThemeUtils.blueColor
        ),
      ),
      iconTheme: IconThemeData(
        color: ThemeUtils.mainTxtColor
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: ThemeUtils.blueColor,
        disabledColor: ThemeUtils.mainBtnDisColor,
      ),
    );
  }
}