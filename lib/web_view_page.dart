/* 
 * @Author: 21克的爱情
 * @Date: 2020-03-29 09:24:01
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-07-12 09:01:56
 * @Description: 
 */
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  void _onNavigationDelegateExample(
      WebViewController controller, BuildContext context) async {
    String html = await DefaultAssetBundle.of(context).loadString('assets/html/agree/index.html');
    final String htmlBase64 = base64Encode(const Utf8Encoder().convert(html));
    //debugPrint('csss ==== $html');
    controller.loadUrl('data:text/html;base64,$htmlBase64');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(48),
        child: AppBar(
          title: const Text('视频首页'),
          actions: <Widget>[
            // SampleMenu(_controller.future),
          ],
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return WebView(
            // http://www.58mov.com/addons/dplayer/?url=https://cn1.18787000118.com/hls/20200303/899f477f76d7e6905fe7ad07a4ec5a9c/index.m3u8
            // http://you.tube-kuyun.com/share/201e5bacd665709851b77148e225b332
            // https://youku.cdn4-okzy.com/share/aac933717a429f57c6ca58f32975c597
            // https://hls.aoxtv.com/v3.szjal.cn/share/WNxNlhTYKQX22H2N
            // http://jx.vipkk.cc/jiexi/?url=http://v.qq.com/x/cover/mzc002009mrek37/g00330i69rb.html
            initialUrl: 'https://jx.wlzy.tv/jx.php?url=http://qiaozhen.com.cn/share/MzM4Nzk1JOesrDHpm4Y=',
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
              // if (request.url.startsWith('http://yda.hcyyrd.cn/')) {
              //   debugPrint('blocking navigation to request');
              //   return NavigationDecision.prevent;
              // }
              debugPrint('allowing navigation to request');
              _controller.future.then((controller) async {  
                // Size screen = MediaQuery.of(context).size;
                // 执行js 代码
                // await controller.evaluateJavascript('function onReady(e){var n=document.readyState;"interactive"===n||"complete"===n?e():window.addEventListener("DOMContentLoaded",e)}onReady(function(){console.log("DOM fully loaded and parsed "),document.querySelector("[id^=\'acz\']").parentElement.style.display="none"});document.querySelector("brde").style.display = "none";');
              });
              return NavigationDecision.navigate;
            },
            
            onPageFinished: (String url) {
              debugPrint('Page finished loading: $url');
              _controller.future.then((controller) async {  
                // Size screen = MediaQuery.of(context).size;
                // 执行js 代码
                // await controller.evaluateJavascript('function onReady(e){var n=document.readyState;"interactive"===n||"complete"===n?e():window.addEventListener("DOMContentLoaded",e)}onReady(function(){console.log("DOM fully loaded and parsed "),document.querySelector("[id^=\'acz\']").parentElement.style.display="none"});document.querySelector("brde").style.display = "none";');
              });
            },
          );
        },
      ),
      // floatingActionButton: favoriteButton(),
    );
  }

  // dart 调用js代码 Toaster.postMessage('打印');
  // JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
  //   return JavascriptChannel(
  //     name: 'Toaster',
  //     onMessageReceived: (JavascriptMessage message) {
  //       Scaffold.of(context).showSnackBar(
  //         SnackBar(content: Text(message.message)),
  //       );
  //     },
  //   );
  // }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return FloatingActionButton(
            onPressed: () async {
              final String url = await controller.data.currentUrl();
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Favorited $url')),
              );
            },
            child: const Icon(Icons.favorite),
          );
        }
        return Container();
      },
    );
  }
}
