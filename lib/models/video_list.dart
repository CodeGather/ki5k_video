/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-07 13:56:14
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-08 11:10:55
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert' show json;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'video_attr.dart'; 
  
part 'video_list.g.dart';


void tryCatch(Function f) {
  try {
    f?.call();
  } catch (e, stack) {
    debugPrint('$e');
    debugPrint('$stack');
  }
}

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  if (value != null) {
    final String valueS = value.toString();
    if (0 is T) {
      return int.tryParse(valueS) as T;
    } else if (0.0 is T) {
      return double.tryParse(valueS) as T;
    } else if ('' is T) {
      return valueS as T;
    } else if (false is T) {
      if (valueS == '0' || valueS == '1') {
        return (valueS == '1') as T;
      }
      return bool.fromEnvironment(value.toString()) as T;
    }
  }
  return null;
}

class TuChongSource {
  TuChongSource({
    this.counts,
    this.feedList,
    this.isHistory,
    this.message,
    this.more,
    this.result,
  });

  factory TuChongSource.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }
    final List<VideoDetail> feedList =
        jsonRes['feedList'] is List ? <VideoDetail>[] : null;
    if (feedList != null) {
      for (final dynamic item in jsonRes['feedList']) {
        if (item != null) {
          tryCatch(() {
            feedList.add(VideoDetail.fromJson(asT<Map<String, dynamic>>(item)));
          });
        }
      }
    }

    return TuChongSource(
      counts: asT<int>(jsonRes['counts']),
      feedList: feedList,
      isHistory: asT<bool>(jsonRes['is_history']),
      message: asT<String>(jsonRes['message']),
      more: asT<bool>(jsonRes['more']),
      result: asT<String>(jsonRes['result']),
    );
  }

  final int counts;
  final List<VideoDetail> feedList;
  final bool isHistory;
  final String message;
  final bool more;
  final String result;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'counts': counts,
        'feedList': feedList,
        'is_history': isHistory,
        'message': message,
        'more': more,
        'result': result,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

List<VideoDetail> getVideoListList(List<dynamic> list){
    List<VideoDetail> result = [];
    list.forEach((item){
      result.add(VideoDetail.fromJson(item));
    });
    return result;
  }
