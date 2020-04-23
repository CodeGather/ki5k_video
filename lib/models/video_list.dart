/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-07 13:56:14
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-07 16:56:02
 * @Description: 
 */
import 'package:json_annotation/json_annotation.dart'; 
  
part 'video_list.g.dart';


List<VideoList> getVideoListList(List<dynamic> list){
    List<VideoList> result = [];
    list.forEach((item){
      result.add(VideoList.fromJson(item));
    });
    return result;
  }
List<VideoType> getVideoTypeList(List<dynamic> list){
    List<VideoType> result = [];
    list.forEach((item){
      result.add(VideoType.fromJson(item));
    });
    return result;
  }
@JsonSerializable()
  class VideoList extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'detail_image')
  String detailImage;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'starring')
  String starring;

  @JsonKey(name: 'alias_name')
  String aliasName;

  @JsonKey(name: 'update_des')
  String updateDes;

  @JsonKey(name: 'director')
  String director;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'update_time')
  String updateTime;

  @JsonKey(name: 'region')
  String region;

  @JsonKey(name: 'language')
  String language;

  @JsonKey(name: 'video_time')
  String videoTime;

  @JsonKey(name: 'play_count')
  int playCount;

  @JsonKey(name: 'today_play_count')
  int todayPlayCount;

  @JsonKey(name: 'scope')
  int scope;

  @JsonKey(name: 'scope_count')
  int scopeCount;

  @JsonKey(name: 'introduction')
  String introduction;

  VideoList(this.id,this.detailImage,this.title,this.starring,this.aliasName,this.updateDes,this.director,this.type,this.updateTime,this.region,this.language,this.videoTime,this.playCount,this.todayPlayCount,this.scope,this.scopeCount,this.introduction,);

  factory VideoList.fromJson(Map<String, dynamic> srcJson) => _$VideoListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VideoListToJson(this);

}

  

@JsonSerializable()
  class VideoType extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  VideoType(this.id,this.name,);

  factory VideoType.fromJson(Map<String, dynamic> srcJson) => _$VideoTypeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VideoTypeToJson(this);
}