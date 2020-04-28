/* 
 * @Author: 21克的爱情
 * @Date: 2020-02-25 13:22:40
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-28 13:15:09
 * @Description: String 拓展字段
 */

import 'dart:math';

import 'package:flutter/material.dart';

// 字符串扩展方法
extension StringExtension on String{
  
  /**
   * @description: 判断字符串是否符合电话号码规则
   * @param {type} "电话号码".isMobileNumber;
   * @return: bool（ true，false ）
   */
  bool get isMobileNumber {
    // 测试
    if(this?.isNotEmpty != true) return false;
    return RegExp(r'^((13[0-9])|(14[5,7,9])|(15[^4])|(18[0-9])|(17[0,1,3,5,6,7,8])|(19)[0-9])\d{8}$').hasMatch(this);
  }

  /**
   * @description: 数字字符串转换为int
   * @param {type} 数字字符串
   * @return: int
   */
  int get intParse{
    if(RegExp(r'^[0-9]+$').hasMatch(this)){
      return int.parse(this);
    } else {
      return 0;
    }
  }

  /*
   * @description: 校验身份号码是否正确
   * @param {type} 身份证号码<字符串>
   * @return: bool
   */ 
  bool get isCardNumber{
    bool regex = false;
    if( this != null && this.toString().isNotEmpty ){
      List<dynamic> cardNum = ["1", "0", "X", "9", "8", "7", "6", "5", "4", "3", "2"];
      int sum = 0;
      for( int i = 17; i > 0; i-- ){
        int item = pow(2, i) % 11;
        sum += item * int.parse(this.substring((17-i), (17-i+1)));
      }
      regex = this.substring(this.length-1) == cardNum[sum % 11];
    }
    return regex;
  }

  /* 
   * @description: 判断字符串是否为空或者为null
   * @param {type} "电话号码".isVerified;
   * @return: bool null 或者 “” 返回false 否则返回true
   */
  bool get isNotNullOrEmpty {
    bool isVerifi = false;
    if( this != null && this.toString().isNotEmpty ){
      isVerifi = true;
    }
    return isVerifi;
  }
}