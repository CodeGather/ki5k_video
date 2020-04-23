/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-07 13:42:44
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-07 14:50:28
 * @Description: 
 */

import 'package:flutter/material.dart';

class PersonalPage extends StatefulWidget {
  PersonalPage({Key key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  void initState() { 
    super.initState();
    print('个人中心');
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text('personal'),
    );
  }
}