// import 'package:flustars/flustars.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:jokui_video/models/video_attr.dart';
// import 'package:jokui_video/models/video_detail.dart';
// import 'package:jokui_video/plugins/videoPlugin/videoPlugin.dart';
// import 'package:jokui_video/utils/request.dart';
// import 'package:video_player/video_player.dart';
// import 'package:xml_parser/xml_parser.dart';

// class FullScreenVideoPage extends StatefulWidget {
//   final String url;
//   FullScreenVideoPage(this.url, {Key key}):super(key: key);
//   @override
//   _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
// }

// enum LoadStatus{
//   ERROR,
//   SUCCESS,
//   LOADING,
//   COMPLETE
// }

// class _FullScreenVideoPageState extends State<FullScreenVideoPage> with SingleTickerProviderStateMixin{
//   VideoPlayerController _controller;
//   double aspectRatio = 1.5;
  
//   String title = '视频预览';
//   VideoDetail videoDetail;
//   List<VideoAttr> videoData = [];
//   List<VideoAttr> apiData = [];
//   TabController _tabController;
//   LoadStatus loadStatus = LoadStatus.LOADING;

//   List<Widget> get getTabItem {
//     List<Widget> list = [];
//     videoData.forEach((item) {
//       list.add(
//         Tab(
//           child: Text(
//             '${item?.title}-${_tabController.index}',
//             style: TextStyle(
//               color: Colors.red
//             )
//           ),
//         ),
//       );
//     });
//     return list;
//   }

//   @override
//   void initState() {
//     super.initState();

//     if(!mounted) return;
//     loadingData();
//   }

//   loadingData(){
//     print(widget.url);
//     HTTPTOOL.loadList(widget.url, success: (data) async {
//       if (data != null && data['movieList'] != null ){
//         formData( data );
//       } else {
//         setState(() {
//           loadStatus = LoadStatus.ERROR;
//         });
//       }
//     });
//   }

//   void formData( dynamic data ) async{
//     XmlDocument xmlDocument = XmlDocument.fromString(data['movieList']);
//     print(xmlDocument);
    
//     // 视频数据
//     XmlElement video = xmlDocument.getElement('list').getElement('video');
//     // 时间
//     String lastTime = video.getElement('last').text;
//     // 名称
//     String title = XmlCdata.fromString(video.getElement('name').text).value;
//     // 类型
//     String type = video.getElement('type').text;
//     // 描述
//     String updateDesc = XmlCdata.fromString(video.getElement('note').text).value;

//     if( data['movieDetails'] != null && data['movieDetails'].length > 0 ){
//       final dataArr = data['movieDetails'].map((item){
//         List itemMap = item.split('\$');
//         return {
//           "title": "${itemMap[0]}",
//           "url": "${itemMap[1]}",
//         };
//       }).toList();

//       print(dataArr);

//       setState(() {
//         _tabController = new TabController(vsync: this, length: dataArr.length);
//         loadStatus = LoadStatus.SUCCESS;
//         videoDetail = VideoDetail.fromJson({
//           'title': title,
//           'url': data['videoUrl'],
//           'anthology': updateDesc, // 选集
//           'synopsis': '暂无', // 简介
//           'list': dataArr
//         });
//         apiData = getVideoAttrList([ {
//           "title": "线路1",
//           "url": "https://jx.688ing.com/parse/op/play",
//         }, {
//           "title": "线路2",
//           "url": "http://v.yhgou.cc/2019/api.php",
//         }]);
//       });

//       _controller = VideoPlayerController.network(
//         data['videoUrl'],
//         closedCaptionFile: _loadCaptions(),
//       )
//       ..addListener(() {
//         // print(_controller);
//       })
//       ..initialize().then((_){
//         print(_controller.value.aspectRatio);
//         setState(() {
//           aspectRatio = _controller.value.aspectRatio;
//         });
//       })
//       ..setLooping(true)
//       ..play();
//     }
//   }

