import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:jokui_video/models/video_attr.dart';
import 'package:jokui_video/models/video_detail.dart';
import 'package:jokui_video/provide/application_provide.dart';
import 'package:jokui_video/utils/request.dart';
import 'package:provider/provider.dart';
import 'package:xml_parser/xml_parser.dart';

class HomeVideoPage extends StatefulWidget {
  final String url;
  HomeVideoPage(this.url, {Key key}):super(key: key);
  @override
  _HomeVideoPageState createState() => _HomeVideoPageState();
}

enum LoadStatus{
  ERROR,
  SUCCESS,
  LOADING,
  COMPLETE
}

class _HomeVideoPageState extends State<HomeVideoPage> with SingleTickerProviderStateMixin{
  IjkMediaController controller = IjkMediaController();
  double videoAspectRatio = 1.5;
  double dx=0.0;
  double dy=0.0;
  
  String title = '视频预览';
  VideoDetail videoDetail;
  List<VideoAttr> videoData = [];
  List<VideoAttr> apiData = [];
  TabController _tabController;
  LoadStatus loadStatus = LoadStatus.LOADING;

  List<Widget> get getTabItem {
    List<Widget> list = [];
    videoData.forEach((item) {
      list.add(
        Tab(
          child: Text(
            '${item?.title}-${_tabController.index}',
            style: TextStyle(
              color: Colors.red
            )
          ),
        ),
      );
    });
    return list;
  }

  @override
  void initState() {
    super.initState();

    if(!mounted) return;
    loadingData();
  }

  loadingData(){
    print(widget.url);
    HTTPTOOL.loadList(widget.url, success: (data) async {
      if (data != null && data['movieList'] != null ){
        formData( data );
      } else {
        setState(() {
          loadStatus = LoadStatus.ERROR;
        });
      }
    });
  }

  void formData( dynamic data ) async{
    XmlDocument xmlDocument = XmlDocument.fromString(data['movieList']);
    print(xmlDocument);
    
    // 视频数据
    XmlElement video = xmlDocument.getElement('list').getElement('video');
    // 时间
    String lastTime = video.getElement('last').text;
    // 名称
    String title = XmlCdata.fromString(video.getElement('name').text).value;
    // 类型
    String type = video.getElement('type').text;
    // 描述
    String updateDesc = XmlCdata.fromString(video.getElement('note').text).value;

    if( data['movieDetails'] != null && data['movieDetails'].length > 0 ){
      final dataArr = data['movieDetails'].map((item){
        List itemMap = item.split('\$');
        return {
          "title": "${itemMap[0]}",
          "url": "${itemMap[1]}",
        };
      }).toList();

      print(dataArr);

      setState(() {
        _tabController = new TabController(vsync: this, length: dataArr.length);
        loadStatus = LoadStatus.SUCCESS;
        videoDetail = VideoDetail.fromJson({
          'title': title,
          'url': data['videoUrl'],
          'anthology': updateDesc, // 选集
          'synopsis': '暂无', // 简介
          'list': dataArr
        });
        apiData = getVideoAttrList([ {
          "title": "线路1",
          "url": "https://jx.688ing.com/parse/op/play",
        // }, {
        //   "title": "线路2",
        //   "url": "http://v.yhgou.cc/2019/api.php",
        }]);
      });

      await controller.setNetworkDataSource(
        data['videoUrl'],
        // 'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4',
        // 'rtmp://172.16.100.245/live1',
        // 'https://www.sample-videos.com/video123/flv/720/big_buck_bunny_720p_10mb.flv',
//              "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
        // 'http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8',
        // "file:///sdcard/Download/Sample1.mp4",
        autoPlay: true
      );
      print("set data source success");
      
      // _controller = VideoPlayerController.network(
      //   data['videoUrl'],
      //   closedCaptionFile: _loadCaptions(),
      // )
      // ..addListener(() {
      //   // print(_controller);
      // })
      // ..initialize().then((_){
      //   print(_controller.value.aspectRatio);
      //   setState(() {
      //     videoAspectRatio = _controller.value.aspectRatio;
      //   });
      // })
      // ..setLooping(false)
      // ..play();
    }
  }

