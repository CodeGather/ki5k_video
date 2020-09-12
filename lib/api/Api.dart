import '../service/service_method.dart';

class Api {
//   // 高德地图主域名地址
//   static final String AMAP_HOST = "https://restapi.amap.com";

//   // 切换请求的域名地址
  static final String HOST = "https://movie.ki5k.com/api.php";

  // 获取某个城市兄弟的信息
  static Future getSearchData(data) async {
    return await HTTP().ajax("http://cj.okzy.tv/inc/apickm3u8s.php", method: 'get', data: data, dataType: 'xml');
  }
  // 获取某个城市兄弟的信息
  static Future getSearchDetail(data) async {
    return await HTTP().ajax("http://cj.okzy.tv/inc/apickm3u8s.php", method: 'get', data: data, dataType: 'xml');
  }

  // 获取某个城市兄弟的信息
  static Future getHomeVideo(data) async {
    return await HTTP().ajax("http://www.zdziyuan.com/inc/api_zuidam3u8.php", method: 'get', data: data, dataType: 'xml');
  }

  // 获取某个城市兄弟的信息x
  static Future getPageData(data) async {
    return await HTTP().ajax("https://m.pianku.tv/$data", method: 'get', data: null, dataType: 'xml');
  }

  // 搜索视频 https://www.pianku.tv/s/go.php?q=lou
  static Future getSearchVideoData(String searchStr) async {
    return await HTTP().ajax("https://m.pianku.tv/s/go.php?q=$searchStr", method: 'get', data: {}, dataType: 'xml');
  }

  // 获取app版本
  static Future getVideoList(data) async {
    return await HTTP().ajax(HOST+'/provide/vod/', method: 'get', data: data);
  }
  // 下载App
  // static Future downloadFile( downloadUrl, savePath, cancelToken, Function downloadProgress, Function success, Function error ) async {
  //   return await HTTP().downloadFile(downloadUrl, savePath, cancelToken, downloadProgress: downloadProgress, success: success, error: error);
  // }
  
  


//   // ------------------------------第三方接口信息-----------------------------------------
//   // 账号绑定
//   static Future getCityByParentCode( { int id=100000 } ) async {
//     return await HTTP().get(HOST + API_PATH+ '/public/getCityByParentCode?parentCode=${id??100000}');
//   }
//   // 高德地图POI
//   static Future getAround(data) async {
//     return await HTTP().get(AMAP_HOST+'/v3/place/around',  data: data);
//   }
//   // 获取阿里云oss签名信息单个
//   static Future getOssPolicy() async {
//     return await HTTP().get(HOST + API_PATH + '/aliyun/oss/policy',  data: null);
//   }
//   // 获取阿里云oss签名信息单个或者多个
//   static Future getOssPolicyList( size ) async {
//     return await HTTP().get(HOST + API_PATH + '/aliyun/oss/policyBatch/$size',  data: null);
//   }
//   // 1.3.0 版本新增接口 ----->> 获取阿里云oss签名信息单个或者多个
//   static Future getOssBatchList( size ) async {
//     return await HTTP().get(HOST + API_PATH + '/aliyun/oss/batchPolicy/$size',  data: null);
//   }
//   // 公共上传Api
//   static Future setUploadFile( String url, FormData formData, {cancelToken, Function uploadProgress, Function success, Function error} ) async {
//     return await HTTP().uploadFile(url, formData, cancelToken: cancelToken, uploadProgress: uploadProgress, success: success, error: error );
//   }
//   static Future cancelToken() async {
//     return await HTTP().canceledToken();
//   }

//   // 一次性订阅
//   static Future wechatSubscribeMsg( token, data) async {
//     return await HTTP().post('https://api.weixin.qq.com/cgi-bin/message/template/subscribe?access_token=$token', options: true, data: data);
//   }

//   // 获取Token
//   static Future getAccessToken( appid, secret) async {
//     return await HTTP().get('https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=$appid&secret=$secret', data: null);
//   }
}