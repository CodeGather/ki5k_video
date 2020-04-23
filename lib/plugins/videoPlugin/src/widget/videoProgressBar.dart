// /* 
//  * @Author: 21克的爱情
//  * @Date: 2020-04-15 11:31:02
//  * @Email: raohong07@163.com
//  * @LastEditors: 21克的爱情
//  * @LastEditTime: 2020-04-15 21:43:30
//  * @Description: 视频底部bar部分
//  */

// import 'package:flustars/flustars.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:jokui_video/provide/application_provide.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';

// class VideoProgressBar extends StatefulWidget {
//   /// Construct an instance that displays the play/buffering status of the video
//   /// controlled by [controller].
//   ///
//   /// Defaults will be used for everything except [controller] if they're not
//   /// provided. [allowScrubbing] defaults to false, and [padding] will default
//   /// to `top: 5.0`.
//   VideoProgressBar(
//     this.controller, {
//     VideoProgressColors colors,
//     this.allowScrubbing,
//     this.padding = const EdgeInsets.only(top: 5.0),
//   }) : colors = colors ?? VideoProgressColors();

//   /// The [VideoPlayerController] that actually associates a video with this
//   /// widget.
//   final VideoPlayerController controller;

//   /// The default colors used throughout the indicator.
//   ///
//   /// See [VideoProgressColors] for default values.
//   final VideoProgressColors colors;

//   /// When true, the widget will detect touch input and try to seek the video
//   /// accordingly. The widget ignores such input when false.
//   ///
//   /// Defaults to false.
//   final bool allowScrubbing;

//   /// This allows for visual padding around the progress indicator that can
//   /// still detect gestures via [allowScrubbing].
//   ///
//   /// Defaults to `top: 5.0`.
//   final EdgeInsets padding;

//   @override
//   _VideoProgressBarState createState() => _VideoProgressBarState();
// }

// class _VideoProgressBarState extends State<VideoProgressBar> {
//   // 视频加载监听
//   _VideoProgressBarState() {
//     listener = () {
//       if (!mounted) {
//         return;
//       }
//       // print(controller.value.position.inMilliseconds);
//       // print(controller.value.position.inSeconds);
//       // print(controller.value.position.inMicroseconds);
//       setState(() {
//       });
//     };
//   }

//   VoidCallback listener;

//   VideoPlayerController get controller => widget.controller;

//   VideoProgressColors get colors => widget.colors;

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
//     Widget progressIndicator;
//     ApplicationStatus fullScreenStatus = Provider.of<ApplicationStatus>(context);
    
//     if (controller.value.initialized) {
//       final int duration = controller.value.duration.inMilliseconds;
//       final int position = controller.value.position.inMilliseconds;

//       int maxBuffering = 0;
//       for (DurationRange range in controller.value.buffered) {
//         final int end = range.end.inMilliseconds;
//         if (end > maxBuffering) {
//           maxBuffering = end;
//         }
//       }

//       progressIndicator = Stack(
//         fit: StackFit.passthrough,
//         children: <Widget>[
//           new ClipRRect(
//             borderRadius: BorderRadius.circular(50),
//             child:LinearProgressIndicator(
//               value: maxBuffering / duration,
//               valueColor: AlwaysStoppedAnimation<Color>(colors.bufferedColor),
//               backgroundColor: colors.backgroundColor,
//             ),
//           ),
//           new ClipRRect(
//             borderRadius: BorderRadius.circular(50),
//             child:LinearProgressIndicator(
//               value: position / duration,
//               valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
//               backgroundColor: Colors.transparent,
//             ),
//           ),
//         ],
//       );
//     } else {
//       progressIndicator = LinearProgressIndicator(
//         value: null,
//         valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
//         backgroundColor: colors.backgroundColor,
//       );
//     }
//     // print('--${fullScreenStatus.clickTime}--');
//     // print('++${DateTime.now().millisecondsSinceEpoch - 10000}++');
//     // print('==${fullScreenStatus.clickTime > (DateTime.now().millisecondsSinceEpoch - 10000)}==');

