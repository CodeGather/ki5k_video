/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-07 13:42:04
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-10 09:00:59
 * @Description: 
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:jokui_video/models/video_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<VideoList> listData = [];
  List<VideoType> tabData = [];
  SwiperController swiperController = new SwiperController();
  ScrollController _gridViewController = ScrollController();
  ScrollController _scrollController = ScrollController();
  TabController _tabController;
  bool showTop = false;

  @override
  void initState() {
    super.initState();

    print('首页');
    loadList();
    _scrollController.addListener((){
      int pixels = _scrollController.position.pixels.toInt();
      print(pixels);
      if( pixels > 90 && !showTop ){
        setState(() {
          showTop = true;
        });
      } else if( pixels < 90 && showTop ){
        setState(() {
          showTop = false;
        });
      }
    });
  }

  void loadList() async {
    var url = 'https://wechat.ki5k.com/api/video/video/index?limit%20=%2010&page=1';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        listData = getVideoListList(jsonResponse['data']['list']);
        tabData = getVideoTypeList(jsonResponse['data']['type']);
        _tabController = new TabController(vsync: this, length: tabData.length);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[300],
      child: Scaffold(
        floatingActionButton: showTop
            ? InkWell(
                onTap: () {
                  print('返回顶部');
                  _scrollController.animateTo(0.0,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.easeIn,);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                  ),
                ),
              )
            : Container(),
        body: NestedScrollView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool type) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        print('打开搜索界面');
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 15),
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue[600],
                              Colors.blue[400],
                              Colors.blue[600],
                            ],
                            begin: FractionalOffset(1, 0),
                            end: FractionalOffset(0, 1),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(
                              Icons.search,
                            ),
                            Expanded(
                              child: Center(
                                child: Text('重生'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                    InkWell(
                      onTap: () {
                        print('打开历史记录');
                      },
                      child: Icon(
                        Icons.timer,
                      ),
                    )
                  ],
                ),
                bottom: tabData.length == 0
                    ? null
                    : new PreferredSize(
                        preferredSize: const Size.fromHeight(48.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TabBar(
                                isScrollable: true,
                                controller: _tabController,
                                tabs: getTabItem,
                                onTap: (int index){
                                  print('选中${tabData[index].id}');
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                print('打开菜单');
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 12),
                                  child: Icon(
                                    Icons.list,
                                    color: Colors.white,
                                  )),
                            )
                          ],
                        ),
                      ),
              ),
            ];
          },
          body: Container(
            padding: EdgeInsets.only(top: 5),
            child: listData.length == 0
                ? Container(
                    child: Center(
                      child: Text('数据加载中...'),
                    ),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: 0.75,
                    ),
                    // reverse: true,
                    // physics: NeverScrollableScrollPhysics(),
                    // shrinkWrap: true,
                    // controller: _gridViewController,
                    itemCount: listData.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          print('当前点击${listData[index].id}');
                        },
                        child: Container(
                          child: new CachedNetworkImage(
                            fit: BoxFit.fill,
                            placeholder: (context, url) {
                              return Image.asset(
                                'assets/images/loading.png',
                                fit: BoxFit.cover,
                              );
                            },
                            imageUrl: listData[index].detailImage ??
                                'https://via.placeholder.com/120x180?text=loading',
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                decoration: BoxDecoration(
                                  // shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: imageProvider,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
    Column(
      children: <Widget>[
        Container(
          color: Colors.red,
          height: 200,
          child: Swiper(
              // physics: NeverScrollableScrollPhysics(),  // 禁止左右滑动
              itemBuilder: (BuildContext context, int index) {
                switch (index) {
                  case 0:
                    return Text('00000');
                  case 1:
                    return Text('data');
                  default:
                    return Text('33333');
                }
              },
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              loop: true,
              autoplay: true,
              controller: swiperController,
              onIndexChanged: (index) {
                debugPrint("切换下标:$index");
              },
              autoplayDisableOnInteraction: true),
        ),
      ],
    );
  }

  List<Widget> get getTabItem {
    List<Widget> list = [];
    tabData.forEach((item) {
      list.add(Tab(
        child: Text('${item?.name}'),
      ));
    });
    return list;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
