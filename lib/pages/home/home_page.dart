/* 
 * @Author: 21克的爱情
 * @Date: 2020-03-29 09:24:01
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-23 16:59:22
 * @Description: 
 */
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:jokui_video/plugins/videoPlugin/src/videoTheme.dart';
import 'package:jokui_video/utils/utils.dart';
import 'package:xml_parser/xml_parser.dart';

import 'animation_page.dart';
import 'home_view_web.dart';
import 'login_privacy.dart';
import 'video_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  AnimationController _controller;
  Animation<EdgeInsets> movement;

  void _initController() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  void _initAni() {
    movement = EdgeInsetsTween(
      begin: EdgeInsets.only(top: 0.0, left: 10, right: 10),
      end: EdgeInsets.only(top: 20.0, left: 10, right: 10),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval( 0, 1, curve: Curves.bounceOut, ),
      ),
    )
    ..addListener(() {
      setState(() {});
    })
    ..addStatusListener((AnimationStatus status) {
      print('-------$status');
    });
  }

  Future _startAnimation() async {
    try {
      // await _controller.repeat();
     await _controller
         .forward()
         .orCancel;
    //  await _controller
    //      .reverse()
    //      .orCancel;
    } on TickerCanceled {
      print('Animation Failed');
    }
  }

  List webVideo = [];
  @override
  void initState() {
    super.initState();

    webVideo = [
      {'title': '爱奇艺', 'url': 'https://m.iqiyi.com'},
      {'title': '优酷视频', 'url': 'https://m.youku.com/'},
      {'title': '腾讯视频', 'url': 'https://m.v.qq.com/index.html'},
      {'title': 'PP视频', 'url': 'https://m.pptv.com'},
      {'title': '搜狐视频', 'url': 'https://m.tv.sohu.com'},
      {'title': '哔哩哔哩', 'url': 'https://m.bilibili.com/index.html'}
    ];
    _initController();
    _initAni();
    _startAnimation();
  }

  void loadingData() async {
    final packagePage = await XmlDocument.fromUri('https://pub.flutter-io.cn/packages/xml_parser');

    if (packagePage == null) {
      throw ('Failed to load page.');
    }
    print(packagePage);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(movement.value);
    return Scaffold(
      drawer: ConstrainedBox(
        child: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("21克的爱情"),
                accountEmail: Text("raohong07@163.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg"),
                ),
                onDetailsPressed: () {
                  print("!!!!!!!!");
                }
              ),
              ListTile(
                title: Text("还没想好"),
                subtitle: Text("这里做点啥呢"),
                leading: CircleAvatar(
                  child: Icon(Icons.home),
                ),
                onTap: () => print("Title1"),
              ),
            ],
          ),
        ),
        constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width*0.7),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF9271e2),
              Theme.of(context).primaryColor,
            ],
            begin: FractionalOffset(1, 1),
            end: FractionalOffset(0, 0),
          ),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Builder(builder: (BuildContext ctx){
                  return IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: ScreenUtil.getInstance().getSp(30),
                    ),
                    onPressed: (){
                      print('打开侧边栏');
                      Scaffold.of(ctx).openDrawer();
                    }
                  );
                }),
              ],
            ),
            Container(
              margin: EdgeInsets.all( ScreenUtil.getInstance().getWidth(40)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all( Radius.circular(10) ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        // 标题
                        Padding(
                          padding: EdgeInsets.only(
                            top: ScreenUtil.getInstance().getWidth(15),
                          ),
                          child: Text(
                            'KI5K影视站',
                            style: TextStyle(
                              fontSize: ScreenUtil.getInstance().getSp(26),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              shadows: [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Theme.of(context).primaryColor,
                                  spreadRadius: 10,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 描述
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20
                          ),
                          child: Text(
                            '欢迎来到ki5k影视站, 在本APP所有资源均来自互联网，并且不存储任何隐私数据，对所有产生的一切涉及法律问题概不负责，尽情知晓！',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 10),
                          ),  
                        )
                      ], 
                    ),
                  ),
                  // 提示入口
                  Container(
                    padding: EdgeInsets.only(
                      top: 5,
                      bottom: 15
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      '从下面入口进入您需要看视频的站点',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 12,color:Colors.blue,fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 5 
                ),
                child: webVideo.length > 0 ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 0, 
                    mainAxisSpacing: 0,
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                  ),
                  shrinkWrap: true,
                  itemCount: webVideo.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Positioned(
                            top: movement.value.top,
                            child: SizedBox(
                              width: ScreenUtil.getInstance().getWidth(110),
                              height: ScreenUtil.getInstance().getWidth(60),
                              child: FlatButton(
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10),),
                                side: BorderSide(
                                  color: Color(0xFFF9F3FF), 
                                  style: BorderStyle.solid, width: 1,
                                ),
                              ),
                              onPressed: () {
                                print('${webVideo[index]["url"]}');
                                // if(webVideo[index]["url"]=='1'){
                                //   _controller.forward();
                                // } else {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                    // if(webVideo[index]["url"]=='#'){
                                    //   return AnimationPage();
                                    // } else {
                                      return ViewWebPage(webVideo[index]["url"]);
                                    // }
                                    // return NetworkPage();
                                  }));
                                // }
                              },
                              child: Text('${webVideo[index]["title"]}'),
                            ), 
                            )
                          ),
                        ],
                      ),
                    );
                  },
                ) : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
