/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-07 13:43:57
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-28 13:25:05
 * @Description: 
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:jokui_video/api/Api.dart';
import 'package:jokui_video/models/video_list.dart';
import 'package:jokui_video/pages/home/search/search_page.dart';
import 'package:jokui_video/pages/play/video_page.dart';
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
    // _scrollController.addListener((){
    //   int pixels = _scrollController.position.pixels.toInt();
    //   print(pixels);
    //   if( pixels > 90 && !showTop ){
    //     setState(() {
    //       showTop = true;
    //     });
    //   } else if( pixels < 90 && showTop ){
    //     setState(() {
    //       showTop = false;
    //     });
    //   }
    // });
  }

  // 加载首页数据
  void _loadPageData( bool type, int page ) async {
    // var url = 'https://wechat.ki5k.com/api/video/video/index?limit%20=%2010&page=1';

    // // Await the http get response, then decode the json-formatted response.
    // var response = await http.get(url);
    // if (response.statusCode == 200) {
    //   var jsonResponse = convert.jsonDecode(response.body);
    //   setState(() {
    //     listData = getVideoListList(jsonResponse['data']['list']);
    //     tabData = getVideoTypeList(jsonResponse['data']['type']);
    //     _tabController = new TabController(vsync: this, length: tabData.length);
    //   });
    // } else {
    //   print('Request failed with status: ${response.statusCode}.');
    // }

    final typePid = tabData.length > 0 && tabData[_tabController?.index].typePid !=0 ? tabData[_tabController?.index].typeId : '';
    await Api.getVideoList({
      'ac': 'list',
      'pg': page,
      't': typePid
    }).then((value){
      print(value);
      if( value != null && value['code'] == 1 ){
        // 获取列表数据
        setState(() {
          if(tabData.length ==0 ){
            tabData = getVideoTypeList(value['class']);//..retainWhere((item)=> item.typePid != 0);
            _tabController = new TabController(vsync: this, length: tabData.length);
          }
          if( type ){
            listData = getVideoListList(value['list']);
            pageIndex = 1;
            _refreshController.refreshCompleted();
          } else {
            listData.addAll(getVideoListList(value['list']));
            _refreshController.loadComplete();
          }
        });
        // 判断获取数据的是否是否满足没有更多数据的情况
        if( value['pagecount'] == page ){
          _refreshController.loadNoData();
        } else {
          _refreshController.resetNoData();
        }
      } else {
        // 请求失败的情况
        if( type ){
          _refreshController.refreshFailed();
        } else {
          _refreshController.loadFailed();
        }
      }
    }).catchError((error){});
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
          body: SmartRefresher(
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
                            child: new CachedNetworkImage(
                              fit: BoxFit.fill,
                              placeholder: (context, url) {
                                return Image.asset(
                                  'assets/images/loading.png',
                                  fit: BoxFit.cover,
                                );
                              },
                              imageUrl: listData[index].vodPic ?? 'https://via.placeholder.com/135x180?text=loading',
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: imageProvider,
                                    ),
                                  ),
                                  child: listData[index].vodRemarks != null && listData[index].vodRemarks.isNotEmpty ? Stack(
                                    children: <Widget>[
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5)
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
                                    ],
                                  ) : null,
                                );
                              },
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
              _loadPageData(true, 1,);
            },
            onLoading: () async {
              // 判断是否可以加载数据
              if(_refreshController.isLoading){
                pageIndex++;
                _loadPageData(false, pageIndex,);
              }
            },
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
