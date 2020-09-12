/* 
 * @Author: 21克的爱情
 * @Date: 2020-09-03 12:54:32
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-09-08 16:24:47
 * @Description: 
 */
import 'dart:io';

import 'package:flutter/material.dart';

class PersonalPage extends StatefulWidget {
  PersonalPage({Key key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人中心'),
      ),
      body: Align(
        child: Text('正在规划中'),
      ),
    );
  }
}