// /* 
//  * @Author: 21克的爱情
//  * @Date: 2020-04-15 11:31:02
//  * @Email: raohong07@163.com
//  * @LastEditors: 21克的爱情
//  * @LastEditTime: 2020-04-15 13:50:32
//  * @Description: 视频底部bar部分
//  */

// import 'package:flustars/flustars.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoBar extends StatefulWidget {
//   VideoPlayerController controller;
//   VideoBar({Key key, this.controller}) : super(key: key);

//   @override
//   _VideoBarState createState() => _VideoBarState();
// }

// class _VideoBarState extends State<VideoBar> {
//   VideoPlayerController get controller => widget.controller;
//   final GlobalKey globalKey = GlobalKey();
//   double dx = 0.0;


//   VoidCallback listener;
//   _VideoBarState() {
//     listener = () {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     };
//   }

//   @override
//   void initState() { 
//     super.initState();
//     controller.addListener(listener);
//   }

//   @override
//   void deactivate() {
//     controller.removeListener(listener);
//     super.deactivate();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final int duration = controller?.value?.duration?.inMilliseconds;
//     final int position = controller?.value?.position?.inMilliseconds;
//     print('$duration----$position');
//     return Row(
//       children: <Widget>[
//         IconButton(
//           icon: Icon(
//             Icons.play_arrow,
//             color: Theme.of(context).accentIconTheme.color,
//             size: ScreenUtil.getInstance().getSp(30),
//           ), 
//           onPressed: (){
//             print('播放');
//           }
//         ),
//         Container(
//           padding: EdgeInsets.only(
//             right: 10
//           ),
//           child: Text(
//             '1:2:2/',
//             style: TextStyle(
//               color: Theme.of(context).accentColor
//             ),
//           ),
//         ),
//         Expanded(
//           child: Stack(
//             children: <Widget>[
//               new ClipRRect(
//                 borderRadius: BorderRadius.circular(50),
//                 child: LinearProgressIndicator(
//                   value: 0.9,
//                   valueColor: new AlwaysStoppedAnimation<Color>(Colors.white24),
//                   backgroundColor: Colors.transparent,
//                 ),
//               ),
//               GestureDetector(
//                 onPanStart: (DragStartDetails data) async {
//                   print(data.localPosition.dx);
//                   print(globalKey.currentContext.size.width);
//                   print( data.localPosition.dx / globalKey.currentContext.size.width );
//                   Duration videoPosition = await controller?.position ?? Duration() ;
//                   setState(() {
//                     dx = data.localPosition.dx;
//                     controller?.seekTo( videoPosition * ( data.localPosition.dx / globalKey.currentContext.size.width ) );
//                   });
//                 },
//                 child: new ClipRRect(
//                   borderRadius: BorderRadius.circular(50),
//                   child: LinearProgressIndicator(
//                     key: globalKey,
//                     value: 0.5,
//                     backgroundColor: Colors.white10,
//                   ),
//                 ),
//               ),
//             ], 
//           ),
//         ),
//         IconButton(
//           icon: Icon(
//             Icons.fullscreen,
//             color: Theme.of(context).accentIconTheme.color,
//             size: ScreenUtil.getInstance().getSp(30),
//           ),
//           onPressed: (){
//             print('全屏');
//           }
//         ),
//       ], 
//     );
//   }
// }