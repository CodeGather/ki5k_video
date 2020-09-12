/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-07 13:42:44
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-06-23 16:33:21
 * @Description: 
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PersonalPage extends StatefulWidget {
  PersonalPage({Key key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  InAppWebViewController webView;
  ContextMenu contextMenu;
  @override
  void initState() { 
    super.initState();
    print('个人中心');

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
  Widget build(BuildContext context) {
    return Container(
       child: Center(
          child: Container(
            height: 300,
            child: InAppWebView(
              contextMenu: contextMenu,
              initialUrl: "https://pianku.tv",
              // initialFile: "assets/video/index.html",
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
       ),
    );
  }
}