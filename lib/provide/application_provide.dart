/* 
 * @Author: 21克的爱情
 * @Date: 2020-03-15 08:42:09
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-15 21:09:35
 * @Description: 列表状态管理
 */

import 'package:flutter/foundation.dart';

class ApplicationStatus with ChangeNotifier{
  bool isFullScreenStatus = false;
  int clickTime = 0;
  String userData;
  String apiUrl = 'https://jx.688ing.com/parse/op/play';

  void clearUseData(){
    userData = null;
    notifyListeners();
  }

  set setUseData( String data ){
    userData = data;
    notifyListeners();
  }

  get getUseData => userData;

  // 点击video的时间
  set setClickTime( int data ){
    clickTime = data;
    notifyListeners();
  }

  get getClickTime => userData;


  void enterFullScreen() {
    isFullScreenStatus = true;
    notifyListeners();
  }

  void cancelFullScreen() {
    isFullScreenStatus = false;
    notifyListeners();
  }
  
  get isFullScreen => isFullScreenStatus;

}