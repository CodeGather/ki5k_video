/* 
 * @Author: 21克的爱情
 * @Date: 2020-07-01 14:37:14
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-07-01 14:46:00
 * @Description: 
 */

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class EditVideo extends StatefulWidget {
  EditVideo({Key key}) : super(key: key);

  @override
  _EditVideoState createState() => _EditVideoState();
}

class _EditVideoState extends State<EditVideo> {
  VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: VideoPlayer(controller),
          ),
          Row(
            children: <Widget>[
              Icon(Icons.play_arrow),
              Expanded(
                child: Row(
                  children: <Widget>[
                    FlatButton(onPressed: (){}, child: Text("修剪")),
                    FlatButton(onPressed: (){}, child: Text("裁剪"))
                  ],
                )
              ),
              Icon(Icons.fullscreen),
            ],
          ),
          Row(
            children: <Widget>[

            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(Icons.check),
              Icon(Icons.close),
            ],
          )
        ],
      ),
    );
  }
}