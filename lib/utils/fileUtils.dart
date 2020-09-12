/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-22 19:22:24
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-07-12 08:50:42
 * @Description: 文件操作工具类
 */

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FileUtil{
  
  /* 
   * @description: 读取文件信息（本地/远程）
   * @param {type} 路径/远程链接
   * @return: String
   */
  Future getMdFile(url) async {
    // bool productionEnv = Store.value<ConfigModel>(context).isPro;
    bool productionEnv = false;
    if (productionEnv) {
      // return await this.readRemoteFile(url);
    } else {
      return await this.readLocaleFile(url);
    }
  }

  /* 
   * @description: 读取本地文件信息
   * @param {type} 本地文件路径
   * @return: String
   */
  Future<String> readLocaleFile(path) async {
    return await rootBundle.loadString('${path}', cache: false);
  }
  /**
   * @description: 生成文件名称
   * @param {type} String suffixName 字符串后缀  type 是否返回文件夹路径
   * @return: 一个带文件后缀的字符串
   */
  static Future<String> getFileName(String suffixName, {bool type = true, String createName, String round}) async {
    String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();
    // 获取主目录
    Directory extDir = Platform.isIOS? await getApplicationDocumentsDirectory() : await getExternalStorageDirectory();
    Directory dirPath = Directory.fromUri(Uri.parse('${extDir.path}/video/${suffixName ?? round + "/"}'));
    // 判断是否存在文件夹
    if( await dirPath.exists() == false ){
      await new Directory(dirPath.path).create(recursive: true);
    }
    // 文件路径+文件名
    String filePath = '${dirPath.path}${createName ?? timestamp()}.${suffixName}';
    if( !type ){
      filePath = dirPath.path;
    }
    return filePath;
  }

  /* 
   * @description: 删除目录或者文件
   * @param {type} dirString 字符串路径 isDir 是否为目录路径 默认为true
   * @return: bool
   */
  static Future<bool> deleteFile(String dirString, {bool isDir = true}) async {
    assert( dirString != null );
    //删除目录
    if( isDir ){
      Directory dir = await Directory.fromUri(Uri.parse(dirString));
      if( dirString != null && dirString.isNotEmpty && await dir.exists()){
        await dir.deleteSync(recursive: true);
        return Future.value(true);
      }
    } else {
      File file = File( dirString );
      if( await file.exists() ){
        await file.delete();
        return Future.value(true);
      }
    }
    return Future.value(false);
  }

  /* 
   * @description: 文件写入内容
   * @param {type} filePath 文件路径 文件内容 fileData 是否是插入方式 append
   * @return: bool
   */
  static Future<bool> writeFileData(String filePath, String fileData, {bool append = true}){
    File file = File(filePath);
    IOSink slink = file.openWrite(mode: append ? FileMode.append : FileMode.write);
    slink.write(fileData);
    slink.close();
    return Future.value(true);
  }

  /* 
   * @description: 文件内容编辑
   * @param {type} filePath 文件路径 分割符号 splitData 删除下标 deleteIndex
   * @return: bool
   */
  static Future<bool> deleteFileData(String filePath, {String splitData='\n', int deleteIndex}) async {
    // 获取文件
    File file = File(filePath);
    // 读取文件字符串
    String contents = await file.readAsString();
    // 判断字符串是否为空
    if( contents != null && contents.isNotEmpty ){
      // 把字符串分割成数组
      List arr = contents.split(splitData);
      if( arr.length > 0 ){
        arr.removeAt(deleteIndex ?? (arr.length < 2 ? 0 : arr.length-2));
        String fileData = arr.join(splitData);
        IOSink slink = file.openWrite(mode: FileMode.write);
        slink.write(fileData);
        slink.close();
        return Future.value(true);
      }
    }
    return Future.value(false);
  }
}