/* 
 * @Author: 21克的爱情
 * @Date: 2020-02-25 13:22:40
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-22 19:34:27
 * @Description: String 拓展字段
 */

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// File文件扩展方法
extension FileExtension on File{
  
  /**
   * @description: 删除文件操作
   * @param {type} NULL
   * @return: NULL
   */
  Future<void> deleteFile() async {
    if( this !=null && await this.exists() ){
      // 删除文件
      await this.delete(recursive: true);
    }
  }

  // 获取app的存储路径
  Future<String> getFilePath({String suffixName}) async {
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
}