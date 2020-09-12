/* 
 * @Author: 21克的爱情
 * @Date: 2020-09-03 12:53:54
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-08 16:18:45
 * @Description: 
 */
import 'dart:isolate';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ki5k_video/api/Api.dart';
import 'package:ki5k_video/models/tab_list.dart';
import 'package:ki5k_video/models/video_list.dart';
import 'package:ki5k_video/provide/application_provide.dart';
import 'package:ki5k_video/utils/isolate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xml/xml.dart';

import 'search_page.dart';
import 'video/video_detail_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();

  TabController _tabController;
  List<VideoType> tabData = [];
  String selectVideoType = '';


  bool showTab = false;

  @override
  void initState() { 
    super.initState();
    
    final data = ApplicationStatus.navigatorKey.currentContext;
    print(data);

    getTabData();
  }

  void getTabData() async {
    final value = await Api.getHomeVideo({
      'ac': '',
      't': '9999',
      'pg': 1
    });
    if( value != null && value.isNotEmpty ){
      final document = XmlDocument.parse(value);
      tabData = document.findAllElements('ty').toList().skip(4).toList().map((e){
        return VideoType.fromJson({
          'type_id' : e.attributes.last.value,
          'type_name': e.text
        });
      }).toList();
      _tabController = new TabController(length: tabData.length, vsync: this);
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController?.dispose();
    _scrollController?.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
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
                          Expanded(
                            child: Text(
                              '搜索视频',
                              style: TextStyle(
                                fontSize: 13
                              ),
                            ),
                          ),
                          Icon(
                            Icons.search,
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
                      Icons.query_builder,
                    ),
                  )
                ],
              ),
              bottom: new PreferredSize(
                preferredSize: Size.fromHeight( showTab ? 148 : 48.0),
                child: tabData.length == 0 ? Container() : Row(
                  children: <Widget>[
                    Expanded(
                      child: TabBar(
                        isScrollable: true,
                        controller: _tabController,
                        tabs: getTabItem,
                        onTap: (int index){
                          print('选中${tabData[index].typeId}');
                          setState(() {
                            selectVideoType = tabData[index].typeId;
                          });
                          // _refreshController.requestRefresh();
                          // _loadPageData(true, 1,);
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print('打开菜单');
                        setState(() {
                          // showTab = !showTab;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        child: Icon(
                          Icons.list,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: _tabController != null ? TabBarView(
          controller: _tabController,
          children: tabData.map((item){
            return RefreshListView(selectVideoType: selectVideoType);
          }).toList()
        ) : Container()
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

}
class RefreshListView extends StatefulWidget {
  final String selectVideoType;

  RefreshListView({Key key, this.selectVideoType}) : super(key: key);

  @override
  _RefreshListViewState createState() => _RefreshListViewState();
}

class _RefreshListViewState extends State<RefreshListView> {
  RefreshController _refreshController =  RefreshController(initialRefresh: true);
  List<VideoDetail> listDatas = [];
  SendPort blueSender;
  Isolate isolate;
  int pageIndex = 1;

  @override
  void initState() { 
    super.initState();
    
    createIsolate();
  }

  @override
  Widget build(BuildContext context) {
    // return NotificationListener(
    //       onNotification: notificationFunction,
    //       child: SmartRefresher(
    //         controller: _refreshController,
    //         // scrollController: _scrollController,
    //         enablePullUp: listDatas.length != 0,
    //         child: listDatas.length == 0 ? Container(
    //           padding: EdgeInsets.only(top: 5, left: 5, right: 5),
    //           child: Center(
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Icon(
    //                   Icons.movie_filter,
    //                   size: 80,
    //                   color: Colors.grey[300],
    //                 ),
    //                 Text(
    //                   '暂无视频数据',
    //                   style: TextStyle(
    //                     color: Colors.grey[500]
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ) : Container(
    //           padding: EdgeInsets.only(top: 5, left: 5, right: 5),
    //           child: GridView.builder(
    //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisCount: 3,
    //               mainAxisSpacing: 15,
    //               crossAxisSpacing: 6,
    //               childAspectRatio: 0.6,
    //             ),
    //             shrinkWrap: true,
    //             physics: NeverScrollableScrollPhysics(),
    //             itemCount: listDatas.length,
    //             scrollDirection: Axis.vertical,
    //             itemBuilder: (BuildContext context, int index) {
    //               return InkWell(
    //                 onTap: () {
    //                   // print('当前点击${listDatas[index].vodId}');
    //                   Navigator.of(context).push(
    //                     MaterialPageRoute(builder: (_){
    //                       return VideoDetailPage( listDatas[index].vodId );
    //                     })
    //                   );
    //                 },
    //                 child: Container(
    //                   child: Column(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: <Widget>[
    //                       Expanded(
    //                         child: Stack(
    //                           children: [
    //                             !listDatas[index].status ? Container(
    //                               alignment: Alignment.center,
    //                               decoration: BoxDecoration(
    //                                 color: Colors.grey[300],
    //                                 borderRadius: BorderRadius.all(Radius.circular(5)),
    //                               ),
    //                               child: Icon(
    //                                 Icons.image,
    //                                 size: 30,
    //                                 color: Colors.grey[600],
    //                               )
    //                             ) : ExtendedImage.network(
    //                               listDatas[index].vodPic ?? 'https://via.placeholder.com/135x180?text=loading',
    //                               fit: BoxFit.cover,
    //                               width: double.infinity,
    //                               height: double.infinity,
    //                               shape: BoxShape.rectangle,
    //                               borderRadius: BorderRadius.all(Radius.circular(5)),
    //                               clearMemoryCacheWhenDispose: true,
    //                             ),
    //                             listDatas[index].vodRemarks.isNotEmpty ? Positioned(
    //                               top: 0,
    //                               right: 0,
    //                               child: Container(
    //                                 padding: EdgeInsets.all(5),
    //                                 decoration: BoxDecoration(
    //                                   color: Colors.red,
    //                                   borderRadius: BorderRadius.only(
    //                                     bottomLeft: Radius.circular(5),
    //                                     topRight: Radius.circular(5),
    //                                   )
    //                                 ),
    //                                 child: Text(
    //                                   '${listDatas[index].vodRemarks.length < 8 ? listDatas[index].vodRemarks : listDatas[index].vodRemarks.substring(0,8)}',
    //                                   overflow: TextOverflow.clip,
    //                                   style: TextStyle(
    //                                     color: Colors.white,
    //                                     fontSize: ScreenUtil.getInstance().getSp(9)
    //                                   )
    //                                 ),
    //                               )
    //                             ) : Container(),
    //                           ]
    //                         ),
    //                       ),
    //                       Container(
    //                         padding: EdgeInsets.only(
    //                           top: 5
    //                         ),
    //                         alignment: Alignment.centerLeft,
    //                         child: Text(
    //                           '${listDatas[index].vodName}',
    //                           overflow: TextOverflow.ellipsis,
    //                           style: TextStyle(
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: ScreenUtil.getInstance().getSp(12)
    //                           ),
    //                         )
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               );
    //             },
    //           ),
    //         ),
    //         header: MaterialClassicHeader(
    //           color: Theme.of(context).primaryColor
    //         ),
    //         footer: ClassicFooter(
    //           loadStyle: LoadStyle.ShowAlways,
    //           completeDuration: Duration(milliseconds: 100),
    //         ),
    //         onRefresh: () async {
    //           pageIndex = 1;
    //           // initPageData(true);
    //           isolatePageData(listDatas, pageIndex, true);
    //           // initPageData(true);
    //         },
    //         onLoading: () async {
    //           // 判断是否可以加载数据
    //           if(_refreshController.isLoading){
    //             pageIndex++;
    //             // initPageData(false);
    //             isolatePageData(listDatas, pageIndex, false);
    //           }
    //         },
    //       ),
    //     );
    return SmartRefresher(
      // enablePullDown: true,
      enablePullUp: listDatas.length != 0,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("Release to Load more");
          } else {
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: () async {
      pageIndex = 1;
      // initPageData(true);
      isolatePageData(listDatas, pageIndex, true);
      // initPageData(true);
    },
    onLoading: () async {
      // 判断是否可以加载数据
      if(_refreshController.isLoading){
        pageIndex++;
        // initPageData(false);
        isolatePageData(listDatas, pageIndex, false);
      }
    },
        child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 15,
          crossAxisSpacing: 6,
          childAspectRatio: 0.6,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: listDatas.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              // print('当前点击${listDatas[index].vodId}');
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_){
                  return VideoDetailPage( listDatas[index].vodId );
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
                        !listDatas[index].status ? Container(
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
                          listDatas[index].vodPic ?? 'https://via.placeholder.com/135x180?text=loading',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          clearMemoryCacheWhenDispose: true,
                        ),
                        listDatas[index].vodRemarks.isNotEmpty ? Positioned(
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
                              '${listDatas[index].vodRemarks.length < 8 ? listDatas[index].vodRemarks : listDatas[index].vodRemarks.substring(0,8)}',
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil.getInstance().getSp(9)
                              )
                            ),
                          )
                        ) : Container(),
                      ]
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 5
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${listDatas[index].vodName}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil.getInstance().getSp(12)
                      ),
                    )
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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
    // DefaultCacheManager().emptyCache();
    // ///在这⾥更新标识 刷新⻚⾯ 加载图⽚
    // List<VideoDetail> screenData = [];

    // print((MediaQuery.of(context).size.height / ((MediaQuery.of(context).size.width - 20) / 3 / 0.6)).floor());
    // int itemCount = (MediaQuery.of(context).size.height / ((MediaQuery.of(context).size.width - 20) / 3 / 0.6)).floor() * 3;
    // double itemHeight = (MediaQuery.of(context).size.width - 20) / 3 / 0.6;
    // int screenItem = (_scrollController.position.pixels / (itemHeight+30)).ceil() * 3;
    // print('高度$itemHeight');
    
    // for(int i=0; i< listDatas.length; i++){
    //   VideoDetail element = listDatas[i];
    //   if((screenItem-6) <= i && (screenItem+24) > i){
    //     element.status = true;
    //   } else {
    //     // DefaultCacheManager().removeFile(element.url);
    //     element.status = false;
    //   }
    //   screenData.add(element);
    // }
    // print('隐藏的数量$screenItem');
    
    // setState(() {
    //   listDatas = screenData;
    // });
  }

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
    // int r = await compute(countEven, random);
  //  print('${random.toString()}有${r.toString()}个偶数');
  }

  // 开启isolate计算
  isolatePageData(List<VideoDetail>list, int pageIndex, bool status) async {
    // 创建一个临时传送装置
    ReceivePort _temp = ReceivePort();
    if(blueSender == null ){
      await createIsolate();
    }
    // 用小蓝的发送装置发送一个消息包裹，里面是临时传送装置的发送器和要计算的数字
    blueSender.send(MessagePackage(_temp.sendPort, pageIndex, widget.selectVideoType, list, status));
    // 等待临时传送装置返回计算结果
    List<VideoDetail> resultData = await _temp.first;
    _temp.close();
    // 把计算结果告诉观众
    setState(() {
      listDatas = resultData;
      if (resultData.isNotEmpty) {
        if ( status ) {
          _refreshController.refreshCompleted();
        } else {
          _refreshController.loadComplete();
        }
        loadingPic();
      } else {
        if ( status ) {
          _refreshController.refreshCompleted(resetFooterState: true);
        } else {
          _refreshController.loadNoData();
        }
      }
    });
  }

  // don't forget to dispose refreshController
  @override
  void dispose() {
    _refreshController.dispose();
    isolate?.kill(priority: Isolate.immediate);
    super.dispose();
  }
}
