/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-14 15:53:13
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-14 16:23:31
 * @Description: 
 */
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_attr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoAttr _$VideoAttrFromJson(Map<String, dynamic> json) {
  return VideoAttr(
    json['title'] as String,
    json['url'] as String,
  );
}

Map<String, dynamic> _$VideoAttrToJson(VideoAttr instance) => <String, dynamic>{
      'title': instance.title,
      'url': instance.url
    };
