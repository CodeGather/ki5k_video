/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-11 17:51:04
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-24 12:16:19
 * @Description: 
 */

import 'dart:convert' as convert;
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils{
  // 获取app的存储路径
  static getFilePath({String suffixName}) async {
    String filePath = '';
    // 检查所需要的权限
    var fileType = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    print(fileType[PermissionGroup.storage]);
    if ( Platform.isAndroid && fileType[PermissionGroup.storage] == PermissionStatus.granted || Platform.isIOS) {
      Directory dir = Platform.isIOS? await getApplicationDocumentsDirectory() : await getExternalStorageDirectory();
      filePath = dir.path+'/download';
      // 判断文件夹是否存在
      bool isDirExist = await Directory(filePath).exists();
      if ( !isDirExist ){
        Directory(filePath).create(recursive: true);
      }

      if( suffixName != null && suffixName.isNotEmpty ){
        String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();
        filePath = '$filePath/${timestamp()}.${suffixName}';
      }
    } else {
      print('请打开SD卡存储权限！');
    }

    return filePath;
  }
  /* 
   * @description: 版本号比较
   * @param {type} 两个字符串1.0.0
   * @return: bool
   */
  static bool versionCompare(String oldVersion, String newVersion){
    List oldList = oldVersion.split('.');
    List newList = newVersion.split('.');
    bool result = false;
    int i = 0;
    if( oldList.length == newList.length ){
      while( i < oldList.length ){
        if( double.parse(newList[i]) > double.parse(oldList[i]) ){
          result = true;
          break;
        }
        i++;
      }
    }
    return result;
  }
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