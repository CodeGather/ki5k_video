/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-27 16:42:06
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-08 11:04:56
 * @Description: 电影搜索页面
 */

import 'package:flutter/material.dart';
import 'package:ki5k_video/api/Api.dart';
import 'package:ki5k_video/models/video_attr.dart';
import 'package:xml/xml.dart';

import 'video/video_detail_page.dart';

class SearchVideoPage extends StatefulWidget {
  SearchVideoPage({Key key}) : super(key: key);

  @override
  _SearchVideoPageState createState() => _SearchVideoPageState();
}

class _SearchVideoPageState extends State<SearchVideoPage> {
  ScrollController _controller;
  List<VideoSearch> listData=[];

  bool loadStatus = false;
  int pageIndex = 1;
  String searchStr='';
  @override
  void initState() { 
    super.initState();

    _controller = new ScrollController();

    _controller.addListener(() {
      if(!loadStatus && _controller.position.maxScrollExtent - 200 < _controller.position.pixels){
        setState(() {
          pageIndex ++;
        });
        searchData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _controller?.dispose();
  }

  void searchData() async {
    setState(() {
      loadStatus = true;
    });
    if( searchStr != null && searchStr.isNotEmpty ){
      Api.getHomeVideo({
        'ac': 'list',
        't':'',
        'ids':'',
        'pg': pageIndex,
        'wd': searchStr
      }).then((value) async {
        if( value != null && value.isNotEmpty ){
          final document = XmlDocument.parse(value);
          var videoData = document.findAllElements('video').toList();
          
          if( videoData != null && videoData.length > 0 ){
            List<VideoSearch> list=[];
            videoData.forEach((node){
              list.add(
                VideoSearch.fromJson({
                  'name': node.findElements('name').single.text,
                  'id': node.findElements('id').single.text,
                  'tid': node.findElements('tid').single.text,
                  'type': node.findElements('type').single.text,
                  'last': node.findElements('last').single.text,
                  'note': node.findElements('note').single.text,
                })
              );
            });
            setState(() {
              loadStatus = false;
              listData = list;
            });
          }
        }
      });
    } else {
      setState(() {
        pageIndex = 1;
        listData = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        // toolbarOpacity: 0,
        title: Container(
          padding: EdgeInsets.symmetric(
            vertical: 30
          ),
          margin: EdgeInsets.symmetric(
            vertical: 30
          ),
          child: TextFormField(
            scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5
                ),
                hintText: '请输入搜索视频名称',
                hintStyle: TextStyle(
                  color: Colors.white
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: true,
                hasFloatingPlaceholder: true,
                fillColor: Colors.black12,
              ),
              autofocus: true,
              onChanged: (value){
                setState(() {
                  searchStr = value;
                });
                searchData();
              },
            ),
        ),
      ),
      body: ListView.builder(
        itemCount: listData.length,
        controller: _controller,
        itemBuilder: (BuildContext context, int index){
          return InkWell(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_){
                  return VideoDetailPage( listData[index].id );
                })
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10
              ),
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${listData[index].name}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('${listData[index].note.length < 8 ? listData[index].note : listData[index].note.substring(0,8)}'),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${listData[index].last}'),
                      Text('${listData[index].type}'),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}