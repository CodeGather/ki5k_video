/* 
 * @Author: 21克的爱情
 * @Date: 2020-09-08 20:01:39
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-09 12:04:51
 * @Description: 
 */
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:ki5k_video/provide/application_provide.dart';

class VideoWebPlayPage extends StatefulWidget {
  final String url;
  VideoWebPlayPage(this.url, {Key key}) : super(key: key);

  @override
  _VideoWebPlayPageState createState() => _VideoWebPlayPageState();
}

class _VideoWebPlayPageState extends State<VideoWebPlayPage> {
  // final flutterWebViewPlugin = FlutterWebviewPlugin();
  InAppWebViewController _webViewController;
  String palyUrl = '';
  String currentUrl='';
  Map<String, String> currentOrigin ={
    'name': '源1',
    'url': 'https://z1.m1907.cn/?jx='
  };

  @override
  void initState() { 
    super.initState();
    

    palyUrl = widget.url;
    // Add a listener to on url changed
    // _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
    //   if (mounted && url.indexOf('http') > -1) {
    //     print('onUrlChanged: $url');
    //     setState(() {
    //       currentUrl = url;
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();

    Orientation orientation = MediaQuery.of(ApplicationStatus.navigatorKey.currentContext).orientation;
    if(orientation.toString().indexOf('landscape') > -1){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp
      ]);
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${currentOrigin['name'] ?? ''}预览"),
      ),
      body: Builder(builder: (BuildContext context) {
        // Container(
        //           padding: EdgeInsets.all(10.0),
        //           child: progress < 1.0
        //               ? LinearProgressIndicator(value: progress)
        //               : Container()),
        return InAppWebView(
          // contextMenu: contextMenu,
          initialUrl: palyUrl??'https://baidu.com',
          initialHeaders: {},
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              debuggingEnabled: true,
              useShouldOverrideUrlLoading: true,
              userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/80.0.3987.95 Mobile/15E148 Safari/604.1'
            ),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            setState(() {
              _webViewController = controller;
            });
            print("onWebViewCreated");
          },
          onLoadStart: (InAppWebViewController controller, String url) {
            print("onLoadStart $url");
          },
          onEnterFullscreen: (InAppWebViewController controller){
            print('onEnterFullscreen');
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight
            ]);
          },
          onExitFullscreen: (InAppWebViewController controller){
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp
            ]);
          },
          shouldOverrideUrlLoading: (controller, shouldOverrideUrlLoadingRequest) async {
            var url = shouldOverrideUrlLoadingRequest.url;
            var uri = Uri.parse(url);

            // if (!["http", "https", "file",
            //   "chrome", "data", "javascript",
            //   "about"].contains(uri.scheme)) {
            //   if (await canLaunch(url)) {
            //     // Launch the App
            //     await launch(
            //       url,
            //     );
            //     // and cancel the request
            //     return ShouldOverrideUrlLoadingAction.CANCEL;
            //   }
            // }

            return ShouldOverrideUrlLoadingAction.ALLOW;
          },
          onLoadStop: (InAppWebViewController controller, String url) async {
            print("onLoadStop $url");
            setState(() {
              currentUrl = url;
            });
          },
          onProgressChanged: (InAppWebViewController controller, int progress) {
            // setState(() {
            //   this.progress = progress / 100;
            // });
          },
          onUpdateVisitedHistory: (InAppWebViewController controller, String url, bool androidIsReload) {
            print("onUpdateVisitedHistory $url");
          },
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
        );
      }),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                if (await _webViewController.canGoBack()) {
                  await _webViewController.goBack();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.autorenew),
              onPressed: () {
                _webViewController.reload();
              },
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    onPressed: (){
                      showPickerModal(context);
                    },
                    child: Text('切换源'),
                  ),
                  FlatButton(
                    onPressed: () async{
                      print(currentOrigin['url'] + currentUrl);
                      _webViewController.loadUrl(url: currentOrigin['url'] + currentUrl);
                    },
                    child: Text('开始解析'),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  showPickerModal(BuildContext context) {
    List origin = [
      {"name": "源1","url": "https://z1.m1907.cn/?jx="}, 
      {"name": "源2","url": "https://17kyun.com/api.php?url="}, 
      {"name": "源3","url": "https://okjx.cc/v2.php?url="}, 
      {"name": "源4","url": "https://app.tf.js.cn/3jx/?url="}, 
      {"name": "源5","url": "https://app.tf.js.cn/520/?url="},
      {"name": "源6","url": "https://app.tf.js.cn/nx/?url="},
      {"name": "源7","url": "https://app.tf.js.cn/9k/?url="},
      {"name": "源8","url": "https://app.tf.js.cn/jx/dp.php?url="},
      {"name": "源9","url": "https://okjx.cc/?url="},
      {"name": "源10","url": "https://jx.jiubojx.com/vip.php?url="},
      {"name": "源11","url": "https://api.sigujx.com/?url="},
      {"name": "源12","url": "https://jx.618g.com/?url="},
      {"name": "源13","url": "https://vip.jiubojx.com/vip/?url="},
      {"name": "源14","url": "http://api.baiyug.vip/index.php?url="},
      {"name": "源15","url": "https://vip.bljiex.com/?v="},
    ];

    List list = origin.map((item)=>item['name']).toList();
    
    Picker(
      adapter: PickerDataAdapter<String>(pickerdata: list),
      changeToFirst: true,
      hideHeader: false,
      cancelText: '取消',
      confirmText: '确认',
      selectedTextStyle: TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List value) {
        // print(value.toString());
        // print(origin[value[0]]);
        // print(picker.adapter.text);
        setState(() {
          currentOrigin = origin[value[0]];
        });
      }
    ).showModal(this.context); //_scaffoldKey.currentState);
  }

}
