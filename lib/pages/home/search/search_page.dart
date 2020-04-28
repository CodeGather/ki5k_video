/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-27 16:42:06
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-28 13:38:32
 * @Description: 电影搜索页面
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jokui_video/api/Api.dart';
import 'package:jokui_video/models/video_attr.dart';
import 'package:jokui_video/pages/play/video_page.dart';
import 'package:xml_parser/xml_parser.dart';

import '../../../utils/expand/string.dart';

class SearchVideoPage extends StatefulWidget {
  SearchVideoPage({Key key}) : super(key: key);

  @override
  _SearchVideoPageState createState() => _SearchVideoPageState();
}

class _SearchVideoPageState extends State<SearchVideoPage> {
  List<VideoSearch> listData=[];
  @override
  void initState() { 
    super.initState();
  }

  void searchData( String searchStr ) async {
    print(searchStr);
    if( searchStr != null && searchStr.isNotEmpty ){
      await Api.getSearchData({
        'ac': 'list',
        't':'',
        'ids':'',
        'pg':'',
        'wd': searchStr
      }).then((value) async {
        print(value);
        if( value != null && value.isNotEmpty ){
          final xmlDocument = XmlDocument.fromString(value);

          if (xmlDocument == null) {
            throw ('Failed to load page.');
          }

          List xmlDcoumentList = xmlDocument.getElement('list').children;

          if( xmlDcoumentList != null && xmlDcoumentList.length > 0 ){
            // 定义变量接收格式化数据
            List<VideoSearch> formatData=[];

            xmlDcoumentList.forEach((item){
              if(item is XmlElement){
                formatData.add(
                  VideoSearch.fromJson({
                    'name': XmlCdata.fromString(item.getElement('name').text).value,
                    'id': item.getElement('id').text.intParse,
                    'tid': item.getElement('tid').text.intParse,
                    'type': item.getElement('type').text,
                    'last': item.getElement('last').text,
                    'note': XmlCdata.fromString(item.getElement('note').text).value,
                  })
                );
              }
            });
            setState(() {
              listData = formatData;
            });
          }
        }
      });
    } else {
      setState(() {
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
                    onChanged: searchData,
                  ),
              ),
      ),
      body: ListView.builder(
        itemCount: listData.length,
        itemBuilder: (BuildContext context, int index){
          return InkWell(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_){
                  return VideoPage( listData[index].id, type: true );
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
                      Text('${listData[index].note}'),
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