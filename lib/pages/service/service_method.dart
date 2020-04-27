/*
 * @Author: 21克的爱情
 * @Date: 2019-05-14 12:22:22
 * @Email: raohong07@163.com
 * @LastEditors  : 21克的爱情
 * @LastEditTime : 2020-01-26 22:28:17
 * @Description: 网络请求封装
 */

import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';


class HttpUtil {
  static HttpUtil instance;
  Dio dio;
  Options options;
  CancelToken cancelToken =  CancelToken();

  static HttpUtil getInstance() {
    print('getInstance');
    if (instance == null) {
      instance = new HttpUtil();
    }
    return instance;
  }


  static getIp() async {
    // 内网ip
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        print('------------------${addr.address}');
      }
    }
  }

  HttpUtil() {
    // String requestUrl = '';
    // if (kReleaseMode){ // 
    //   //release
    // }else {
    //   //debug
    // }
    // 或者通过传递一个 `options`来创建dio实例
    BaseOptions options = new BaseOptions(
      // 请求基地址,可以包含子路径，如: "https://www.google.com/api/".
      // baseUrl: requestUrl,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 15000,
      ///  响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，
      ///  [Dio] 将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常.
      ///  注意: 这并不是接收数据的总时限.
      receiveTimeout: 15000,
      sendTimeout: 15000,
      headers: {},
    );
    dio = new Dio(options);

    // 请求代理，便于调试
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      // if( !kReleaseMode ){
      //   client.findProxy = (uri) {
      //     //proxy all request to localhost:8888
      //     // return "PROXY 192.168.6.232:13920";
      //     // return "PROXY 192.168.1.103:13920";
      //     return "PROXY 192.168.0.149:13920";
      //   };
      // }
        
      //简单粗暴方式处理校验证书方法
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        if( !kReleaseMode ){
          return true;
        } else {
          if( host.indexOf('jokui.com') > -1 && port == 443 ){ // Verify the certificate cert.pem==PEM
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
        
        String tokenHead = SpUtil.getString("tokenHead");
        String toKen = SpUtil.getString("token");

        // 头部token
        // if(toKen!=null && options.path.indexOf('api/v1/login')==-1 && options.path.indexOf('loginByWeChat')==-1 && options.path.indexOf('aliyuncs.com')==-1 && options.path.indexOf('weixin.qq.com')==-1){
        //   headers[tokenHead] = toKen;
        // }
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
        return e;//continue
      }
    ));
  }

  ajax(url, {data, method, options, String savePath, FormData formData, cancelToken, Function(int, int) progress, Function success, Function error}) async {
    Response response;
    dynamic resultData;
    print('请求链接$url');
    switch (method) {
      case 'get':
        if ( data != null ) {
          // 如果参数不为空，则将参数拼接到URL后面
          StringBuffer sb = StringBuffer("?");
          data.forEach((key, value) {
            sb.write("$key" + "=" + "$value" + "&");
          });
          String paramStr = sb.toString();
          paramStr = paramStr.substring(0, paramStr.length - 1);
          url += paramStr;
        }

        print('get请求链接:$url\n请求头部:${options.toString()}\n请求参数:$data');
        try {
          response = await dio.get(
            url,
            cancelToken: cancelToken,
          );
          if(response.statusCode == 200){
            return json.decode(response.data);
          } else {
            return null;
          }
        } on DioError catch (e) {
          if (CancelToken.isCancel(e)) {
            print('get请求取消! ' + e.message);
          }
          resultData = null;
          _errorIncrement(e);
          print('----------------------${e.response}');
        }
        return resultData;
      case 'post':
        print('post请求链接:$url\n请求头部:${options.toString()}\n请求参数:$data');
        try {
          
          if(options!=null){
            dio.options.contentType = Headers.jsonContentType;
          } else {
            dio.options.contentType = Headers.formUrlEncodedContentType;
          }

          response = await dio.post(
            url,
            data: data,
            cancelToken: cancelToken,
          ).then(success).catchError(error);
        } on DioError catch (e) {
          if (CancelToken.isCancel(e)) {
            print('post请求取消! ' + e.message);
          }
          print('post请求发生错误：${e.type}');
          resultData = null;
          _errorIncrement(e);
        }
        return resultData;
      case 'deleta':
        try {
          if(options!=null){
            dio.options.contentType = Headers.jsonContentType;
          } else {
            dio.options.contentType = Headers.formUrlEncodedContentType;
          }
          response = await dio.delete(
            url,
            data: data,
            cancelToken: cancelToken,
          );
          resultData = json.decode(response.toString());
          print('delete请求成功!response.data：${response.data}');
        } on DioError catch (e) {
          if (CancelToken.isCancel(e)) {
            print('delete请求取消! ' + e.message);
          }
          print('delete请求发生错误：${e.type}');
          // _error(e, context);
          resultData = null;
        }
        return resultData;
      case 'upload':
        try {
          response = await dio.post(
            url, 
            data: formData,
            cancelToken: cancelToken,
            onReceiveProgress: progress,
          );
        } on DioError catch (e) {
          print("get uploadImage error: ${e.response}");
          // await UtilTool.showToastDialog('上传失败', type: false);
        }
        return response;
      case 'download':
        assert(savePath != null);
        response = await dio.download(
          url,
          savePath,
          cancelToken: cancelToken,
          onReceiveProgress: progress,
          //Received data with List<int>
          options: Options(
            sendTimeout: 0,
            receiveTimeout: 0,
            responseType: ResponseType.bytes,
            followRedirects: false,
          ),
        ).then(success).catchError(error);
        
        print(response.headers);
        break;
      default:
    }
  }

  // 下载文件
  downloadFile(String url, String savePath, cancelToken, {Function downloadProgress, Function success, Function error}) async {
    Response response;
    try {
      response = await dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: downloadProgress,
        //Received data with List<int>
        options: Options(
          sendTimeout: 0,
          receiveTimeout: 0,
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      ).then(success).catchError(error);
      
      print(response);
      // print(response.headers.map['location']);
      // File file = File(savePath);
      // var raf = file.openSync(mode: FileMode.write);
      // // response.data is List<int> type
      // raf.writeFromSync(response.data);
      // await raf.close();
    } catch (e) {
      print('----$e');
    }
  }

  canceledToken(){
    cancelToken.cancel("cancelled");
    dio = null;
  }

  _success( e ) {
    Map _res = json.decode(e.data.toString());
    if( _res.containsKey('code') ){
      print('-状态吗-${_res['code']}');
      String msg = '';
      int code = _res['code'];
      switch ( code ) {
        case 400:
          msg = '参数有误，请联系管理员';
          break;
        case 500:
          msg = '服务器内部错误'; // IntlUtil.getString(NavKey.navKey.currentContext, Ids.titleLanguage)
          break;
        case 1000:
          msg = '该订单已被其他人收入囊中';
          break;
        case 1001:
          msg = '该订单当前状态错误';
          break;
        case 1003:
          msg = '抢单失败！';
          break;
        case 1100:
          msg = '未查到物流信息';
          break;
        case 2000:
          msg = '验证码错误';
          break;
        case 2001:
          msg = '当前账号已绑定该手机号\n请更换其它号码';
          break;
        case 2002:
          msg = '该手机号码已被绑定\n请更换其它号码';
          break;
        case 2003:
          msg = '账号不存在';
          break;
        case 2004:
          msg = '账号已冻结';
          break;
        case 2010:
          msg = 'apple identityToken expired';
          break;
        case 2011:
          msg = 'apple identityToken illegal';
          break;
        case 2012:
          msg = '获取手机号码失败';
          break;
        default:
      }

      // if (_res['code'] == 401 || _res['code'] == 403 || _res['code'] == 500) {
      //   RouteUtil.navigatorKey.currentState.pushReplacementNamed(BaseConstant.routeLogin);
      // } else if( UtilTool.isNotNullOrEmpty(msg) ){
      //   UtilTool.showToastDialog(msg, type: false);
      // }
    }
  }

  // _error(error, context) {
  //   Provide.value<Counter>(context).increment(error);
  // }
  void _errorIncrement(error){
    // 定义需要使用的变量
    String msg = '';
    int errorIndex = 10000;
    switch (error.type) {
      case DioErrorType.CONNECT_TIMEOUT:
        msg = '请求超时，请稍后再试！';
        errorIndex = 10001;
        break;
      case DioErrorType.SEND_TIMEOUT:
        msg = '发送连接超时，请稍后再试！';
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        msg = '数据接送超时，请稍后再试！';
        errorIndex = 10002;
        break;
      case DioErrorType.CANCEL:
        msg = '请求被主动取消！';
        errorIndex = 10003;
        break;
      case DioErrorType.DEFAULT:
        msg = '请求被服务器拒绝！';
        errorIndex = 10004;
        break;
      case DioErrorType.RESPONSE:
        if( error.response.statusCode == 301 ){
          msg = '请求地址被重定向，请检查请求地址';
          errorIndex = 301;
        } else if( error.response.statusCode == 404 ){
          msg = '当前请求接口不存在！';
          errorIndex = 404;
        }
        break;
      default:
        var map =  json.decode(error.response.toString());
        print("map->>"+map['message']);
        msg = map['message'];
    }

    // UtilTool.showToastDialog( msg, type: false );
  }
}