@JsonSerializable()
  class VideoDetail extends Object {

  @JsonKey(name: 'vod_id')
  String vodId;

  @JsonKey(name: 'type_id')
  int typeId;

  @JsonKey(name: 'type_id_1')
  int typeId1;

  @JsonKey(name: 'group_id')
  int groupId;

  @JsonKey(name: 'vod_name')
  String vodName;

  @JsonKey(name: 'vod_sub')
  String vodSub;

  @JsonKey(name: 'vod_en')
  String vodEn;

  @JsonKey(name: 'vod_status')
  int vodStatus;

  @JsonKey(name: 'vod_letter')
  String vodLetter;

  @JsonKey(name: 'vod_color')
  String vodColor;

  @JsonKey(name: 'vod_tag')
  String vodTag;

  @JsonKey(name: 'vod_class')
  String vodClass;

  @JsonKey(name: 'vod_pic')
  String vodPic;

  @JsonKey(name: 'vod_pic_thumb')
  String vodPicThumb;

  @JsonKey(name: 'vod_pic_slide')
  String vodPicSlide;

  @JsonKey(name: 'vod_actor')
  String vodActor;

  @JsonKey(name: 'vod_director')
  String vodDirector;

  @JsonKey(name: 'vod_writer')
  String vodWriter;

  @JsonKey(name: 'vod_behind')
  String vodBehind;

  @JsonKey(name: 'vod_blurb')
  String vodBlurb;

  @JsonKey(name: 'vod_remarks')
  String vodRemarks;

  @JsonKey(name: 'vod_pubdate')
  String vodPubdate;

  @JsonKey(name: 'vod_total')
  int vodTotal;

  @JsonKey(name: 'vod_serial')
  String vodSerial;

  @JsonKey(name: 'vod_tv')
  String vodTv;

  @JsonKey(name: 'vod_weekday')
  String vodWeekday;

  @JsonKey(name: 'vod_area')
  String vodArea;

  @JsonKey(name: 'vod_lang')
  String vodLang;

  @JsonKey(name: 'vod_year')
  String vodYear;

  @JsonKey(name: 'vod_version')
  String vodVersion;

  @JsonKey(name: 'vod_state')
  String vodState;

  @JsonKey(name: 'vod_author')
  String vodAuthor;

  @JsonKey(name: 'vod_jumpurl')
  String vodJumpurl;

  @JsonKey(name: 'vod_tpl')
  String vodTpl;

  @JsonKey(name: 'vod_tpl_play')
  String vodTplPlay;

  @JsonKey(name: 'vod_tpl_down')
  String vodTplDown;

  @JsonKey(name: 'vod_isend')
  int vodIsend;

  @JsonKey(name: 'vod_lock')
  int vodLock;

  @JsonKey(name: 'vod_level')
  int vodLevel;

  @JsonKey(name: 'vod_copyright')
  int vodCopyright;

  @JsonKey(name: 'vod_points')
  int vodPoints;

  @JsonKey(name: 'vod_points_play')
  int vodPointsPlay;

  @JsonKey(name: 'vod_points_down')
  int vodPointsDown;

  @JsonKey(name: 'vod_hits')
  int vodHits;

  @JsonKey(name: 'vod_hits_day')
  int vodHitsDay;

  @JsonKey(name: 'vod_hits_week')
  int vodHitsWeek;

  @JsonKey(name: 'vod_hits_month')
  int vodHitsMonth;

  @JsonKey(name: 'vod_duration')
  String vodDuration;

  @JsonKey(name: 'vod_up')
  int vodUp;

  @JsonKey(name: 'vod_down')
  int vodDown;

  @JsonKey(name: 'vod_score')
  String vodScore;

  @JsonKey(name: 'vod_score_all')
  int vodScoreAll;

  @JsonKey(name: 'vod_score_num')
  int vodScoreNum;

  @JsonKey(name: 'vod_time')
  String vodTime;

  @JsonKey(name: 'vod_time_add')
  int vodTimeAdd;

  @JsonKey(name: 'vod_time_hits')
  int vodTimeHits;

  @JsonKey(name: 'vod_time_make')
  int vodTimeMake;

  @JsonKey(name: 'vod_trysee')
  int vodTrysee;

  @JsonKey(name: 'vod_douban_id')
  int vodDoubanId;

  @JsonKey(name: 'vod_douban_score')
  String vodDoubanScore;

  @JsonKey(name: 'vod_reurl')
  String vodReurl;

  @JsonKey(name: 'vod_rel_vod')
  String vodRelVod;

  @JsonKey(name: 'vod_rel_art')
  String vodRelArt;

  @JsonKey(name: 'vod_pwd')
  String vodPwd;

  @JsonKey(name: 'vod_pwd_url')
  String vodPwdUrl;

  @JsonKey(name: 'vod_pwd_play')
  String vodPwdPlay;

  @JsonKey(name: 'vod_pwd_play_url')
  String vodPwdPlayUrl;

  @JsonKey(name: 'vod_pwd_down')
  String vodPwdDown;

  @JsonKey(name: 'vod_pwd_down_url')
  String vodPwdDownUrl;

  @JsonKey(name: 'vod_content')
  String vodContent;

  @JsonKey(name: 'vod_play_from')
  String vodPlayFrom;

  @JsonKey(name: 'vod_play_server')
  String vodPlayServer;

  @JsonKey(name: 'vod_play_note')
  String vodPlayNote;

  @JsonKey(name: 'vod_play_url')
  String vodPlayUrl;

  @JsonKey(name: 'vod_down_from')
  String vodDownFrom;

  @JsonKey(name: 'vod_down_server')
  String vodDownServer;

  @JsonKey(name: 'vod_down_note')
  String vodDownNote;

  @JsonKey(name: 'vod_down_url')
  String vodDownUrl;

  @JsonKey(name: 'type_name')
  String typeName;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'status')
  bool status;

  @JsonKey(name: 'key')
  GlobalKey key;

  @JsonKey(name: 'list')
  List<VideoAttr> list;

  VideoDetail(this.vodId,this.typeId,this.typeId1,this.groupId,this.vodName,this.vodSub,this.vodEn,this.vodStatus,this.vodLetter,this.vodColor,this.vodTag,this.vodClass,this.vodPic,this.vodPicThumb,this.vodPicSlide,this.vodActor,this.vodDirector,this.vodWriter,this.vodBehind,this.vodBlurb,this.vodRemarks,this.vodPubdate,this.vodTotal,this.vodSerial,this.vodTv,this.vodWeekday,this.vodArea,this.vodLang,this.vodYear,this.vodVersion,this.vodState,this.vodAuthor,this.vodJumpurl,this.vodTpl,this.vodTplPlay,this.vodTplDown,this.vodIsend,this.vodLock,this.vodLevel,this.vodCopyright,this.vodPoints,this.vodPointsPlay,this.vodPointsDown,this.vodHits,this.vodHitsDay,this.vodHitsWeek,this.vodHitsMonth,this.vodDuration,this.vodUp,this.vodDown,this.vodScore,this.vodScoreAll,this.vodScoreNum,this.vodTime,this.vodTimeAdd,this.vodTimeHits,this.vodTimeMake,this.vodTrysee,this.vodDoubanId,this.vodDoubanScore,this.vodReurl,this.vodRelVod,this.vodRelArt,this.vodPwd,this.vodPwdUrl,this.vodPwdPlay,this.vodPwdPlayUrl,this.vodPwdDown,this.vodPwdDownUrl,this.vodContent,this.vodPlayFrom,this.vodPlayServer,this.vodPlayNote,this.vodPlayUrl,this.vodDownFrom,this.vodDownServer,this.vodDownNote,this.vodDownUrl,this.typeName,this.url,this.status,this.key,this.list);

  factory VideoDetail.fromJson(Map<String, dynamic> srcJson) => _$VideoDetailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VideoDetailToJson(this);

}


class VideoList{
  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'scope')
  String scope;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'census')
  String census;

  @JsonKey(name: 'tag')
  String tag;

  @JsonKey(name: 'href')
  String href;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'status')
  bool status;

  VideoList(this.title, this.scope, this.type, this.census, this.tag, this.href, this.url, this.status);
  
  factory VideoList.fromJson(Map<String, dynamic> srcJson) => _$VideoListFromJson(srcJson);
  Map<String, dynamic> toJson() => _$VideoListToJson(this);
}