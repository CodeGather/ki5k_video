/* 
 * @Author: 21克的爱情
 * @Date: 2020-09-02 16:18:07
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-03 15:55:09
 * @Description: 
 */
import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  AnimationController animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/tabber/tab_5.png',
      selectedImagePath: 'assets/tabber/tab_5s.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/tabber/tab_6.png',
      selectedImagePath: 'assets/tabber/tab_6s.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/tabber/tab_7.png',
      selectedImagePath: 'assets/tabber/tab_7s.png',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/tabber/tab_4.png',
      selectedImagePath: 'assets/tabber/tab_4s.png',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