//   Future<ClosedCaptionFile> _loadCaptions() async {
//     final String fileContents = await DefaultAssetBundle.of(context).loadString('assets/bumble_bee_captions.srt');
//     return SubRipCaptionFile(fileContents);
//   }


//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.white,
//         child:  Column(
//           children: <Widget>[
//             Stack(
//               children: <Widget>[
//                 Container(
//                   height: 300,
//                   width: double.infinity,
//                   color: Colors.black,
//                   child: (_controller?.value?.duration?.inSeconds ?? 0) > 1 ? AspectRatio(
//                     aspectRatio: aspectRatio,
//                     child: Stack(
//                       alignment: Alignment.bottomCenter,
//                       children: <Widget>[
//                         VideoPlayer(_controller),
//                         _PlayPauseOverlay(controller: _controller),
//                         VideoProgressBar(
//                           _controller, 
//                           colors: VideoProgressColors(
//                             playedColor: Theme.of(context).primaryColor
//                           ), 
//                           allowScrubbing: true
//                         ),
//                       ],
//                     ),
//                   ) : statusWidget(loadStatus, type: false),
//                 ),
//                 Positioned(
//                   top: MediaQuery.of(context).padding.top,
//                   left: 0,
//                   right: 0,
//                   child: Row(
//                     children: <Widget>[
//                       IconButton(
//                         icon: Icon(
//                           Icons.arrow_back_ios,
//                         ), 
//                         color: Colors.white,
//                         onPressed: (){
//                           print('object');
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ]
//         ),
//       ),
//     );
//   }

//   Widget statusWidget( LoadStatus status, {bool type = true} ){
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           status == LoadStatus.ERROR ? Icon(
//             Icons.warning,
//             color: Colors.grey,
//             size: ScreenUtil.getInstance().getSp(60),
//           ) : CircularProgressIndicator(
//             strokeWidth: 2,
//           ),
//           type ? Container(
//             margin: EdgeInsets.only(
//               top: ScreenUtil.getInstance().getWidth(30),
//             ),
//             child: Text('${status == LoadStatus.ERROR ? '视频解析失败了\n请尝试点击其他集重新解析':'加载中...'}'),
//           ):Container()
//         ], 
//       ),
//     );
//   }

//   Widget titleItem({String left, String right, IconData leftIcon, IconData rightIcon, double rightSize = 15, Color rightColor = Colors.grey}) {
//     return Container(
//       padding: EdgeInsets.only(
//         top: 15
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               Icon(
//                 leftIcon
//               ),
//               Text(
//                 '$left',
//                 style: TextStyle(
//                   fontSize: 15 
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: <Widget>[
//               right != null && right.isNotEmpty ? Text(
//                 '$right',
//                 style: TextStyle(
//                   fontSize: rightSize,
//                   color: rightColor
//                 ),
//               ) : Container(),
//               rightIcon != null && rightIcon is IconData ? Icon(
//                 rightIcon,
//                 size: 16,
//               ) : Container(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

// }

// class _PlayPauseOverlay extends StatelessWidget {
//   const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);
  
//   final VideoPlayerController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AnimatedSwitcher(
//           duration: Duration(milliseconds: 50),
//           reverseDuration: Duration(milliseconds: 200),
//           child: controller.value.isPlaying
//               ? SizedBox.shrink()
//               : Container(
//                   color: Colors.black26,
//                   child: Center(
//                     child: Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                       size: 100.0,
//                     ),
//                   ),
//                 ),
//         ),
//         GestureDetector(
//           onTap: () {
//             controller.value.isPlaying ? controller.pause() : controller.play();
//           },
//           onHorizontalDragStart: (DragStartDetails data){
//             print('点击-----${data.localPosition.dx}');
//           },
//           onHorizontalDragUpdate: (DragUpdateDetails data ){
//             print(data.localPosition.dx);
//           },
//         ),
//       ],
//     );
//   }
// }