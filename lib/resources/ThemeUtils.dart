/*
 * @Author: 21克的爱情
 * @Date: 2019-05-14 14:35:57
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2019-11-19 15:15:36
 * @Description: 自定义APP颜色代码
 */

import 'package:flutter/material.dart';

class ThemeUtils {
  // 默认主题色
  static const Color defaultColor = const Color(0xFFFEE50F);
  static const Color mainBtnDisColor = const Color.fromRGBO(8, 113, 255, 0.5); //按钮禁用背景颜色
  static const Color mainBgColor = const Color(0xFFF4F5F9);
  static const Color mainTxtColor = const Color(0xFF3C4F5E);
  static const Color mainTxtDesColor = const Color(0xFFBBC7D7);
  static const Color mainTransColor = Colors.transparent;
  static const Color blueColor = const Color(0xFF3A71FF); // 收入背景色
  static const Color startColor = const Color(0xFFFFB056); // 五角星背景色
  static const Color greenColor = const Color(0xFF23CE6B); // 安全提示颜色

  static const Color orangeColor = const Color(0xFFFDAE5F); // 详情时间颜色橙色
  
  static const Color orderStartbgColor = const Color(0xFFFFE3E3); // 待预约背景
  static const Color orderTipColor = const Color(0xFFFFAF57); // 派单背景

  static const Color backBgColor = const Color.fromRGBO(0, 0, 0, 0.5);
  static const Color orderLineColor = const Color(0xFFEAEAEA); // 线条颜色
  static const Color homeRedColor = const Color(0xFFFCE3E4); // 首页提示颜色
  

  static const Color whiteColor = const Color(0xFFFFFFFF);
  static const Color blockColor = const Color(0xFF000000);
  static const Color colorRed = const Color(0xFFF03C30);
  static const Color color3333 = const Color(0xFF333333);
  static const Color color6969 = const Color(0xFF696969);
  static const Color colorE6e6 = const Color(0xFFE6E6E6);
  static const Color colorEbeb = const Color(0xFFEBEBEB);
  static const Color color6666 = const Color(0xFF666666);
  static const Color color7C78 = const Color(0xFF7C78EB); // 城市背景色
  static const Color colorCB93 = const Color(0xFFCB93FC); // 年龄背景色
  static const Color colorD0d0 = const Color(0xFFD0D0D0);
  static const Color colorDada = const Color(0xFFDADADA);
  static const Color colorF1f2 = const Color(0xFFF1F2F7); // 评论详情
  static const Color colorF5f5 = const Color(0xFFF5F5F5);
  static const Color colorF5f4 = const Color(0xFFF5F4F9);
  static const Color colorF6f6 = const Color(0xFFF6F6F6);
  static const Color colorFf62 = const Color(0xFFFF62A5); // 女生符号颜色
  static const Color color84AE = const Color(0xFF84AEFC); // 男士符号颜色
  static const Color colorF9f9 = const Color(0xFFF9F9F9);
  static const Color colorFfe3 = const Color(0x20FFE311);
  static const Color color9999 = const Color(0xFF999999);
  static const Color color3B4f = const Color(0xFF3B4F5F); // 发现相机颜色
  static const Color colorFfe2 = const Color(0xFFFFE259); // 发现页面上渐变
  static const Color colorFfa7 = const Color(0xFFFFA751); // 发现页面下渐变
  static const Color color0072 = const Color(0xFF0072FF); // 发现页面用户昵称颜色
  
  static const Color color635D = const Color(0XFF635de7); // 发现页面用户昵称颜色

  // 可选的主题色
  static const List<Color> supportColors = [
    defaultColor,
    Colors.purple,
    Colors.orange,
    Colors.deepPurpleAccent,
    Colors.redAccent,
    Colors.blue,
    Colors.amber,
    Colors.green,
    Colors.lime,
    Colors.indigo,
    Colors.cyan,
    Colors.teal
  ];

  // 当前的主题色
  static Color currentColorTheme = defaultColor;
}
