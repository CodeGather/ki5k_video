// import 'package:flustars/flustars.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:jokui_video/models/video_attr.dart';
// import 'package:jokui_video/models/video_detail.dart';
// import 'package:jokui_video/plugins/videoPlugin/videoPlugin.dart';
// import 'package:jokui_video/provide/application_provide.dart';
// import 'package:jokui_video/utils/request.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:xml_parser/xml_parser.dart';

// class HomeVideoPage extends StatefulWidget {
//   final String url;
//   HomeVideoPage(this.url, {Key key}):super(key: key);
//   @override
//   _HomeVideoPageState createState() => _HomeVideoPageState();
// }

// enum LoadStatus{
//   ERROR,
//   SUCCESS,
//   LOADING,
//   COMPLETE
// }

// class _HomeVideoPageState extends State<HomeVideoPage> with SingleTickerProviderStateMixin{
//   VideoPlayerController _controller;
//   double videoAspectRatio = 1.5;
//   double dx=0.0;
//   double dy=0.0;
  
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
//         // }, {
//         //   "title": "线路2",
//         //   "url": "http://v.yhgou.cc/2019/api.php",
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
//           videoAspectRatio = _controller.value.aspectRatio;
//         });
//       })
//       ..setLooping(false)
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
//     ApplicationStatus fullScreenStatus = Provider.of<ApplicationStatus>(context);
//     return Scaffold(
//       body: Container(
//         color: Colors.white,
//         child:  Column(
//           children: <Widget>[
//             Stack(
//               children: <Widget>[
//                 Container(
//                   height: fullScreenStatus.isFullScreen ? MediaQuery.of(context).size.height : 280,
//                   width: double.infinity,
//                   color: Colors.black,
//                   child: (_controller?.value?.duration?.inSeconds ?? 0) > 1 ? AspectRatio(
//                     aspectRatio: MediaQuery.of(context).size.width/MediaQuery.of(context).size.height,
//                     child: Stack(
//                       alignment: Alignment.bottomCenter,
//                       children: <Widget>[
//                         VideoPlayer(_controller),
//                         Stack(
//                           children: <Widget>[
//                             AnimatedSwitcher(
//                               duration: Duration(milliseconds: 50),
//                               reverseDuration: Duration(milliseconds: 200),
//                               child: _controller.value.isPlaying
//                                   ? SizedBox.shrink()
//                                   : Center(
//                                     child: Container(
//                                       width: 60,
//                                       height: 60,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(50),
//                                         color: Colors.white54,
//                                       ),
//                                       child: Center(
//                                         child: Icon(
//                                           Icons.play_arrow,
//                                           color: Colors.white,
//                                           size: 50.0,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _controller.value.isPlaying ? _controller.pause() : _controller.play();
//                                 });
//                                 ApplicationStatus fullScreen = Provider.of<ApplicationStatus>(context, listen: false);
//                                 fullScreen.clickTime = DateTime.now().millisecondsSinceEpoch;
//                               },
//                               onVerticalDragUpdate: (DragUpdateDetails data) async {
//                                 print(data.localPosition);
//                                 int height = fullScreenStatus.isFullScreen ? MediaQuery.of(context).size.height : 280;
//                                 if( data.localPosition.dx < MediaQuery.of(context).size.width / 2 ){  // 亮度调整
//                                   double light = (height - data.localPosition.dy) / height;
//                                   print(_controller.value.volume);
//                                   await _controller.setVolume(light);
//                                 } else { // 音量调整
//                                   // Duration position = _controller.value.duration * aspectRatio;
//                                   // await _controller.seekTo(position);
//                                 }
//                               },
//                               onHorizontalDragStart: (DragStartDetails data){
//                                 setState(() {
//                                   dx = data.localPosition.dx;
//                                 });
//                               },
//                               onHorizontalDragUpdate: (DragUpdateDetails data ) async {
//                                 // 计算滑动的比例
//                                 double aspectRatio = data.localPosition.dx / MediaQuery.of(context).size.width;
//                                 // // 获取当前时间
//                                 // DateTime time = DateTime.now();
//                                 // // 获取视频总时间
//                                 // Duration videoDuration = _controller.value.duration;
//                                 // // 获取当前时间戳
//                                 // int nowTime = time.millisecondsSinceEpoch;
//                                 // // 获取视频的时间戳
//                                 // int lastTime = time.add(videoDuration).millisecondsSinceEpoch;
//                                 // // 计算后的时间 ----->> (当前时间 + (视频时间-当前时间)*屏幕比)
//                                 // DateTime computeTime = DateTime.fromMillisecondsSinceEpoch(nowTime + ((lastTime-nowTime)*aspectRatio).floor());
//                                 // // 计算两个时间的差值
//                                 // Duration videoPosition = computeTime.difference(time);
//                                 // print('-------${videoPosition}');
//                                 // await _controller.seekTo(videoPosition);
                                

