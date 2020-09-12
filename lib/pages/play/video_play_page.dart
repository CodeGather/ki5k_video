import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VideoPlayPage extends StatefulWidget {
  final int id;
  final String title;
  bool type;
  VideoPlayPage(this.id, {this.type, this.title, Key key}) : super(key: key);

  @override
  _VideoPlayPageState createState() => new _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> {
  InAppWebViewController webView;
  ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  CookieManager _cookieManager = CookieManager.instance();

  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
      menuItems: [
        ContextMenuItem(androidId: 1, iosId: "1", title: "Special", action: () async {
          //print("Menu item Special clicked!");
          print(await webView.getSelectedText());
          await webView.clearFocus();
        })
      ],
      options: ContextMenuOptions(
        hideDefaultSystemContextMenuItems: false
      ),
      onCreateContextMenu: (hitTestResult) async {
        //print("onCreateContextMenu");
        print(hitTestResult.extra);
        print(await webView.getSelectedText());
      },
      onHideContextMenu: () {
        //print("onHideContextMenu");
      },
      onContextMenuActionItemClicked: (contextMenuItemClicked) async {
        var id = (Platform.isAndroid) ? contextMenuItemClicked.androidId : contextMenuItemClicked.iosId;
       // print("onContextMenuActionItemClicked: " + id.toString() + " " + contextMenuItemClicked.title);
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("${widget.title}")
      ),
      body: SafeArea(
          child: Column(children: <Widget>[
            SizedBox(
              height: 1.5,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>( Color(0XFFf60bff) ),
              ),
            ),
            Container(
              height: 300,
              child: InAppWebView(
                contextMenu: contextMenu,
                // initialUrl: "https://youku.cdn7-okzy.com/20191031/15585_f75875d5/index.m3u8", //"http://api.baiyug.vip/index.php?url=" + widget.url, // "https://github.com/flutter",
                initialFile: "assets/video/index.html",
                initialHeaders: {},
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: false,
                    useShouldOverrideUrlLoading: true,
                    verticalScrollBarEnabled: false,
                    horizontalScrollBarEnabled: false,
                    transparentBackground: true,
                    preferredContentMode: UserPreferredContentMode.MOBILE,
                    disableVerticalScroll: true,
                    disableHorizontalScroll: true,
                    disableContextMenu: true
                  ),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  setState(() {
                    webView = controller;
                  });

                  controller.addJavaScriptHandler(handlerName: 'fullscreen', callback: (args) {
                    print("开启全屏"+args.toString());
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.landscapeLeft,
                    ]);
                  });

                  controller.addJavaScriptHandler( handlerName: 'fullscreen_cancel', callback: (args) {
                    print("取消全屏"+args.toString());
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                  });
                  print("onWebViewCreated");
                },
                onLoadStart: (InAppWebViewController controller, String url) {
                  print("onLoadStart $url");
                },
                shouldOverrideUrlLoading: (controller, shouldOverrideUrlLoadingRequest) async {
                  print("shouldOverrideUrlLoading");
                  return ShouldOverrideUrlLoadingAction.ALLOW;
                },
                onLoadStop: (InAppWebViewController controller, String url) async {
                  // 发送到JavaScript
                  webView.evaluateJavascript(source: "window.appSendJsData()");
                  
                },
                onProgressChanged: (InAppWebViewController controller, int progress) {
                  // 页面进度条
                },
                onUpdateVisitedHistory: (InAppWebViewController controller, String url, bool androidIsReload) {
                  print("页面更新： $url");
                },
                onJsAlert: (InAppWebViewController controller, String message) async {
                  print('收到--$message');
                },
                onConsoleMessage: (InAppWebViewController controller, ConsoleMessage message){
                  print('打印html数据$message');
                },
              ),
            ),
          ]
        )
      )
    );
  }
}