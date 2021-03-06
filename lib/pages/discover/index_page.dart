/* 
 * @Author: 21克的爱情
 * @Date: 2020-03-29 09:24:01
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-09 12:13:46
 * @Description: 
 */
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

import 'discover_view_web.dart';
// import 'package:xml_parser/xml_parser.dart';


class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with TickerProviderStateMixin{
  AnimationController animationController;
  
  @override
  void initState() {
    super.initState();

    animationController = AnimationController( duration: const Duration(milliseconds: 1000), vsync: this );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  // void loadingData() async {
  //   final versionXml = await XmlDocument.fromUri('https://github.com/CodeGather/ki5k_video/releases');

  //   if (versionXml == null) {
  //     throw ('Failed to load page.');
  //   }
    
  //   String version = versionXml.getElementWhere(
  //       name: 'h6',
  //       attributes: [XmlAttribute('class', 'version')],
  //     )
  //     .getChild('span')
  //     .text;
  //   print(version);

  // }

  Widget buildWidget(){
    List<Widget> listViews = [];
    List<Map<String, String>> videoList = [
      {'title': '爱奇艺', 'url': 'https://m.iqiyi.com'},
      {'title': '优酷视频', 'url': 'https://m.youku.com/'},
      {'title': '腾讯视频', 'url': 'https://m.v.qq.com/index.html'},
      {'title': 'PP视频', 'url': 'https://m.pptv.com'},
      {'title': '搜狐视频', 'url': 'https://m.tv.sohu.com'},
      {'title': '哔哩哔哩', 'url': 'https://m.bilibili.com/index.html'}
    ];
    
    for(int i =0; i< videoList.length; i++){
      listViews.add(
        ListItem(
          videoList[i],
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve: Interval((1 / videoList.length) * i, 1.0, curve: Curves.fastOutSlowIn)),
          ),
          animationController: animationController,
        ),
      );
    }

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10
        ),
        child: listViews.length > 0 ? GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10, 
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            childAspectRatio: 1.5,
          ),
          shrinkWrap: true,
          itemCount: listViews.length,
          itemBuilder: (BuildContext context, int index) {
            return listViews[index];
          }
        ) : Container()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(movement.value);
    return Scaffold(
      // drawer: ConstrainedBox(
      //   child: Drawer(
      //     child: ListView(
      //       children: <Widget>[
      //         UserAccountsDrawerHeader(
      //           accountName: Text("21克的爱情"),
      //           accountEmail: Text("raohong07@163.com"),
      //           currentAccountPicture: CircleAvatar(
      //             backgroundImage: NetworkImage("http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg"),
      //           ),
      //           onDetailsPressed: () {
      //             print("!!!!!!!!");
      //             // loadingData();
      //             // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //             //   return AboutPage();
      //             // }));
      //           }
      //         ),
      //         ListTile(
      //           title: Text("还没想好"),
      //           subtitle: Text("这里做点啥呢"),
      //           leading: CircleAvatar(
      //             child: Icon(Icons.home),
      //           ),
      //           onTap: () => print("Title1"),
      //         ),
      //       ],
      //     ),
      //   ),
      //   constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width*0.7),
      // ),
      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
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
                      // Scaffold.of(ctx).openDrawer();
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
            buildWidget()
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final Map data;
  final Animation animation;
  final AnimationController animationController;
  const ListItem(this.data, {Key key, this.animation, this.animationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues( 0.0, 30 * (1.0 - animation.value), 0.0 ),
            child: SizedBox(
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
                  print('${data["title"]}');
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return VideoWebPlayPage(data["url"]);
                  }));
                },
                child: Text('${data["title"]}'),
              ), 
            ),
          ),
        );
      },
    );
  }
}