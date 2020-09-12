/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-07 13:56:14
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-07 16:57:13
 * @Description: 
 */
import 'package:json_annotation/json_annotation.dart';

part 'origin.g.dart';

@JsonSerializable()
class Origin extends Object {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'url')
  String url;

  Origin(this.name, this.url);

  factory Origin.fromJson(Map<String, dynamic> srcJson) =>_$OriginFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OriginToJson(this);
}
