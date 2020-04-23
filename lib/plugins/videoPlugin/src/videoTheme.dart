/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-15 11:33:29
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-15 12:08:25
 * @Description: 视频主体
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jokui_video/plugins/videoPlugin/src/widget/videoProgressBar.dart';

class VideoPlugin extends StatefulWidget {
  
  VideoPlugin({Key key}) : super(key: key);

  @override
  _VideoPluginState createState() => _VideoPluginState();
}

class _VideoPluginState extends State<VideoPlugin> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // VideoProgress()
      ],
    );
  }
}