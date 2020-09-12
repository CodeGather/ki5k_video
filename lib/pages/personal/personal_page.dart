/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-07 13:42:44
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-07-01 14:36:56
 * @Description: 
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'full_screen.dart';

class PersonalPage extends StatefulWidget {
  PersonalPage({Key key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  InAppWebViewController webView;
  ContextMenu contextMenu;
  HeadlessInAppWebView headlessWebView;
  @override
  void initState() { 
    super.initState();
    print('个人中心');

    // headlessWebView = new HeadlessInAppWebView(
    //   initialUrl: "https://pianku.tv",
    //   initialOptions: InAppWebViewGroupOptions(
    //     crossPlatform: InAppWebViewOptions(
    //       debuggingEnabled: true,
    //     ),
    //   ),
    //   onWebViewCreated: (controller) {
    //     print('HeadlessInAppWebView created!');
    //   },
    //   onConsoleMessage: (controller, consoleMessage) {
    //     print("CONSOLE MESSAGE: " + consoleMessage.message);
    //   },
    //   onLoadStart: (controller, url) async {
    //     print("onLoadStart $url");
    //   },
    //   onLoadStop: (controller, url) async {
    //     print("onLoadStop $url");
    //   },
    //   onUpdateVisitedHistory: (InAppWebViewController controller, String url, bool androidIsReload) {
    //     print("onUpdateVisitedHistory $url");
    //   },
    // );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Center(
         child: RaisedButton(
           onPressed: (){
             return Navigator.of(context).push(
               MaterialPageRoute(builder: (_){
                 return FullScreen();
               })
             );
           },
           child: Text("播放")
         ),
       ),
    );
    return Container(
       child: Center(
          child: Container(
            height: 600,
            child: InAppWebView(
              // contextMenu: contextMenu,
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
                  userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36",                  
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
                webView.evaluateJavascript(
                  source: """
                    (function(){
                      let data = document.getElementsByTagName("ins")
                      for(let i = 0; i<data.length; i++){
                        console.log(data[i])
                        data[i].style.opacity=0
                        data[i].style.height=0
                      }
                    })()
                  """
                );
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