// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoList _$VideoListFromJson(Map<String, dynamic> json) {
  return VideoList(
    json['id'] as int,
    json['detail_image'] as String,
    json['title'] as String,
    json['starring'] as String,
    json['alias_name'] as String,
    json['update_des'] as String,
    json['director'] as String,
    json['type'] as String,
    json['update_time'] as String,
    json['region'] as String,
    json['language'] as String,
    json['video_time'] as String,
    json['play_count'] as int,
    json['today_play_count'] as int,
    json['scope'] as int,
    json['scope_count'] as int,
    json['introduction'] as String,
  );
}

Map<String, dynamic> _$VideoListToJson(VideoList instance) => <String, dynamic>{
      'id': instance.id,
      'detail_image': instance.detailImage,
      'title': instance.title,
      'starring': instance.starring,
      'alias_name': instance.aliasName,
      'update_des': instance.updateDes,
      'director': instance.director,
      'type': instance.type,
      'update_time': instance.updateTime,
      'region': instance.region,
      'language': instance.language,
      'video_time': instance.videoTime,
      'play_count': instance.playCount,
      'today_play_count': instance.todayPlayCount,
      'scope': instance.scope,
      'scope_count': instance.scopeCount,
      'introduction': instance.introduction,
    };


VideoType _$VideoTypeFromJson(Map<String, dynamic> json) {
  return VideoType(
    json['id'] as int,
    json['name'] as String,
  );
}

Map<String, dynamic> _$VideoTypeToJson(VideoType instance) => <String, dynamic>{
      'id': instance.id,
      'detail_image': instance.name
    };