//     final Widget paddedProgressIndicator = Opacity(
//       opacity: ( fullScreenStatus.clickTime > (DateTime.now().millisecondsSinceEpoch - 10000) )? 1 : 0, //  ||  && controller.value.isPlaying 
//       child: Row(
//         children: <Widget>[
//           IconButton(
//             icon: Icon(
//               controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//               color: Theme.of(context).accentIconTheme.color,
//               size: 30,
//             ), 
//             onPressed: (){
//               print('播放');
//               controller.value.isPlaying ? controller.pause() : controller.play();
//             }
//           ),
//           Container(
//             padding: EdgeInsets.only(
//               right: 10
//             ),
//             child: Text(
//               '${controller?.value?.position?.toString()?.split('.')[0]}',
//               style: TextStyle(
//                 color: Theme.of(context).accentColor
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               child:progressIndicator,
//             ),
//           ),
//           IconButton(
//             icon: Icon(
//               fullScreenStatus.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
//               color: Theme.of(context).accentIconTheme.color,
//               size: 30,
//             ),
//             onPressed: (){
//               print('全屏');
//               final isAndroid = Theme.of(context).platform == TargetPlatform.android;
//               SystemChrome.setEnabledSystemUIOverlays([]);
//               ApplicationStatus fullScreen = Provider.of<ApplicationStatus>(context, listen: false);
//               if ( isAndroid ) {
//                 if( fullScreen.isFullScreen ){
//                   SystemChrome.setPreferredOrientations([
//                     DeviceOrientation.portraitDown
//                   ]);
//                   fullScreen.cancelFullScreen();
//                 } else {
//                   SystemChrome.setPreferredOrientations([
//                     DeviceOrientation.landscapeLeft,
//                     DeviceOrientation.landscapeRight,
//                   ]);
//                   fullScreen.enterFullScreen();
//                 }
//               }
//             }
//           ),
//         ], 
//       ), 
//     );
//     if (widget.allowScrubbing) {
//       return _VideoScrubber(
//         child: paddedProgressIndicator,
//         controller: controller,
//       );
//     } else {
//       return paddedProgressIndicator;
//     }
//   }
// }


// class _VideoScrubber extends StatefulWidget {
//   _VideoScrubber({
//     @required this.child,
//     @required this.controller,
//   });

//   final Widget child;
//   final VideoPlayerController controller;

//   @override
//   _VideoScrubberState createState() => _VideoScrubberState();
// }

// class _VideoScrubberState extends State<_VideoScrubber> {
//   bool _controllerWasPlaying = false;

//   VideoPlayerController get controller => widget.controller;

//   @override
//   Widget build(BuildContext context) {
//     void seekToRelativePosition(Offset globalPosition) {
//       final RenderBox box = context.findRenderObject();
//       final Offset tapPos = box.globalToLocal(globalPosition);
//       final double relative = tapPos.dx / box.size.width;
//       final Duration position = controller.value.duration * relative;
//       controller.seekTo(position);
//     }
    
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       child: widget.child,
//       onHorizontalDragStart: (DragStartDetails details) {
//         if (!controller.value.initialized) {
//           return;
//         }
//         _controllerWasPlaying = controller.value.isPlaying;
//         if (_controllerWasPlaying) {
//           controller.pause();
//         }
//       },
//       onHorizontalDragUpdate: (DragUpdateDetails details) {
//         if (!controller.value.initialized) {
//           return;
//         }
//         seekToRelativePosition(details.globalPosition);
//       },
//       onHorizontalDragEnd: (DragEndDetails details) {
//         if (_controllerWasPlaying) {
//           controller.play();
//         }
//       },
//       onTapDown: (TapDownDetails details) {
//         if (!controller.value.initialized) {
//           return;
//         }
//         seekToRelativePosition(details.globalPosition);
//       },
//     );
//   }
// }