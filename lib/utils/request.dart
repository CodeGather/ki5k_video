/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-11 13:21:19
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-14 20:42:36
 * @Description: 请求封装
 */

import 'dart:convert' as convert;
import 'package:flustars/flustars.dart';
import 'package:http/http.dart' as http;
import 'package:jokui_video/utils/utils.dart';


class HTTPTOOL{
  
  static void loadList( String url, {Function success}) async {
    // https://jx.idc126.net/jx/api.php
    // https://v.7cyd.com/vip/api_aa.php
    // String ApiUrl = 'http://8090.ylybz.cn/jiexi2019/api.php';
    // http://v.yhgou.cc/2019/api.php?url=https://www.iqiyi.com/v_19rwvjqblo.html
    String ApiUrl = SpUtil.getString( "api" ) != null && SpUtil.getString( "api" ).isNotEmpty ? SpUtil.getString( "api" ) : 'https://jx.688ing.com/parse/op/play';

    final response = await http.post(ApiUrl, body: {
      'url': url,
      'movieUrl': url,
      'ios': '',
      'apiId': '0',
      'other': Utils.base64Encode(url),                      // 链接加密base64
      'referer': Utils.base64Encode('${ApiUrl}?url=${url}'), //全路径加密
      'time': new DateTime.now().millisecondsSinceEpoch.toString(),     // 时间戳 //1586583184
      'type': ''
    });
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if( success != null ){
        success(jsonResponse);
      }
    } else {
      success(null);
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future ajax(String url, dynamic data, { String method = 'GET' }) async {
    await http.get(url);
  }
}