//                                 Duration position = _controller.value.duration * aspectRatio;
//                                 await _controller.seekTo(position);
                                
//                                 setState(() {
//                                   dx = data.localPosition.dx;
//                                 });
//                               },
//                               onHorizontalDragEnd: (DragEndDetails data){
//                                 print('点击-----${data}');
//                                 setState(() {
//                                   dx = 0.0;
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
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
//                 // 返回头部
//                 Positioned(
//                   top: fullScreenStatus.isFullScreen ? 0 : MediaQuery.of(context).padding.top,
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
//                           final isAndroid = Theme.of(context).platform == TargetPlatform.android;
//                           // 点击返回时是否处于全屏否则强制竖屏
//                           ApplicationStatus fullScreen = Provider.of<ApplicationStatus>(context, listen: false);
//                           if( fullScreen.isFullScreen ){
//                             if ( isAndroid ) {
//                               SystemChrome.setEnabledSystemUIOverlays([]);
//                               SystemChrome.setPreferredOrientations([
//                                 DeviceOrientation.portraitDown
//                               ]);
//                               fullScreen.cancelFullScreen();
//                             }
//                           } else {
//                             // 返回
//                             Navigator.of(context).pop();
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: loadStatus == LoadStatus.SUCCESS ? Container(
//                 padding: EdgeInsets.fromLTRB(
//                   10, 
//                   0, 
//                   10, 
//                   MediaQuery.of(context).padding.bottom
//                 ),
//                 child: ListView(
//                   padding: EdgeInsets.all(0),
//                   children: <Widget>[
//                     // 标题 -> 简介
//                     titleItem(left: videoDetail?.title, right: "简介", leftIcon: Icons.title, rightIcon: Icons.arrow_forward_ios),
//                     // 线路
//                     titleItem(left: "线路", right: "如果播放失败可更换线路重新加载", leftIcon: Icons.line_style, rightSize: 10),
//                     // 线路列表
//                     Container(
//                       child: GridView.builder(
//                         shrinkWrap: true,
//                         padding: EdgeInsets.only(
//                           top: 10,
//                           bottom: 1,
//                           left: 1,
//                           right: 1,
//                         ),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 5,
//                           childAspectRatio: 2,
//                           crossAxisSpacing: 10,
//                           mainAxisSpacing: 10,
//                         ),
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: apiData.length,
//                         itemBuilder: (BuildContext context, int index){
//                           return OutlineButton(
//                             onPressed: (){
//                               print('源${apiData[index]?.url}');
//                               SpUtil.putString( "api", apiData[index]?.url );
//                               print('源${SpUtil.getString('api')}');
//                             },
//                             child: Text(
//                               '${apiData[index]?.title}',
//                               style: TextStyle(
//                                 color: Colors.red,
//                                 fontSize: ScreenUtil.getInstance().getSp(10)
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     // 播放源
//                     // titleItem(left: "播放源", right: "如果播放失败请更换播放源", leftIcon: Icons.video_call, rightSize: 10),
//                     // 播放源列表
//                     // Container(
//                     //   child: GridView.builder(
//                     //     shrinkWrap: true,
//                     //     padding: EdgeInsets.only(
//                     //       top: 10,
//                     //       bottom: 5,
//                     //       left: 1,
//                     //       right: 1,
//                     //     ),
//                     //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     //       crossAxisCount: 5,
//                     //       childAspectRatio: 2,
//                     //       crossAxisSpacing: 10,
//                     //       mainAxisSpacing: 10,
//                     //     ),
//                     //     physics: NeverScrollableScrollPhysics(),
//                     //     itemCount: 4,
//                     //     itemBuilder: (BuildContext context, int index){
//                     //       return OutlineButton(
//                     //         onPressed: (){
//                     //           print('源${index+1}');
//                     //         },
//                     //         child: Text(
//                     //           '源${index+1}',
//                     //           style: TextStyle(
//                     //             color: Colors.red
//                     //           ),
//                     //         ),
//                     //       );
//                     //     },
//                     //   ),
//                     // ),
//                     // 选集
//                     titleItem(left: "选集", right: "${videoDetail?.anthology}", leftIcon: Icons.filter_list, rightSize: 10, rightIcon: Icons.arrow_forward_ios, index: 2),
//                     // 选集列表
//                     Container(
//                       height: 50,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: videoDetail?.list?.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return Container(
//                               alignment: Alignment.center,
//                               margin: EdgeInsets.symmetric(
//                                 horizontal: 10
//                               ),
//                               child: FlatButton(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.all( Radius.circular(6) ),
//                                   side: BorderSide(
//                                     color: videoDetail?.url == videoDetail?.list[index].url ? Theme.of(context).primaryColor : Colors.grey,
//                                     style: BorderStyle.solid, 
//                                     width: 1
//                                   )
//                                 ),
//                                 onPressed: () async {
//                                   print('${videoDetail?.list[index].url}');
//                                   setState(() {
//                                     // 先暂停在继续移除监听
//                                     _controller.pause();
//                                     _controller.removeListener((){});

//                                     // 重新设置video
//                                     _controller = VideoPlayerController.network(
//                                       videoDetail?.list[index].url,
//                                       closedCaptionFile: _loadCaptions(),
//                                     )
//                                     ..initialize().then((_){
//                                       print(_controller.value.aspectRatio);
//                                       setState(() {
//                                         videoDetail.url = videoDetail?.list[index].url;
//                                         videoAspectRatio = _controller.value.aspectRatio;
//                                       });
//                                     })
//                                     ..addListener(() {
//                                       // print('---${_controller}');
//                                     })
//                                     ..setLooping(false)
//                                     ..play();
//                                   });
//                                 },
//                                 child: Text('${videoDetail?.list[index].title}',
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     // 标题 -> 简介
//                     titleItem(left: '简介', leftIcon: Icons.assignment,),
//                     Container(
//                       child: Text(
//                         '${videoDetail?.synopsis}',
//                         textAlign: TextAlign.justify,
//                         style: TextStyle(
//                           fontSize: 15 
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ) : statusWidget(loadStatus),
//             ),
//           ]
//         ),
//       ),
//     );
//   }

