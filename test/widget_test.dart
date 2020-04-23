/* 
 * @Author: 21克的爱情
 * @Date: 2020-01-04 14:27:43
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-04-12 00:21:02
 * @Description: 
 */
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dart:convert' as convert;
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

import 'package:jokui_video/main.dart';
import 'package:jokui_video/utils/utils.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // print(new DateTime.now().millisecondsSinceEpoch);
    String str = 'AINXLy9jYWNoZS5nbXMtbGlnaHRpbmcuY29tL3ZpZGVvL3lrcGxheS5waHA/dXJsPWh0dHBzJTNBJTJGJTJGY2FjaGUuZ21zLWxpZ2h0aW5nLmNvbSUyRmRhdGElMkZ5b3VrdSUyRmE2MmM5YjRmNjE4NTIzYTc1NDQwNDgzOGU0MDg0NjdiLm0zdTg=';
    // List<int> content = convert.utf8.encode('W//cache.gms-lighting.com/video/ykplay.php?url=https%3A%2F%2Fcache.gms-lighting.com%2Fdata%2Fyouku%2Fa62c9b4f618523a754404838e408467b.m3u8');
    // String strs = convert.base64Encode(content);
    print(str.substring(4));
    List<int> bytes = convert.base64Decode(str);
    // 网上找的很多都是String.fromCharCodes，这个中文会乱码
    //String txt1 = String.fromCharCodes(bytes);
    // String result = String.fromCharCodes(bytes);
    // String result = convert.utf8.decode(bytes);
    // print(result);
    // 'AINXLy9jYWNoZXFxLjBqdS5jYy92aWRlby95a3BsYXkucGhwP3VybD1odHRwcyUzQSUyRiUyRmNhY2hlcXEuMGp1LmNjJTJGZGF0YSUyRnlvdWt1JTJGYTYyYzliNGY2MTg1MjNhNzU0NDA0ODM4ZTQwODQ2N2IubTN1OA==';
    // String deList = Utils.base64Decode(str);
    // print(deList);
    // var content = new Utf8Encoder().convert(data);
    // var digest = md5.convert(content);
    // // 这里其实就是 digest.toString()
    // return hex.encode(digest.bytes);
  });
}
