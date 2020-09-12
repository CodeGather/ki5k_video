// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoType _$VideoTypeFromJson(Map<String, dynamic> json) {
  return VideoType(
    json['type_id'] as String,
    json['type_name'] as String,
  );
}

Map<String, dynamic> _$VideoTypeToJson(VideoType instance) => <String, dynamic>{
      'type_id': instance.typeId,
      'type_name': instance.typeName,
    };