//   void showBottomSheet( List data ){
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
//           side: BorderSide(
//           color: Color(0xFFF9F3FF), 
//           style: BorderStyle.solid, width: 2
//         )
//       ),
//       builder: (BuildContext context) {
//         return Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: ScreenUtil.getInstance().getWidth(10)
//           ),
//           child: GridView.builder(
//             shrinkWrap: true,
//             padding: EdgeInsets.only(
//               top: 10,
//               bottom: 5,
//               left: 1,
//               right: 1,
//             ),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 4,
//               childAspectRatio: 2.2,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//             ),
//             // physics: NeverScrollableScrollPhysics(),
//             itemCount: data.length,
//             itemBuilder: (BuildContext context, int index){
//               return OutlineButton(
//                 onPressed: (){
//                   print('源${index+1}');
//                 },
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all( Radius.circular(6) ),
//                 ),
//                 borderSide: BorderSide(
//                   color: videoDetail?.url == videoDetail?.list[index].url ? Theme.of(context).primaryColor : Colors.grey,
//                   style: BorderStyle.solid, 
//                   width: 1
//                 ),
//                 child: Text(
//                   '${videoDetail?.list[index].title}',
//                 ),
//               );
//             },
//           ),
//         );
//       },
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

//   Widget titleItem({String left, String right, IconData leftIcon, IconData rightIcon, double rightSize = 15, Color rightColor = Colors.grey, int index =0 }) {
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
//           InkWell(
//             child: Row(
//               children: <Widget>[
//                 right != null && right.isNotEmpty ? Text(
//                   '$right',
//                   style: TextStyle(
//                     fontSize: rightSize,
//                     color: rightColor
//                   ),
//                 ) : Container(),
//                 rightIcon != null && rightIcon is IconData ? Icon(
//                   rightIcon,
//                   size: 16,
//                 ) : Container(),
//               ],
//             ),
//             onTap: () {
//               if( index == 2 ){
//                 showBottomSheet(videoDetail?.list);
//               }
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
