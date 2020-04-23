/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-07 13:56:14
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-14 20:35:23
 * @Description: 
 */
import 'package:json_annotation/json_annotation.dart'; 
  
part 'video_attr.g.dart';

List<VideoAttr> getVideoAttrList(List<dynamic> list){
  List<VideoAttr> result = [];
  list.forEach((item){
    result.add(VideoAttr.fromJson(item));
  });
  return result;
}

@JsonSerializable()
  class VideoAttr extends Object {

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'url')
  String url;

  VideoAttr(this.title,this.url,);

  factory VideoAttr.fromJson(Map<String, dynamic> srcJson) => _$VideoAttrFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VideoAttrToJson(this);
}