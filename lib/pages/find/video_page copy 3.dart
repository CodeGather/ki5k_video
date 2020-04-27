// import 'package:chewie/chewie.dart';
// import 'package:flustars/flustars.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:jokui_video/models/video_attr.dart';
// import 'package:jokui_video/models/video_detail.dart';
// import 'package:jokui_video/utils/request.dart';
// import 'package:jokui_video/utils/utils.dart';
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
//   ChewieController _videoController;
//   VideoPlayerController _videoPlayerController1;
  
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
//     HTTPTOOL.loadList(widget.url, success: (data) async {
//       // print(data);
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

//       _videoPlayerController1 = VideoPlayerController.network( data['videoUrl'] );

//       _videoController = ChewieController(
//         videoPlayerController: _videoPlayerController1,
//         aspectRatio: 3 / 2,
//         autoPlay: true,
//         looping: true,
//         // Try playing around with some of these other options:

//         // showControls: false,
//         materialProgressColors: ChewieProgressColors(
//           playedColor: Colors.red,
//           handleColor: Colors.blue,
//           backgroundColor: Colors.grey,
//           bufferedColor: Colors.lightGreen,
//         ),
//         placeholder: Container(
//           color: Colors.grey,
//         ),
//         autoInitialize: true,
//       );
//       // _controller.initialize().then((_) => setState(() {}));
//       // _controller.play();
//     }
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
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
//                   color: Colors.black,
//                   child: _videoController != null ? Stack(
//                     alignment: Alignment.bottomCenter,
//                     children: <Widget>[
//                       Chewie(
//                         controller: _videoController,
//                       )
//                     ],
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
//                         itemCount: 2,
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
//                     titleItem(left: "播放源", right: "如果播放失败请更换播放源", leftIcon: Icons.video_call, rightSize: 10),
//                     // 播放源列表
//                     Container(
//                       child: GridView.builder(
//                         shrinkWrap: true,
//                         padding: EdgeInsets.only(
//                           top: 10,
//                           bottom: 5,
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
//                         itemCount: 4,
//                         itemBuilder: (BuildContext context, int index){
//                           return OutlineButton(
//                             onPressed: (){
//                               print('源${index+1}');
//                             },
//                             child: Text(
//                               '源${index+1}',
//                               style: TextStyle(
//                                 color: Colors.red
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     // 选集
//                     titleItem(left: "选集", right: "${videoDetail?.anthology}", leftIcon: Icons.filter_list, rightSize: 10, rightIcon: Icons.arrow_forward_ios),
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
//                                 borderRadius: BorderRadius.all( Radius.circular(6) ),
//                                 side: BorderSide(
//                                   color: true ? Theme.of(context).primaryColor : Colors.grey,
//                                   style: BorderStyle.solid, 
//                                   width: 1
//                                 )
//                               ),
//                               onPressed: () async {
//                                 print('${videoDetail?.list[index].url}');
//                                 setState(() {
//                                   // editingController.text = videoDetail?.list[index].url;
//                                 });
//                               },
//                             child: Text('${videoDetail?.list[index].title}')
//                             )
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
//             child: Text('${status == LoadStatus.ERROR ? '视频加载失败！':'加载中...'}'),
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
