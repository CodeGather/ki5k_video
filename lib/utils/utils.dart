/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-11 17:51:04
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-14 13:25:44
 * @Description: 
 */

import 'dart:convert' as convert;
import 'dart:core';
import 'dart:math';

import 'dart:ui';

import 'package:flutter/material.dart';

class Utils{
  /*
   * @description: 阿里云水印文字专用加密需要处理+变成=
   * @param {type} 待加密的字符串
   * @return: 加密后的字符串
   */
  static String base64Encode(String data){
    List<int> content = convert.utf8.encode(data);
    String str = convert.base64Encode(content);
    return str;
  }

  /*
   * @description: 解密字符串数据
   * @param {type} 待解密的字符串
   * @return: 解密后的字符串
   */
  static String base64Decode(String data){
    // String.fromCharCodes 使用事后出现中文乱码
    String digest = convert.utf8.decode(convert.base64Decode(data));
    return digest;
  }

  static Color randomColor({int r = 255, int g = 255, int b = 255, a = 255}) {
    if (r == 0 || g == 0 || b == 0) return Colors.black;
    if (a == 0) return Colors.white;
    return Color.fromARGB(
      a,
      r != 255 ? r : Random.secure().nextInt(r),
      g != 255 ? g : Random.secure().nextInt(g),
      b != 255 ? b : Random.secure().nextInt(b),
    );
  }
}