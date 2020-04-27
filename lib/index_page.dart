/* 
 * @Author: 21克的爱情
 * @Date: 2020-03-29 09:24:01
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-27 10:20:43
 * @Description: 
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'pages/find/find_page.dart';
import 'pages/home/home_page.dart';
import 'pages/movie/movie_page.dart';
import 'pages/personal/personal_page.dart';
import 'pages/series/series_page.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with SingleTickerProviderStateMixin{
  PageController _pageController;
  int _currentIndex = 0;
  List tabData = [];

  @override
  void initState() {
    super.initState();


    _pageController = new PageController();

    tabData.add({
      "title": "首页",
      "icon" : Icons.home,
      "iconColor" : "",
      "checkIcon" : "",
      "checkIconColor" : "",
    });
    tabData.add({
      "title": "发现",
      "icon" : Icons.fingerprint,
      "iconColor" : "",
      "checkIcon" : "",
      "checkIconColor" : "",
    });
    tabData.add({
      "title": "我的",
      "icon" : Icons.people,
      "iconColor" : "",
      "checkIcon" : "",
      "checkIconColor" : "",
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF9271e2),
              Theme.of(context).primaryColor, 
            ],
            begin: FractionalOffset(1, 1), 
            end: FractionalOffset(0, 0),
          )
        ),
        child: SafeArea(
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: tabData.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index){
              return buildPage(index);
            },
            onPageChanged: (int index){
              print(_pageController);
            },
          ),
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        // elevation: 2,
        activeColor: Theme.of(context).primaryColor,
        iconSize: 22,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        items: buildBottom,
        onTap: (int index){
          _pageController.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
          // _pageController.animateToPage(index, duration: new Duration(milliseconds: 300), curve: Curves.linear);
        },
      ),
    );
  }

  Widget buildPage( int index ){
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return FindPage();
      default:
        return PersonalPage();
    }
  }

  List<BottomNavigationBarItem> get buildBottom{
    List<BottomNavigationBarItem> list = [];
    tabData.forEach((item){
      list.add(
        new BottomNavigationBarItem(
          icon: Icon(item["icon"]),
          title: Text('${item["title"]}'),
        )
      );
    });
    return list;
  }

}
