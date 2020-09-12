import '../pages/service/service_method.dart';
import 'package:dio/dio.dart';

class Api {
//   // 高德地图主域名地址
//   static final String AMAP_HOST = "https://restapi.amap.com";

//   // 切换请求的域名地址
  static final String HOST = "https://movie.ki5k.com/api.php";

//   // 请求的API目录
//   static final String API_PATH = "/jokui-dali-fast";

//   // 请求的API版本
//   static final String API_VERSION = "/api/v1";

//   // API请求接口-用户登录
//   static final String API_JOKUI_ATTENTION = HOST + API_PATH + API_VERSION + "/login/";

//   // API请求接口-用户
//   static final String API_JOKUI_USER = HOST + API_PATH + API_VERSION + "/member";

//   // API请求接口-订单
//   static final String API_JOKUI_ORDER = HOST + API_PATH + API_VERSION + "/order";

//   // API请求接口-配置
//   static final String API_JOKUI_CONFIG = HOST + API_PATH + API_VERSION + "/config";

  
//   // ------------------------------会员登录注册-------------------------------------------
//   // 用户登录
//   static Future getUserLogin(data) async {
//     return await HttpUtil().post(API_JOKUI_ATTENTION+'login',  data: data);
//   }
//   // 手机号码登录
//   static Future getMobileLogin(data) async {
//     return await HttpUtil().post(API_JOKUI_ATTENTION+'login/$data');
//   }
//   // 获取验证码
//   static Future getAuthCode(phone) async {
//     return await HttpUtil().post(API_JOKUI_ATTENTION+'$phone',  data: null);
//   }
//   // 验证码登录
//   static Future getUserLoginByCode( data) async {
//     return await HttpUtil().post(API_JOKUI_ATTENTION+'loginByCode',  data: data);
//   }
//   // 微信登录
//   static Future getUserLoginByWechat(data) async {
//     return await HttpUtil().post(API_JOKUI_ATTENTION+'loginByWeChat', options: true, data: data);
//   }
//   // 手机号码一键登陆
//   static Future getLoginByMobile(token) async {
//     return await HttpUtil().post(API_JOKUI_ATTENTION+'loginByMobile', data: token);
//   }
//   // apple授权登录
//   static Future getLoginByApple(token) async {
//     return await HttpUtil().post(API_JOKUI_ATTENTION+'loginByApple', data: token);
//   }

//   // ------------------------------会员信息-------------------------------------------
//   // 获取用户数据
//   static Future getUserData( context ) async {
//     return await HttpUtil().get(API_JOKUI_USER,  data: null);
//   }
//   // 账号绑定
//   static Future setBindMobile(data) async {
//     return await HttpUtil().post(API_JOKUI_USER+'/bindMobile', data: data);
//   }
//   // 短信验证
//   static Future getSmsAuth(data) async {
//     return await HttpUtil().get(API_JOKUI_USER+'/bindMobile/$data',  data: null);
//   }
//   // 更新用户数据
//   static Future setUpdate(data) async {
//     return await HttpUtil().post(API_JOKUI_USER+'/perfect', options: true, data: data);
//   }
//   // 更新服务区域
//   static Future setRegion(data) async {
//     return await HttpUtil().post(API_JOKUI_USER+'/region', data: data);
//   }
//   // 获取服务类型
//   static Future getService( context ) async {
//     return await HttpUtil().get(API_JOKUI_USER+'/service', data: null);
//   }
//   // 更新服务类型
//   static Future setService(data) async {
//     return await HttpUtil().post(API_JOKUI_USER+'/service', options: true, data: data);
//   }
//   // 用户反馈
//   static Future setFeedBack(data) async {
//     return await HttpUtil().post(API_JOKUI_USER+'/feedback/$data',  data: null);
//   }


//   // ------------------------------订单信息-------------------------------------------
//   // 获取订单列表
//   static Future getOrder(data) async {
//     return await HttpUtil().get(API_JOKUI_ORDER,  data: data);
//   }
//   // 获取订单详情
//   static Future getOrderDetail(id) async {
//     return await HttpUtil().get(API_JOKUI_ORDER + '/$id',  data: null);
//   }
//   // 接单或者抢单
//   static Future setOrderDetail(id) async {
//     return await HttpUtil().post(API_JOKUI_ORDER + '/$id',  data: null);
//   }
//   // 预约订单时间
//   static Future setOrderServiceTime(data) async {
//     return await HttpUtil().post(API_JOKUI_ORDER + '/serviceTime',  data: data);
//   }
//   // 订单签到
//   static Future setOrderSign(data) async {
//     return await HttpUtil().post(API_JOKUI_ORDER + '/sign', options: true, data: data);
//   }
//   // 挂起订单
//   static Future setOrderPause(data) async {
//     return await HttpUtil().post(API_JOKUI_ORDER + '/pause',  data: data);
//   }
//   // 放弃订单
//   static Future setOrderCancel(data) async {
//     return await HttpUtil().post(API_JOKUI_ORDER + '/cancel', data: data);
//   }
//   // 取消挂起订单
//   static Future setOrderCancelPause(id) async {
//     return await HttpUtil().post(API_JOKUI_ORDER + '/cancelPause/$id',  data: null);
//   }
//   // 上传施工照片
//   static Future setOrderPhoto(data) async {
//     return await HttpUtil().post(API_JOKUI_ORDER + '/photo', options: true, data: data);
//   }
//   // 删除施工照片
//   static Future delOrderPhoto(data) async {
//     return await HttpUtil().delete(API_JOKUI_ORDER + '/photo?ids=$data', data: null);
//   }
//   // 更新单张施工照片
//   static Future setOnlyPhoto(data) async {
//     return await HttpUtil().post(API_JOKUI_ORDER + '/photo/update', data: data);
//   }
//   // 查询点位以及施工图片
//   static Future getOrderPhoto(id) async {
//     return await HttpUtil().get(API_JOKUI_ORDER + '/photo/$id',  data: null);
//   }
//   // 订单物流信息
//   static Future getOrderLogistics(number) async {
//     return await HttpUtil().get(API_JOKUI_ORDER + '/logistics/$number',  data: null);
//   }
//   // 提交审核
//   static Future setOrderReview(data) async {
//     return await HttpUtil().post(API_JOKUI_ORDER + '/review', options: true, data: data);
//   }


//   // ------------------------------配置信息-------------------------------------------
//   // 获取某个城市的信息
//   static Future getCityByRegion(data) async {
//     return await HttpUtil().get(API_JOKUI_CONFIG + "/getCityByRegionCode", data: data);
//   }
  // 获取某个城市兄弟的信息
  static Future getSearchData(data) async {
    return await HttpUtil().ajax("http://cj.okzy.tv/inc/apickm3u8s.php", data: data, method: 'get', dataType: 'xml');
  }
  // 获取某个城市兄弟的信息
  static Future getSearchDetail(data) async {
    return await HttpUtil().ajax("http://cj.okzy.tv/inc/apickm3u8s.php", data: data, method: 'get', dataType: 'xml');
  }

