/* 
 * @Author: 21克的爱情
 * @Date: 2020-09-06 22:11:02
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-08 14:33:54
 * @Description: 
 */
// 消息包裹，用来存临时发送器和消息
import 'dart:isolate';

import 'package:ki5k_video/models/video_list.dart';
import 'package:xml/xml.dart';
import 'package:ki5k_video/api/Api.dart';

class MessagePackage {
  SendPort sender; // 临时发送器
  int pageIndex;
  List<VideoDetail> data; // 消息
  bool status;
  String type;

  MessagePackage(this.sender, this.pageIndex, this.type, this.data, this.status);

}

// 我是小蓝，负责计算偶数的个数,我必须是顶级函数
blueCounter(SendPort redSendPort) {
  // 创建小蓝的传送装置
  ReceivePort blueReceivePort = ReceivePort();
  // 用小红的发送器把小蓝的发送器发送出去
  redSendPort.send(blueReceivePort.sendPort);
  // 监听小蓝的传送装置，等待小红叫小蓝计算
  blueReceivePort.listen((package) async {
    // 这里的msg是dynamic，需要转换成 MessagePackage 类，上面自己定义的包裹封装类
    MessagePackage _msg = package as MessagePackage;
    // 开始耗时操作
    List<VideoDetail> data = await initPageData(_msg.pageIndex, _msg.type);

    if (data.isNotEmpty) {
      if(!_msg.status){
        _msg.data.addAll(data);
      } else {
        _msg.data = data;
      }
      // 计算好了用小红的临时发送器告诉小红
      _msg.sender.send(_msg.data);
    } else {
      // 计算好了用小红的临时发送器告诉小红
      _msg.sender.send(data);
    }
  });
}

Future<List<VideoDetail>> initPageData(int pageIndex, String type) async {
  List<VideoDetail> resultData = [];

  final value = await Api.getHomeVideo({
    'ac': 'videolist',
    't': type??'',
    // 'h': '24',
    'pg': pageIndex
  });

  if( value != null && value.isNotEmpty ){
    final document = XmlDocument.parse(value);
    final playUrlStr = document.findAllElements('video');
    playUrlStr.forEach((node){
      resultData.add(
        VideoDetail.fromJson({
          'vod_id': node.findElements('id').single.text,
          'vod_name': node.findElements('name').single.text,
          'vod_lang': node.findElements('lang').single.text,
          'vod_pic': node.findElements('pic').single.text,
          'vod_remarks': node.findElements('note').single.text,
        })
      );
    });
  }
  return resultData;
}
