/* 
 * @Author: 21克的爱情
 * @Date: 2020-01-26 18:40:09
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-11 13:17:05
 * @Description: 
 */
import 'package:flutter/material.dart';

// import 'video_page.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('精彩影视'),
      ),
      body: Column(
        children: <Widget>[
          FlatButton(
            onPressed: (){
              return Navigator.of(context).push(
                MaterialPageRoute(builder: (_){
                  //return ChewieDemo();
                })
              );
            },
            child: Text('开始播放'),
          )
        ],
      ),
    );
  }
}