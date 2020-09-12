// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_attr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoAttr _$VideoAttrFromJson(Map<String, dynamic> json) {
  return VideoAttr(
    json['title'] as String,
    json['url'] as String,
    json['type'] as String,
  );
}

Map<String, dynamic> _$VideoAttrToJson(VideoAttr instance) => <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'type': instance.type,
    };

VideoSearch _$VideoSearchFromJson(Map<String, dynamic> json) {
  return VideoSearch(
    json['name'] as String,
    json['id'] as String,
    json['tid'] as String,
    json['type'] as String,
    json['last'] as String,
    json['note'] as String,
  );
}

Map<String, dynamic> _$VideoSearchToJson(VideoSearch instance) => <String, dynamic>{
      'title': instance.name,
      'id': instance.id,
      'tid': instance.tid,
      'type': instance.type,
      'last': instance.last,
      'note': instance.note,
    };