  // 获取app版本
  static Future getVideoList(data) async {
    return await HttpUtil().ajax(HOST+'/provide/vod/', data: data, method: 'get');
  }
  // 下载App
  static Future downloadFile( downloadUrl, savePath, cancelToken, Function downloadProgress, Function success, Function error ) async {
    return await HttpUtil().downloadFile(downloadUrl, savePath, cancelToken, downloadProgress: downloadProgress, success: success, error: error);
  }
  
  


//   // ------------------------------第三方接口信息-----------------------------------------
//   // 账号绑定
//   static Future getCityByParentCode( { int id=100000 } ) async {
//     return await HttpUtil().get(HOST + API_PATH+ '/public/getCityByParentCode?parentCode=${id??100000}');
//   }
//   // 高德地图POI
//   static Future getAround(data) async {
//     return await HttpUtil().get(AMAP_HOST+'/v3/place/around',  data: data);
//   }
//   // 获取阿里云oss签名信息单个
//   static Future getOssPolicy() async {
//     return await HttpUtil().get(HOST + API_PATH + '/aliyun/oss/policy',  data: null);
//   }
//   // 获取阿里云oss签名信息单个或者多个
//   static Future getOssPolicyList( size ) async {
//     return await HttpUtil().get(HOST + API_PATH + '/aliyun/oss/policyBatch/$size',  data: null);
//   }
//   // 1.3.0 版本新增接口 ----->> 获取阿里云oss签名信息单个或者多个
//   static Future getOssBatchList( size ) async {
//     return await HttpUtil().get(HOST + API_PATH + '/aliyun/oss/batchPolicy/$size',  data: null);
//   }
//   // 公共上传Api
//   static Future setUploadFile( String url, FormData formData, {cancelToken, Function uploadProgress, Function success, Function error} ) async {
//     return await HttpUtil().uploadFile(url, formData, cancelToken: cancelToken, uploadProgress: uploadProgress, success: success, error: error );
//   }
//   static Future cancelToken() async {
//     return await HttpUtil().canceledToken();
//   }

//   // 一次性订阅
//   static Future wechatSubscribeMsg( token, data) async {
//     return await HttpUtil().post('https://api.weixin.qq.com/cgi-bin/message/template/subscribe?access_token=$token', options: true, data: data);
//   }

//   // 获取Token
//   static Future getAccessToken( appid, secret) async {
//     return await HttpUtil().get('https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=$appid&secret=$secret', data: null);
//   }
}