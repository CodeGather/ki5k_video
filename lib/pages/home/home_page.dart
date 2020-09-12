/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-07 13:43:57
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-07 19:30:48
 * @Description: 
 */

import 'dart:isolate';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:jokui_video/api/Api.dart';
import 'package:jokui_video/models/video_list.dart';
import 'package:jokui_video/pages/home/search/search_page.dart';
import 'package:jokui_video/pages/play/video_page.dart';
import 'package:jokui_video/utils/isolate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../utils/expand/color.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<VideoDetail> listData = [];
  List<VideoType> tabData = [];
  SwiperController swiperController = new SwiperController();
  ScrollController _gridViewController = ScrollController();
  ScrollController _scrollController = ScrollController();
  TabController _tabController;
  bool showTop = false;

  RefreshController _refreshController = RefreshController(initialRefresh: true);
  int pageIndex = 1;

  @override
  void initState() {
    super.initState();

    print('首页');
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
          // controller: _scrollController,
          physics: NeverScrollableScrollPhysics(),
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
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_){
                            return SearchVideoPage( );
                          })
                        );
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
                              Colors.black12,
                              Colors.black12,
                              Colors.black12,
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
                              child: Text(
                                '重生',
                                style: TextStyle(
                                  fontSize: 15
                                ),
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
                bottom: new PreferredSize(
                  preferredSize: const Size.fromHeight(48.0),
                  child:  tabData.length == 0 ? Container() : Row(
                    children: <Widget>[
                      Expanded(
                        child: TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          tabs: getTabItem,
                          onTap: (int index){
                            print('选中${tabData[index].typeId}');
                            setState(() {
                              // loadStatus = LoadStatus.SUCCESS;
                            });
                            _refreshController.requestRefresh();
                            // _loadPageData(true, 1,);
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
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: NotificationListener(
          onNotification: notificationFunction,
            child: SmartRefresher(
              controller: _refreshController,
              scrollController: _scrollController,
              enablePullUp: listData.length != 0,
              child: listData.length==0 ? Container(
                padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                child: Center(
                  child: Text('数据加载中...'),
                ),
              ) : Container(
                padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 0.6,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: listData.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        print('当前点击${listData[index].vodId}');
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_){
                            return VideoPage( listData[index].vodId );
                          })
                        );
                      },
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: Stack(
                                children: [
                                  !listData[index].status ? Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Icon(
                                      Icons.image,
                                      size: 30,
                                      color: Colors.grey[600],
                                    )
                                  ) : ExtendedImage.network(
                                    listData[index].vodPic ?? 'https://via.placeholder.com/135x180?text=loading',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    clearMemoryCacheWhenDispose: true,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                        )
                                      ),
                                      child: Text(
                                        '${listData[index].vodRemarks}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil.getInstance().getSp(9)
                                        )
                                      ),
                                    )
                                  ),
                                ]
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10
                              ),
                              child: Text(
                                '${listData[index].vodName}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().getSp(12)
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              header: MaterialClassicHeader(
                color: Theme.of(context).primaryColor
              ),
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowAlways,
                completeDuration: Duration(milliseconds: 100),
              ),
              onRefresh: () async {
                isolatePageData(listData, pageIndex, true);
              },
              onLoading: () async {
                // 判断是否可以加载数据
                if(_refreshController.isLoading){
                  pageIndex++;
                  isolatePageData(listData, pageIndex, false);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  // 加载tab选项
  List<Widget> get getTabItem {
    List<Widget> list = [];
    tabData.forEach((item) {
      list.add(Tab(
        child: Text('${item?.typeName}'),
      ));
    });
    return list;
  }


  bool notificationFunction(Notification notification) {
    ///通知类型
    switch (notification.runtimeType) {
      case ScrollStartNotification:
        print("开始滚动------------");
        ///在这⾥更新标识 刷新⻚⾯ 不加载图⽚
        // isLoadingImage = false;
        break;
      case ScrollUpdateNotification:
        // print("正在滚动");
        // print(_scrollController.position.pixels);
        break;
      case ScrollEndNotification:
        loadingPic();
      break;
      case OverscrollNotification:
        print("滚动到边界");
        break;
    }
    return true;
  }

  void loadingPic(){
    DefaultCacheManager().emptyCache();
    ///在这⾥更新标识 刷新⻚⾯ 加载图⽚
    List<VideoDetail> screenData = [];

    print((MediaQuery.of(context).size.height / ((MediaQuery.of(context).size.width - 20) / 3 / 0.6)).floor());
    int itemCount = (MediaQuery.of(context).size.height / ((MediaQuery.of(context).size.width - 20) / 3 / 0.6)).floor() * 3;
    double itemHeight = (MediaQuery.of(context).size.width - 20) / 3 / 0.6;
    int screenItem = (_scrollController.position.pixels / (itemHeight+10)).ceil() * 3;
    print('高度$itemHeight');
    
    for(int i=0; i< listData.length; i++){
      VideoDetail element = listData[i];
      if((screenItem-6) <= i && (screenItem+24) > i){
        element.status = true;
      } else {
        DefaultCacheManager().removeFile(element.url);
        element.status = false;
      }
      screenData.add(element);
    }
    print('隐藏的数量$screenItem');
    
    setState(() {
      listData = screenData;
    });
  }

String result = '';
  SendPort blueSender;
  Isolate isolate;

  // 获取随机数
  int getRandom() {
    int a = Random().nextInt(100);
    return a + 1000000000;
  }
  
  // 创建isolate
  Future<void> createIsolate() async {
    // 创建小红的接收器，用来接收小蓝的发送器
    ReceivePort redReceive = ReceivePort();
    // 创建 isolate， 并且把小红的发送器传给小蓝
    isolate = await Isolate.spawn<SendPort>(blueCounter, redReceive.sendPort);
    // 等待小蓝把发送器发送给小红
    blueSender = await redReceive.first;
    // 不用了记得关闭接收器
    redReceive.close();
  }

  // 利用compute计算
  computeCount() async {
    int random = getRandom();
    // compute 的回调函数必须是顶级函数或者static函数
    int r = await compute(countEven, random);
    setState(() {
      this.result = '${random.toString()}有${r.toString()}个偶数';
    });
  }

  // 开启isolate计算
  isolatePageData(List<VideoDetail>list, int pageIndex, bool status) async {
    // 创建一个临时传送装置
    ReceivePort _temp = ReceivePort();
    if(blueSender == null ){
      await createIsolate();
    }
    // 用小蓝的发送装置发送一个消息包裹，里面是临时传送装置的发送器和要计算的数字
    blueSender.send(MessagePackage(_temp.sendPort, pageIndex, list, status, false));
    // 等待临时传送装置返回计算结果
    List<VideoDetail> resultData = await _temp.first;
    _temp.close();
    // 把计算结果告诉观众
    setState(() {
      if (resultData.isNotEmpty) {
        listData = resultData;
        if ( status ) {
          _refreshController.refreshCompleted();
        } else {
          _refreshController.loadComplete();
        }
      } else {
        if ( status ) {
          _refreshController.resetNoData();
        } else {
          _refreshController.loadNoData();
        }
      }
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
