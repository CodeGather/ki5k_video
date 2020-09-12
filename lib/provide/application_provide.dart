/* 
 * @Author: 21克的爱情
 * @Date: 2020-03-15 08:42:09
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-08 09:17:34
 * @Description: 状态管理
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ki5k_video/models/tab_list.dart';

class ApplicationStatus with ChangeNotifier{
  static final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  
  bool _fullscreen;
  List<VideoType> _tabList;
  
  ApplicationStatus() {
    _instance();
  }

  Future<void> _instance() async {
    _fullscreen = false;
    _tabList = [];
  }

  set isFullscreen(bool data){
    _fullscreen = data;
    notifyListeners();
  }
  get isFullscreen => _fullscreen;

  set tabList(List<VideoType> data){
    _tabList = data;
    notifyListeners();
  }
  get tabList => _tabList;
  
}