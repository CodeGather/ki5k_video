/* 
 * @Author: 21克的爱情
 * @Date: 2020-03-29 09:24:01
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-19 21:44:07
 * @Description: 
 */
import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jokui_video/utils/request.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'video_page.dart';

class ViewWebPage extends StatefulWidget {
  final String url;
  ViewWebPage(this.url, {Key key}) : super(key: key);
  @override
  _ViewWebPageState createState() => _ViewWebPageState();
}

class _ViewWebPageState extends State<ViewWebPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  String palyUrl;
  bool showPlay = false;
  bool isLoad = true;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        WebViewController data = await _controller.future;
        if (await data.canGoBack()) {
          await data.goBack();
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: NavigationControls(_controller.future),
          ),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Stack(
              children: [
                WebView(
                  // http://www.58mov.com/addons/dplayer/?url=https://cn1.18787000118.com/hls/20200303/899f477f76d7e6905fe7ad07a4ec5a9c/index.m3u8
                  // http://you.tube-kuyun.com/share/201e5bacd665709851b77148e225b332
                  // https://youku.cdn4-okzy.com/share/aac933717a429f57c6ca58f32975c597
                  // https://hls.aoxtv.com/v3.szjal.cn/share/WNxNlhTYKQX22H2N
                  // http://jx.vipkk.cc/jiexi/?url=http://v.qq.com/x/cover/mzc002009mrek37/g00330i69rb.html
                  // initialUrl: 'https://jx.wlzy.tv/jx.php?url=http://qiaozhen.com.cn/share/MzM4Nzk1JOesrDHpm4Y=',
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                    // _onNavigationDelegateExample(webViewController, context);
                  },
                  userAgent: 'Mozilla/5.0 (Linux; Android 10; SM-G975U) MicroMessenger/537.36 (KHTML, like Gecko) Chrome/79.0.3945.93 Mobile Safari/537.36',
                  javascriptChannels: <JavascriptChannel>[
                    // _toasterJavascriptChannel(context),
                  ].toSet(),
                  navigationDelegate: (NavigationRequest request) {
                    debugPrint('allowing navigation to ${request.url}');
                    if (request.url.endsWith('meirichoujinagqunyingdao') || request.url.indexOf('pkgname=') > -1) {
                      debugPrint('blocking navigation to request');
                      return NavigationDecision.prevent;
                    }
                    setState(() {
                      // if (request.url != null &&
                      //     request.url.isNotEmpty &&
                      //     (request.url.split("?")[0].indexOf(".html") > -1)) {
                      // } else {
                      //   showPlay = false;
                      // }
                      showPlay = true;
                    });
                    return NavigationDecision.navigate;
                  },
                  onPageStarted: (String data){
                    debugPrint('Page PageStarted loading: $data');
                  },
                  onPageFinished: (String url) {
                    debugPrint('Page finished loading: $url');
                    setState(() {
                      showPlay = true;
                      // if (url != null && url.isNotEmpty && (url.split("?")[0].indexOf(".html") > -1)) {
                      // } else {
                      //   showPlay = false;
                      // }
                      isLoad = false;

                      // _controller.future.then((controller) async {  
                      //   Size screen = MediaQuery.of(context).size;
                      //   // 执行js 代码
                      //   await controller.evaluateJavascript('play()');
                      // });
                    });
                  },
                ),
                isLoad ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Container(
                        margin: EdgeInsets.only(
                          top: 30,
                        ),
                        child: Text('页面加载中...'),
                      )
                    ]
                  )
                ) : Container()
              ]
            );
          },
        ),
        floatingActionButton: showPlay ? favoriteButton() : Container(),
      ), 
    );
  }

  // 播放按钮
  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return FloatingActionButton(
            onPressed: () async {
              String url = await controller.data.currentUrl();
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return HomeVideoPage(url);
              }));
            },
            child: const Icon(Icons.play_arrow),
          );
        }
        return Container();
      },
    );
  }
}

// 头部导航处理
class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture) : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady = snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: !webViewReady
                          ? null
                          : () async {
                              if (await controller.canGoBack()) {
                                await controller.goBack();
                              } else {
                                Scaffold.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("No back history item"),
                                  ),
                                );
                                return;
                              }
                            },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: !webViewReady
                        ? null
                        : () async {
                            if (await controller.canGoForward()) {
                              await controller.goForward();
                            } else {
                              Scaffold.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("No forward history item"),
                                ),
                              );
                              return;
                            }
                          },
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay),
                      onPressed: !webViewReady
                        ? null
                        : () {
                            controller.reload();
                          },
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: !webViewReady
                  ? null
                  : () {
                      Navigator.of(context).pop();
                    },
              ),
            ],
          ),
        );
      },
    );
  }
}
