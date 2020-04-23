/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-07 13:43:57
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-07 14:50:38
 * @Description: 
 */

import 'package:flutter/material.dart';

class FindPage extends StatefulWidget {
  FindPage({Key key}) : super(key: key);

  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  @override
  void initState() { 
    super.initState();
    print('发现');
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text('findPage'),
    );
  }
}