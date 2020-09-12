/* 
 * @Author: 21克的爱情
 * @Date: 2020-09-06 22:11:02
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-07 17:16:32
 * @Description: 
 */
// 消息包裹，用来存临时发送器和消息
import 'dart:isolate';

import 'package:jokui_video/api/Api.dart';
import 'package:jokui_video/models/video_list.dart';

class MessagePackage {
  SendPort sender; // 临时发送器
  int pageIndex;
  List<VideoDetail> data; // 消息
  bool status;
  bool showTab;

  MessagePackage(this.sender, this.pageIndex, this.data, this.status, this.showTab);

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
    // 小蓝开始计算
    // int r = countEven(_msg.msg as num);
    List<VideoDetail> data = await initPageData(_msg.pageIndex, showTab: _msg.showTab);

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
      _msg.sender.send([]);
    }
  });
}

Future<List<VideoDetail>> initPageData(int pageIndex, {bool showTab = false}) async {
  // XmlDocument xmlDocument = await XmlDocument.fromUri('https://www.pianku.tv/mv/');
  List<VideoDetail> resultData = [];
  // final value = await Api.getPageData('mv/------$pageIndex.html');
  final value = await Api.getVideoList({
    'ac': 'list',
    'pg': pageIndex,
    't': ''
  });
  if( value != null && value.isNotEmpty ){
    resultData = getVideoListList(value['list']);
    
  }
  return resultData;
}

//计算偶数的个数
int countEven(num num) {
  int count = 0;
  while (num > 0) {
    if (num % 2 == 0) {
      count++;
    }
    num--;
  }
  return count;
}