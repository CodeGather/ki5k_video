/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-07 13:56:14
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-08 09:30:09
 * @Description: 
 */
import 'package:json_annotation/json_annotation.dart';

part 'tab_list.g.dart';

List<VideoType> getVideoTabList(List<dynamic> list) {
  List<VideoType> result = [];
  list.forEach((item) {
    result.add(VideoType.fromJson(item));
  });
  return result;
}



@JsonSerializable()
  class VideoType extends Object {

  @JsonKey(name: 'type_id')
  String typeId;

  @JsonKey(name: 'type_name')
  String typeName;

  VideoType(this.typeId,this.typeName,);

  factory VideoType.fromJson(Map<String, dynamic> srcJson) => _$VideoTypeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VideoTypeToJson(this);
}