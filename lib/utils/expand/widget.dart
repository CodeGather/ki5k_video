/* 
 * @Author: 21克的爱情
 * @Date: 2020-02-25 13:22:40
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-01 15:55:47
 * @Description: Widget 拓展字段
 */

import 'dart:math';

import 'package:flutter/material.dart';

// 字符串扩展方法
extension WidgetExtension on Widget{
  
  Widget widgetPoint() {

    ///widget 对应key 程序自动判断
    GlobalKey key;

    ///为引导框内显示的文字
    String tipsMessage;
    String nextString;
    ///为true时显示指引的矩形
    bool isShowReact;
    // final Widget child;

    // widgetPoint(this.key, {this.tipsMessage = "--", this.nextString = "下一步",this.isShowReact=false, this.child});
  }
}