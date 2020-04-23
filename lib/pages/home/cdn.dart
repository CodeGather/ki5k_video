/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-11 11:37:08
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-11 11:37:09
 * @Description: 
 */

import 'package:flutter/cupertino.dart';

class CdnByeListener {
  // 工厂模式
  factory CdnByeListener() => _getInstance();
  static CdnByeListener get instance => _getInstance();
  static CdnByeListener _instance;
  CdnByeListener._internal() {
    // 初始化
    videoInfo = ValueNotifier({});
  }
  static CdnByeListener _getInstance() {
    if (_instance == null) {
      _instance = CdnByeListener._internal();
    }
    return _instance;
  }

  ValueNotifier<Map> videoInfo;
}