/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-26 11:44:17
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-26 14:26:04
 * @Description: 
 */

import 'package:flutter/material.dart';

// Color文件扩展方法
extension ColorExtension on Color {
  /// 十六进制颜色，
  /// hex, 十六进制值，例如：0xffffff,
  /// alpha, 透明度 [0.0,1.0]
  Color hexColor({double alpha = 1}) {
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    print(alpha);
    return Color.fromRGBO(this.red, this.green, this.blue, alpha);
  }
}
