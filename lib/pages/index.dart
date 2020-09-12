import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ki5k_video/provide/application_provide.dart';
import 'package:provider/provider.dart';

import '../widget/bottom_bar_widget.dart';
import '../models/tabIcon_data.dart';
import '../resources/AppTheme.dart';
import 'download/index.dart';
import 'home/video/video_play_page.dart';
import 'home/index_page.dart';
import 'discover/index_page.dart';
import 'personal/index_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: AppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });

    tabIconsList[0].isSelected = true;

    animationController = AnimationController( duration: const Duration(milliseconds: 300), vsync: this );
    tabBody = HomePage();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFullScreen = Provider.of<ApplicationStatus>(context, listen: true).isFullscreen;
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return tabBody;
            }
          },
        ),
        bottomNavigationBar: bottomBar(),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (!mounted) {
              return;
            }
            setState(() {
              switch (index) {
                case 1:
                  tabBody = DiscoverPage();
                  break;
                case 2:
                  tabBody = DownloadPage();
                  break;
                case 3:
                  tabBody = PersonalPage();
                  break;
                default:
                  tabBody = HomePage();
                  break;
              }
            });
          },
        ),
      ],
    );
  }
}
