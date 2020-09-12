// /* 
//  * @Author: 21克的爱情
//  * @Date: 2020-05-27 13:07:59
//  * @Email: raohong07@163.com
//  * @LastEditors: 21克的爱情
//  * @LastEditTime: 2020-07-12 08:55:01
//  * @Description: 视频工具
//  */

// import 'package:flutter/material.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

// import 'fileUtils.dart';

// class VideoTool{
//   static VideoTool instance;
//   static FlutterFFmpegConfig ffmpegConfig;
//   static FlutterFFprobe ffprobe;
//   static FlutterFFmpeg ffmpeg;
//   static double videoDuration; // 压缩视频的大小

//   VideoTool(){
//     ffmpegConfig = new FlutterFFmpegConfig();
//     ffprobe = new FlutterFFprobe();
//     ffmpeg = new FlutterFFmpeg();
//     // 禁用日志
//     ffmpegConfig.disableLogs();
//     // _flutterFFmpegConfig.enableLogs();
//     // 处理进度
//     ffmpegConfig.enableStatistics();
//     ffmpegConfig.enableStatisticsCallback(statisticsCallback);
//   }

//   /* 
//    * @description: 日志进度
//    * @param {type} 
//    * @return: null
//    */
//   void statisticsCallback(int time, int size, double bitrate, double speed, int videoFrameNumber, double videoQuality, double videoFps) {
//     print( "VideoTool time: $time, size: $size, bitrate: $bitrate, speed: $speed, videoFrameNumber: $videoFrameNumber, videoQuality: $videoQuality, videoFps: $videoFps");
//     if( videoDuration != null ){
//       print(time / videoDuration);
//     }
//   }

//   /* 
//    * @description: 初始化数据
//    * @param {type} null
//    * @return: VideoTool
//    */
//   static VideoTool getInstance() {
//     if (instance == null) {
//       print('首次初始化');
//       instance = new VideoTool();
//     }
//     return new VideoTool();
//   }

//   /* 
//    * @description: 释放内存
//    * @param {type} null
//    * @return: null
//    */
//   static void dispost(){
//     if( ffmpegConfig != null ){
//       ffmpegConfig = null;
//     }
//     if( ffprobe != null ){
//       ffprobe = null;
//     }
//     if( instance != null ){
//       instance = null;
//     }

//     ffmpeg?.cancel();
//   }

//   // 删除文件夹，在上传完图片后进行删除操作
//   static void deleteDir(){
//     // 删除视频文件夹
//     FileUtil.getFileName('', type: false).then((dirString){
//       FileUtil.deleteFile(dirString);
//     });
//   }

//   /**
//    * @description: 格式转换成ts为可合并格式
//    * @ffmpeg的执行方法: ffmpeg -i 输入待转换视频路径 -c copy -bsf:v h264_mp4toannexb -f mpegts 待输出视频路径   -acodec copy -q:v 0 -q:a 0 
//    * @param {String path, String output} 输入待转路径， 输出待转路径
//    * @return: 
//    */
//   Future<void> mp4ToTs(String path, String output) async {
//     // int result = await _flutterFFmpeg.execute('-i ' + videoPath + ' -vf rotate=PI/2 ' + filePaths );
//     print(DateTime.now());
//     final rc = await ffmpeg.execute('-i '+ path +' -y -c:v libx264 -acodec copy -preset ultrafast ' + output );
//     print("<-${DateTime.now()}--$output------视频格式转换 $rc");
//   }

//   /* 
//    * @description: 视频合并
//    * @param {type} txt路径
//    * @ffmpeg的执行方法: ffmpeg -i concat:ts0.ts|ts1.ts|ts2.ts|ts3.ts transpose=1 -c copy -bsf:a aac_adtstoasc out2.mp4
//    * @ffmpeg的执行方法: ffmpeg -f concat -safe 0 -i $txtFilePath -c:a copy -c:v copy 
//    * @return: 视频信息
//    */
//   Future<String> mergeVideo( BuildContext context, String txtFilePath ) async {
//     String filePaths = await FileUtil.getFileName('mp4');
//     int result = await ffmpeg.execute('-f concat -safe 0 -i $txtFilePath -c:a copy -c:v copy ' + filePaths );

//     if( result != 0 ){
//       return null;
//     } else {
//       return await compressVideo(context, filePaths);
//     }
//   }

//   /* 
//    * @description: 录制视频
//    * @param {type} txt路径
//    * @ffmpeg的执行方法: ffmpeg -f android_camera -i 0:0 -r 30 -pixel_format bgr0 -t 00:00:05 
//    * @return: 视频信息
//    */
//   Future<String> recordVideo( BuildContext context ) async {
//     String filePaths = await FileUtil.getFileName('mp4');
//     int result = await ffmpeg.execute('-f android_camera -i 0:0 -r 30 -pixel_format bgr0 -t 00:00:05 $filePaths');

//     print('录制完毕------$result 路径-----$filePaths');
//     // if( result != 0 ){
//     //   return null;
//     // } else {
//     //   return await compressVideo(context, filePaths);
//     // }
//   }

//   /* 
//    * @description: 获取视频信息 
//    * @param {type} 视频路径
//    * @return: 视频信息
//    */
//   Future getVideoData(String videoPath) async {
//     // 获取视频信息
//     final info = await ffprobe.getMediaInformation(videoPath);
//     // 合并后的视频时间
//     videoDuration = info['duration'].toDouble();
//   }

//   /* 
//    * @description: 获取视频信息 ffmpeg -i test.avi -y -f image2 -ss 8 -t 0.001 -s 350x240 test.jpg
//    * @param {type} 视频路径
//    * @return: 视频信息
//    */
//   Future getVideoImage(String videoPath, {int time, int count, String name}) async {
//     String filePaths = await FileUtil.getFileName(null, type: false, round: "${DateTime.now().microsecondsSinceEpoch}");
//     name = name ?? "foo-";
//     // 获取视频信息
//     final info = await ffmpeg.execute('-i $videoPath -vf fps=1/${(time/count ?? time).toStringAsFixed(1)} -f image2 -q:v 5 ${filePaths}$name%d.jpg');
//     // 合并后的视频时间
//     print("截取图片-----------$info");
//     return {
//       "filePath": filePaths,
//       "name": name ?? "foo-",
//       "count": count ?? time
//     };
//     // videoDuration = info['duration'].toDouble();
//   }

//   /* 
//    * @description: 压缩视频
//    * @param {type} 视频路径 -c:a copy -c:v libx264 -vf transpose=0 -crf 28 -preset medium 压缩掉百分比 videoQuality
//    * @return: 返回以压缩视频的路径
//    */
//   Future<String> compressVideo( BuildContext context, String videoPath, {int videoQuality=45}) async {
//     int quality = (63 * (videoQuality / 100)).round();
//     // 设置视频时间
//     await getVideoData( videoPath );
//     // 加载进度条
//     // 获取新的视频路径
//     String filePaths = await FileUtil.getFileName('mp4');
//     // 需要旋转角度后压缩视频
//     int result = await ffmpeg.execute('-i $videoPath -c:a copy -c:v libx264 -crf $quality -preset ultrafast ' + filePaths );
//     print('压缩结果 $result----$filePaths');

//     Navigator.of(context).pop();
//     if( result != 0 ){
//       return null;
//     } else {
//       return filePaths;
//     }
//   }
// }