  // Future<ClosedCaptionFile> _loadCaptions() async {
  //   final String fileContents = await DefaultAssetBundle.of(context).loadString('assets/bumble_bee_captions.srt');
  //   return SubRipCaptionFile(fileContents);
  // }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ApplicationStatus fullScreenStatus = Provider.of<ApplicationStatus>(context);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child:  Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: fullScreenStatus.isFullScreen ? MediaQuery.of(context).size.height : 280,
                  width: double.infinity,
                  color: Colors.black,
                  child:  Container(
                          // height: 400, // 这里随意
                          child: IjkPlayer(
                            mediaController: controller,
                          ),
                        )// : statusWidget(loadStatus, type: false),
                ),
                // 返回头部
                Positioned(
                  top: fullScreenStatus.isFullScreen ? 0 : MediaQuery.of(context).padding.top,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                        ), 
                        color: Colors.white,
                        onPressed: (){
                          print('object');
                          final isAndroid = Theme.of(context).platform == TargetPlatform.android;
                          // 点击返回时是否处于全屏否则强制竖屏
                          ApplicationStatus fullScreen = Provider.of<ApplicationStatus>(context, listen: false);
                          if( fullScreen.isFullScreen ){
                            if ( isAndroid ) {
                              SystemChrome.setEnabledSystemUIOverlays([]);
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.portraitDown
                              ]);
                              fullScreen.cancelFullScreen();
                            }
                          } else {
                            // 返回
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      PopupMenuButton(
                          offset: Offset(10, 10),
                          icon: Icon( // 相机图标
                            Icons.more_horiz,
                          ),
                          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                            PopupMenuItem<String>(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.access_alarm,
                                    color: Color(0xFF2DEDA9),
                                  ),
                                  Text(
                                    " 扫一扫",
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                ],
                              ), 
                              value: "scan",
                            ),
                            PopupMenuItem<String>(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.ac_unit,
                                    color: Color(0xFFF4C152),
                                  ),
                                  Text(
                                    " 邀请好友",
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                ],
                              ), 
                              value: "share",
                            ),
                          ],
                          onSelected: (String action) async {
                            switch (action) {
                              case "scan":
                                print('扫描点击事件');
                                
                                break;
                              case "qcode":
                                print("qcode");
                                
                                break;
                              default:
                                print("share");
                                
                            }
                          },
                          onCanceled: () {
                            print("onCanceled");
                          }, 
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: loadStatus == LoadStatus.SUCCESS ? Container(
                padding: EdgeInsets.fromLTRB(
                  10, 
                  0, 
                  10, 
                  MediaQuery.of(context).padding.bottom
                ),
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: <Widget>[
                    // 标题 -> 简介
                    titleItem(left: videoDetail?.title, right: "简介", leftIcon: Icons.title, rightIcon: Icons.arrow_forward_ios),
                    // 线路
                    titleItem(left: "线路", right: "如果播放失败可更换线路重新加载", leftIcon: Icons.line_style, rightSize: 10),
                    // 线路列表
                    Container(
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 1,
                          left: 1,
                          right: 1,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: apiData.length,
                        itemBuilder: (BuildContext context, int index){
                          return OutlineButton(
                            onPressed: (){
                              print('源${apiData[index]?.url}');
                              SpUtil.putString( "api", apiData[index]?.url );
                              print('源${SpUtil.getString('api')}');
                            },
                            child: Text(
                              '${apiData[index]?.title}',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: ScreenUtil.getInstance().getSp(10)
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // 播放源
                    // titleItem(left: "播放源", right: "如果播放失败请更换播放源", leftIcon: Icons.video_call, rightSize: 10),
                    // 播放源列表
                    // Container(
                    //   child: GridView.builder(
                    //     shrinkWrap: true,
                    //     padding: EdgeInsets.only(
                    //       top: 10,
                    //       bottom: 5,
                    //       left: 1,
                    //       right: 1,
                    //     ),
                    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 5,
                    //       childAspectRatio: 2,
                    //       crossAxisSpacing: 10,
                    //       mainAxisSpacing: 10,
                    //     ),
                    //     physics: NeverScrollableScrollPhysics(),
                    //     itemCount: 4,
                    //     itemBuilder: (BuildContext context, int index){
                    //       return OutlineButton(
                    //         onPressed: (){
                    //           print('源${index+1}');
                    //         },
                    //         child: Text(
                    //           '源${index+1}',
                    //           style: TextStyle(
                    //             color: Colors.red
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    // 选集
                    titleItem(left: "选集", right: "${videoDetail?.anthology}", leftIcon: Icons.filter_list, rightSize: 10, rightIcon: Icons.arrow_forward_ios, index: 2),
                    // 选集列表
                    Container(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: videoDetail?.list?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                horizontal: 10
                              ),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all( Radius.circular(6) ),
                                  side: BorderSide(
                                    color: videoDetail?.url == videoDetail?.list[index].url ? Theme.of(context).primaryColor : Colors.grey,
                                    style: BorderStyle.solid, 
                                    width: 1
                                  )
                                ),
                                onPressed: () async {
                                  print('${videoDetail?.list[index].url}');
                                  await controller.reset(); // 这个方法调用后,会释放所有原生资源,但重新设置dataSource依然可用
                                  // 网络
                                  await controller.setNetworkDataSource(videoDetail?.list[index].url);
                                  setState(() {
                                    videoDetail?.url = videoDetail?.list[index].url;
                                    // // 先暂停在继续移除监听
                                    // _controller.pause();
                                    // _controller.removeListener((){});

                                    // // 重新设置video
                                    // _controller = VideoPlayerController.network(
                                    //   videoDetail?.list[index].url,
                                    //   closedCaptionFile: _loadCaptions(),
                                    // )
                                    // ..initialize().then((_){
                                    //   print(_controller.value.aspectRatio);
                                    //   setState(() {
                                    //     videoDetail.url = videoDetail?.list[index].url;
                                    //     videoAspectRatio = _controller.value.aspectRatio;
                                    //   });
                                    // })
                                    // ..addListener(() {
                                    //   // print('---${_controller}');
                                    // })
                                    // ..setLooping(false)
                                    // ..play();
                                    // controller.setSpeed(2.0);

                                  });
                                  // var uint8List = await controller.screenShot();
                                  // var provider = MemoryImage(uint8List);
                                  // setState(() {
                                  //   image = Image(image:provider);
                                  // });
                                },
                                child: Text('${videoDetail?.list[index].title}',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // 标题 -> 简介
                    titleItem(left: '简介', leftIcon: Icons.assignment,),
                    Container(
                      child: Text(
                        '${videoDetail?.synopsis}',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 15 
                        ),
                      ),
                    ),
                  ],
                ),
              ) : statusWidget(loadStatus),
            ),
          ]
        ),
      ),
    );
  }

  void showBottomSheet( List data ){
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          side: BorderSide(
          color: Color(0xFFF9F3FF), 
          style: BorderStyle.solid, width: 2
        )
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil.getInstance().getWidth(10)
            ),
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                top: 10,
                bottom: 5,
                left: 1,
                right: 1,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 2.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              // physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index){
                return OutlineButton(
                  onPressed: (){
                    print('源${index+1}');
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all( Radius.circular(6) ),
                  ),
                  borderSide: BorderSide(
                    color: videoDetail?.url == videoDetail?.list[index].url ? Theme.of(context).primaryColor : Colors.grey,
                    style: BorderStyle.solid, 
                    width: 1
                  ),
                  child: Text(
                    '${videoDetail?.list[index].title}',
                    textAlign: TextAlign.center,
                    // overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget statusWidget( LoadStatus status, {bool type = true} ){
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          status == LoadStatus.ERROR ? Icon(
            Icons.warning,
            color: Colors.grey,
            size: ScreenUtil.getInstance().getSp(60),
          ) : CircularProgressIndicator(
            strokeWidth: 2,
          ),
          type ? Container(
            margin: EdgeInsets.only(
              top: ScreenUtil.getInstance().getWidth(30),
            ),
            child: Text('${status == LoadStatus.ERROR ? '视频解析失败了\n请尝试点击其他集重新解析':'加载中...'}'),
          ):Container()
        ], 
      ),
    );
  }

  Widget titleItem({String left, String right, IconData leftIcon, IconData rightIcon, double rightSize = 15, Color rightColor = Colors.grey, int index =0 }) {
    return Container(
      padding: EdgeInsets.only(
        top: 15
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                leftIcon
              ),
              Text(
                '$left',
                style: TextStyle(
                  fontSize: 15 
                ),
              ),
            ],
          ),
          InkWell(
            child: Row(
              children: <Widget>[
                right != null && right.isNotEmpty ? Text(
                  '$right',
                  style: TextStyle(
                    fontSize: rightSize,
                    color: rightColor
                  ),
                ) : Container(),
                rightIcon != null && rightIcon is IconData ? Icon(
                  rightIcon,
                  size: 16,
                ) : Container(),
              ],
            ),
            onTap: () {
              if( index == 2 ){
                showBottomSheet(videoDetail?.list);
              }
            },
          )
        ],
      ),
    );
  }
}
