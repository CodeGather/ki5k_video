/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-07 13:56:14
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-15 15:43:00
 * @Description: 
 */
import 'package:jokui_video/models/video_attr.dart';
import 'package:json_annotation/json_annotation.dart'; 
  
part 'video_detail.g.dart';

@JsonSerializable()
  class VideoDetail extends Object {

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'anthology')
  String anthology;

  @JsonKey(name: 'synopsis')
  String synopsis;

  // 选集
  @JsonKey(name: 'list')
  List<VideoAttr> list;

  // 播放源
  @JsonKey(name: 'playList')
  List<VideoAttr> playList;

  // 线路
  @JsonKey(name: 'circuitList')
  List<VideoAttr> circuitList;

  VideoDetail(this.title,this.url,this.anthology,this.synopsis,this.list,this.playList,this.circuitList,);

  factory VideoDetail.fromJson(Map<String, dynamic> srcJson) => _$VideoDetailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VideoDetailToJson(this);
}