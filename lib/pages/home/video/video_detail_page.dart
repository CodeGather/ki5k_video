/* 
 * @Author: 21克的爱情
 * @Date: 2020-09-04 15:25:28
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-08 16:19:55
 * @Description: 
 */
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:ki5k_video/api/Api.dart';
import 'package:ki5k_video/models/origin.dart';
import 'package:ki5k_video/models/video_attr.dart';
import 'package:ki5k_video/models/video_list.dart';
import 'package:awsome_video_player/awsome_video_player.dart';
import 'package:flutter/material.dart';
import 'package:ki5k_video/provide/application_provide.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart';

import 'video_play_page.dart';


class VideoDetailPage extends StatefulWidget {
  final String id;
  VideoDetailPage(this.id, {Key key}) : super(key: key);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  String title='';
  List<String> origin=[];
  List<Origin> originUrl=[];

  String _selectType;

  List<VideoAttr> formVideoData=[];
  VideoDetail videoDetail;

  VideoAttr currentData;

  @override
  void initState() { 
    super.initState();
    
    if(!mounted) return;
    print(context.read<ApplicationStatus>().isFullscreen);
    formatData();
  }

  void formatData() async {
    await Api.getHomeVideo({
      'ac': 'videolist',
      'ids': widget.id,
      't':'',
      'pg':'',
      'wd': ''
    }).then((value) async {
      if( value != null && value.isNotEmpty ){
        final document = XmlDocument.parse(value);
        var videoData = document.findAllElements('video').toList();
        var playUrlStr = videoData[0].findElements('dl').single.findElements('dd').single.text;
        print(playUrlStr);
        print(videoData[0].findElements('name').single.text);
        print(videoData[0].findElements('pic').single.text);
        if( playUrlStr.indexOf('#') > -1 ){
          playUrlStr.split('#')..forEach((item){
            formVideoData.add(VideoAttr.fromJson({
              'title': item.split('\$')[0],
              'url': item.split('\$')[1],
              'type': item.split('\$')[2],
            }));
          });
        } else {
          formVideoData.add(VideoAttr.fromJson({
            'title': playUrlStr.split('\$')[0],
            'url': playUrlStr.split('\$')[1],
            'type': playUrlStr.split('\$')[2],
          }));
        }
        print(formVideoData);
        setState(() {
          currentData = formVideoData[0];
          title = videoData[0].findElements('name').single.text;
        });
      }
        // String playUrlStr = XmlCdata.fromString(xmlDocument.getElement('dd').text).value;

        // List<VideoAttr> formVideoData = [];
        // if( playUrlStr.indexOf('#') > -1 ){
        //   playUrlStr.split('#')..forEach((item){
        //     formVideoData.add(VideoAttr.fromJson({
        //       'title': item.split('\$')[0],
        //       'url': item.split('\$')[1]
        //     }));
        //   });
        // }
        // setState(() {
        //   playCurrentUrl = "https://youku.cdn7-okzy.com/20200530/19802_7ff6f2f4/index.m3u8";//formVideoData[0].url;
        //   videoData = formVideoData;
        //   videoDetail = VideoDetail.fromJson({
        //     'vod_name': XmlCdata.fromString(xmlDocument.getElement('name').text).value,
        //     'vod_id': xmlDocument.getElement('id').text.intParse,
        //     'type_id': xmlDocument.getElement('tid').text.intParse,
        //     'type': xmlDocument.getElement('type').text,
        //     'last': xmlDocument.getElement('last').text,
        //     'vod_remarks': XmlCdata.fromString(xmlDocument.getElement('note').text).value,
        //     'vod_vod_director': XmlCdata.fromString(xmlDocument.getElement('director').text).value,
        //     'vod_actor': XmlCdata.fromString(xmlDocument.getElement('actor').text).value,
        //     'vod_content': XmlCdata.fromString(xmlDocument.getElement('des').text).value,
        //   });
        //   loadStatus = LoadStatus.SUCCESS;
        // });
        // if( formVideoData.length > 0){
        //   await controller.setNetworkDataSource(
        //     playCurrentUrl,
        //     // 'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
        //     // 'rtmp://172.16.100.245/live1',
        //     // 'https://www.sample-videos.com/video123/flv/720/big_buck_bunny_720p_10mb.flv',
        //     // "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
        //     // 'http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8',
        //     // "file:///sdcard/Download/Sample1.mp4",
        //     autoPlay: false
        //   );
        //   key.currentState.fullScreen();
        //   IjkManager.setLandScape();
        // }
      });
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            height: ScreenUtil.getInstance().getSp(260),
            child: Container(
              alignment: Alignment.center,
              color: Colors.black,
              child: VideoPlayPage(title: title ?? '', url: currentData?.url ?? '')
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + ScreenUtil.getInstance().getSp(260),
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  titleItem(left: "选集", right: "${currentData?.title ?? ''}", leftIcon: Icons.filter_list, rightSize: 10, rightIcon: Icons.arrow_forward_ios, index: 2),
                ],
              )
            )
          ),
        ],
      ),
    );
  }

  Widget titleItem({String left, String right, IconData leftIcon, IconData rightIcon, double rightSize = 15, Color rightColor = Colors.grey, int index = 0 }) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 10,
          right: 10
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  leftIcon
                ),
                Text(
                  '$left',
                  style: TextStyle(
                    fontSize: 15 
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                right != null && right.isNotEmpty ? Text(
                  '$right',
                  style: TextStyle(
                    fontSize: rightSize,
                    color: rightColor
                  ),
                ) : Container(),
                rightIcon != null && rightIcon is IconData ? Icon(
                  rightIcon,
                  size: 16,
                ) : Container(),
              ],
            )
          ],
        ),
      ),
      onTap: () {
        if( index == 2 ){
          showBottomSheet(formVideoData);
        }
      },
    );
  }

  void showBottomSheet( List data ){
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          side: BorderSide(
          color: Color(0xFFF9F3FF), 
          style: BorderStyle.solid, width: 2
        )
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:(stateContext, state) {
            return SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil.getInstance().getWidth(10)
              ),
              child: 
              // Wrap(
              //   spacing: 5,
              //   runSpacing: 5,
              //   children: data.map((item){
              //     return OutlineButton(
              //       onPressed: () async {
              //         print('源');
              //         setState(() {
              //           playCurrentUrl = item.url;
              //         });
              //         Navigator.of(context).pop();
              //       },
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.all( Radius.circular(6) ),
              //       ),
              //       borderSide: BorderSide(
              //         color: playCurrentUrl == item.url ? Theme.of(context).primaryColor : Colors.grey,
              //         style: BorderStyle.solid, 
              //         width: 1
              //       ),
              //       child: Text(
              //         '${item.title}',
              //         textAlign: TextAlign.center,
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //     ); 
              //   }).toList(),
              // ),
              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 5,
                  left: 1,
                  right: 1,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 2.2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                // physics: NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index){
                  return OutlineButton(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2
                    ),
                    onPressed: () async {
                      print('源${index+1}');
                      setState(() {
                        currentData = formVideoData[index];
                      });
                      Navigator.of(context).pop();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all( Radius.circular(6) ),
                    ),
                    borderSide: BorderSide(
                      color: currentData.url == formVideoData[index].url ? Theme.of(context).primaryColor : Colors.grey,
                      style: BorderStyle.solid, 
                      width: 1
                    ),
                    child: Text(
                      '${formVideoData[index].title}',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        });
      },
    );
  }

}
