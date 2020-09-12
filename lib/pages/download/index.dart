/* 
 * @Author: 21克的爱情
 * @Date: 2020-09-08 16:25:31
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-08 16:26:07
 * @Description: 
 */
import 'package:flutter/material.dart';

class DownloadPage extends StatefulWidget {
  DownloadPage({Key key}) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('下载中心'),
      ),
      body: Align(
        child: Text('正在规划中'),
      ),
    );
  }
}