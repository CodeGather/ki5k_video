/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-14 15:53:13
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-15 15:41:38
 * @Description: 
 */
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoDetail _$VideoDetailFromJson(Map<String, dynamic> json) {
  return VideoDetail(
    json['title'] as String,
    json['url'] as String,
    json['anthology'] as String,
    json['synopsis'] as String,
    (json['list'] as List)?.map((e) => e == null ? null : VideoAttr.fromJson(e as Map<String, dynamic>))?.toList(),
    (json['playList'] as List)?.map((e) => e == null ? null : VideoAttr.fromJson(e as Map<String, dynamic>))?.toList(),
    (json['circuitList'] as List)?.map((e) => e == null ? null : VideoAttr.fromJson(e as Map<String, dynamic>))?.toList(),
  );
}

Map<String, dynamic> _$VideoDetailToJson(VideoDetail instance) => <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'anthology': instance.anthology,
      'synopsis': instance.synopsis,
      'list': instance.list,
      'playList': instance.playList,
      'circuitList': instance.circuitList
    };
