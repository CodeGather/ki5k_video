/* 
 * @Author: 21克的爱情
 * @Date: 2020-09-02 16:56:52
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-07 15:43:29
 * @Description: 请求
 */
import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';

class HTTP{
  static HTTP instance;
  BaseOptions options;
  Dio dio;
  
  HTTP(){
    options = new BaseOptions(
      connectTimeout: 20000,
      receiveTimeout: 15000,
      sendTimeout: 15000,
      headers: {}
    );
    dio = new Dio(options);

    // 请求代理，便于调试
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      // if( kDebugMode ){
      //   client.findProxy = (uri) {
      //     //proxy all request to localhost:8888
      //     // return "PROXY 192.168.6.232:13920";
      //     // return "PROXY 192.168.1.5:13920";
      //     return "PROXY 192.168.31.78:13920";
      //   };
      // }
        
      //简单粗暴方式处理校验证书方法
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        if( kDebugMode ){
          return true;
        } else {
          if( host.indexOf('ki5k.com') > -1 && port == 443 ){ // Verify the certificate cert.pem==PEM
            return true;
          } else {
            return false;
          }
        }
      };
    };

    dio.interceptors.add(InterceptorsWrapper(
      onRequest:(RequestOptions options){
        Map<String, dynamic> headers = options.headers;
        
        String tokenHead = '';//SpUtil.getString("tokenHead");
        String toKen = '';//SpUtil.getString("token");
        if(toKen!=null && options.path.indexOf('api/v1/login')==-1 && options.path.indexOf('loginByWeChat')==-1 && options.path.indexOf('aliyuncs.com')==-1 && options.path.indexOf('weixin.qq.com')==-1){
          headers[tokenHead] = toKen;
        }

        // headers['Bearer'] = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxMTk2NjQ5NDkxNjU1MDkwMTc3IiwiaWF0IjoxNTc0MzAyNDkzLCJleHAiOjE1NzQ5MDcyOTN9.S6mvQJMwR3w--9blbR1ZaCdQaq0qarFhAFOBPNz3XCWqBvx1SAbkmyHjWSSFzuGc_XQ_eSngt972VaKXVsQoDA';//toKen;
        // 在请求被发送之前做一些事情
        print('请求头部:${options.headers}');
        return options; //continue
        // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
        // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
        //
        // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
        // 这样请求将被中止并触发异常，上层catchError会被调用。
      },
      onResponse:(Response response) {
        // 在返回响应数据之前做一些预处理
        // _success(response);
        return response; // continue
      },
      onError: (DioError e) {
        // 当请求失败时做一些预处理
        // _error(e);
        return e; //continue
      }
    ));
  }

  ajax(String url, { String method = 'get', bool customHeader = false, String dataType='json', Map data, CancelToken cancelToken }) async {
    Map<String, dynamic> resultData;

    print('get请求链接:$url\n请求头部:${options.toString()}\n请求参数:$data');
    try {
      Response response;
      dio.options.contentType = Headers.formUrlEncodedContentType;
      
      var cookieJar = CookieJar();
      dio.interceptors.add(CookieManager(cookieJar));
      // 打印cookie
      print(cookieJar.loadForRequest(Uri.parse(url)));
      switch (method.toLowerCase()) {
        case "get":
          if ( data != null && data.isNotEmpty ) {
            // 如果参数不为空，则将参数拼接到URL后面
            StringBuffer sb = StringBuffer("?");
            data.forEach((key, value) {
              sb.write("$key" + "=" + "$value" + "&");
            });
            String paramStr = sb.toString();
            paramStr = paramStr.substring(0, paramStr.length - 1);
            url += paramStr;
          }
          response = await dio.get(
            url,
            cancelToken: cancelToken,
          );
          break;
        case "post":
          if(customHeader != null && customHeader){
            dio.options.contentType = Headers.jsonContentType;
          }
          response = await dio.post(
            url,
            data: data,
            cancelToken: cancelToken,
          );
          break;
        default:
          break;
      }
      // _success( response );
      if(response.statusCode == 200){
        if( dataType == 'json' ){
          return json.decode(response.data);
        } else {
          return response.data;
        }
      }
      // resultData = json.decode(response.toString());
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('get请求取消! ' + e.message);
      }
      resultData = null;
      // _errorIncrement(e);
      print('----------------------${e.response}');
    }
    return resultData;
  }
}