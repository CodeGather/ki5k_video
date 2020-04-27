/* 
 * @Author: 21克的爱情
 * @Date: 2020-04-15 14:02:10
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-15 14:22:19
 * @Description: 用户隐私
 */

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

class LoginPrivacy extends StatefulWidget {
  LoginPrivacy({Key key}) : super(key: key);

  @override
  _LoginPrivacyState createState() => _LoginPrivacyState();
}

class _LoginPrivacyState extends State<LoginPrivacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '用户隐私'
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil.getInstance().getWidth(15),
        ),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil.getInstance().getWidth(15),
                vertical: ScreenUtil.getInstance().getWidth(15)
              ),
              alignment: Alignment.center,
              child: Text(
                '关于个人隐私信息保护',
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().getSp(20)
                ),
              ),
            ),
            Container(
              child: Text(
                '为了能够向您提供服务、客户帮助，并向您和其他用户提供更具针对性的、更好的服务，达理在服务过程中可能需要向您收集您本人的个人信息。使用服务前，请您仔细阅读以下内容并同意允许达理合理收集、存储及使用这些信息。达理不会将您的个人隐私信息使用于任何其他用途。',
              ),
            ),
            Container(
              child: Text(
                '1.您在使用达理服务的过程中，可能需要填写或提交一些必要信息，达理会根据您的同意和提供服务的需要，收集您的真实姓名、性别、手机号、手机设备识别码、详细地址等。',
              ),
            ),
            Container(
              child: Text(
                '2.尊重和保护您的个人隐私信息是达理的一贯制度，达理将会采取技术措施和其他必要措施，确保您的个人隐私绝对安全，防止在本服务中收集的您的个人隐私信息泄露、损毁或丢失。',
              ),
            ),
            Container(
              child: Text(
                '3. 达理未经您的同意不会向任何第三方平台公开、透露您的个人隐私信息。但以下特定情形除外：',
              ),
            ),
            Container(
              child: Text(
                '3.1 法律法规、法律程序、诉讼或政府主管部门强制性要求外，达理不会主动公开披露您的个人信息。如果存在其他必要公开披露个人信息的情形，达理会征得您的明示同意。',
              ),
            ),
            Container(
              child: Text(
                '3.2 您将个人隐私信息告知他人或与他人共享个人隐私，由此导致的任何个人隐私泄露，或达理原因导致的个人隐私泄露；',
              ),
            ),
            Container(
              child: Text(
                '3.3 黑客攻击、电脑病毒及其他不可抗力事件导致您的个人隐私信息的泄露。',
              ),
            ),
            Container(
              child: Text(
                '4.对您信息的使用及披露，达理仅把您的个人信息用于提供服务的目的，包括向您拨打电话、发送相关服务等，您同意达理可以在以下事项中使用您的个人隐私信息：',
              ),
            ),
            Container(
              child: Text(
                '4.1 达理及时向您发送有需要的通知，如个人服务信息、订单进程、本协议服务条款的变更；',
              ),
            ),
            Container(
              child: Text(
                '4.2 达理内部进行数据调研、分析和研究，用于改进达理的产品、服务和用户体验；',
              ),
            ),
            Container(
              child: Text(
                '4.3 适用法律法规规定的其他情形下。',
              ),
            ),
          ], 
        )
      )
    );
  }
}