import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jokui_video/api/Api.dart';
import 'package:jokui_video/pages/service/service_method.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml_parser/xml_parser.dart';

import '../../provide/application_provide.dart';
import '../../utils/utils.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Map<dynamic, dynamic> downloadData;
  // app下载进度
  double progress = 0.0;
  // 正在更新禁止再次点击
  bool uploadBtnStart = false;
  // app 是否已下载
  bool fileExist = false;
  // app 保存路径
  String savePath;
  // CancelToken cancelToken;
  String versionCode='1.0.0';
  String versionDesc='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    //_testVersion();
    _getLocationVersion();
  }

  // 版本检测
  _getLocationVersion() async {
    final documentXml = await XmlDocument.fromUri('https://github.com/CodeGather/ki5k_video/releases');

    if (documentXml == null) {
      throw ('Failed to load page.');
    }

    final versionXml = documentXml.getElementWhere(
      name: 'h6',
      attributes: [XmlAttribute('class', 'version')],
    );


    setState(() {
      versionCode = versionXml.getChild('p').text;
      versionDesc = versionXml.getChild('span').text;
    });
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      if(Utils.versionCompare(packageInfo.version, versionCode)){
        _haveNewVersion();
      }
    });

  }

  _fileIsExist({ String url, String savePath, Function progress, Function success, Function error }) async {
    await Api.downloadFile(
      url,
      savePath,
      CancelToken(),
      progress, 
      success,
      error
    );
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(MediaQuery.of(context).viewPadding.bottom);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(48),//ScreenUtil.getInstance().getWidth(44)
        child: AppBar(
          title: Text('关于我们'),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.share),
          //     onPressed: (){
          //       final RenderBox box = context.findRenderObject();

          //       String text = '达理APP下载地址：${ Platform.isIOS ? "https://apps.apple.com/cn/app/%E8%BE%BE%E7%90%86/id1487592808" : "https://www.pgyer.com/yUL6"}';
          //       String subject = '欢迎使用达理APP分享';

          //       Share.share(
          //         text,
          //         subject: subject,
          //         sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
          //       );
          //     }
          //   )
          // ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: ScreenUtil.getInstance().getHeight(100)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                'assets/images/logo.png',
                width: ScreenUtil.getInstance().getWidth(100),
              ),
            )
          ),
          ListTile(
            title: Text('当前版本'),//'检查更新'
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('$versionCode'),
                false ? Icon(
                  Icons.fiber_new,
                  color: Colors.red,
                ):Container(),
                //Icon(Icons.keyboard_arrow_right)
              ],
            ),
            onTap: (){
              //_haveNewVersion();
            },
          ),
        ],
      ),
    );
  }

  
  // 软件更新窗口
  void _haveNewVersion() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:(stateContext, state) {
            // 判断文件是否存在
            if( mounted ){
              state(() {
                fileExist = fileExist;
              });
            }

            return GestureDetector(
              child: Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                color: Colors.transparent,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 250,
                    minHeight: 150
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)
                    )
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: MediaQuery.of(context).padding.bottom),
                  child: Column( 
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          '更新提示',
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          // physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Text('$versionDesc'),
                            )
                          ],
                        )
                      ),
                      _appWidget(state),
                      Opacity( // 进度条 
                        opacity: progress > 0?1:0,
                        child: SizedBox(
                          height: 2,
                          child: new LinearProgressIndicator(
                            backgroundColor: Colors.blue,
                            value: progress,
                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ), 
              // onVerticalDragUpdate: (e)=>false,
            );
          }
        );
      }
    );
    setState(() {
      uploadBtnStart = false;
    });
  }
  
  Widget _appWidget(state){
    if(Platform.isIOS){
      return Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () async {
                if (await canLaunch(downloadData['appStore'])) {
                  await launch(downloadData['appStore'], forceSafariVC: false);
                } else {
                  throw "打开appStore${downloadData['appStore']}";
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18),
                alignment: Alignment.center,
                child: Text('前往appStore更新'),
              ),
            )
          )
        ]
      );
    } else {
      return Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () async {
                // 正在下载时禁止再次点击
                if(uploadBtnStart){
                  return false;
                }

                String fileDir = await Utils.getFilePath();
                String downloadUrl = 'https://github.com/CodeGather/ki5k_video/releases/download/$versionCode/app-release.apk';
                String filePath = '$fileDir/${downloadUrl.substring(downloadUrl.lastIndexOf('/') + 1)}';

                _fileIsExist(
                  url: downloadUrl,
                  savePath: filePath,
                  error: (e){
                    if( e.response.statusCode == 302 ){
                      _fileIsExist(
                        url: e.response.headers.map["location"][0], 
                        savePath: filePath, 
                        progress: (received, total){
                          if (total != -1) {
                            debugPrint('下载进度${received / total}');
                            state(() {
                              progress = received / total;
                            });
                          }
                        }, 
                        success:  (e){
                          // 打开App
                          OpenFile.open(filePath);
                          debugPrint('完成$e');
                        },
                        error: (e){
                          debugPrint('失败${e.response.headers.map["location"][0]}');
                        }
                      );
                    }
                    debugPrint('失败${e.response.headers.map["location"][0]}');
                  }
                );

                // ApplicationBloc blocs = BlocProvider.of<ApplicationBloc>(context);
                // blocs.appEventStream.listen((value) {
                //   if(progress < 1){
                //     state(() {///为了区分把setState改个名字
                //       progress = progress;
                //     });
                //     debugPrint('---------------------------$progress');
                //   } else {
                //     blocs.dispose();
                //   }
                // });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: Text(fileExist?'立即安装':'立即更新'),
              ),
            )
          ),
          Expanded(
            child: InkWell(
              onTap: () async {
                debugPrint('打开外部浏览区');
                  if (await canLaunch('https://github.com/CodeGather/ki5k_video/releases')) {
                    await launch(
                      'https://github.com/CodeGather/ki5k_video/releases',
                      forceSafariVC: false,
                      universalLinksOnly: true,
                    );
                  } else {
                    throw '打开apk失败';
                  }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: Text('外部更新'),
              ),
            )
          ),
        ],
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(progress>0){
      progress = 0.0;
    }
    // if(cancelToken!=null){
    //   cancelToken.cancel("cancelled");
    // }
  }
}