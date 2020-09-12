/* 
 * @Author: 21克的爱情
 * @Date: 2020-05-06 09:19:03
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-05-11 10:48:20
 * @Description: 文本编辑器
 */

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkDownPage extends StatefulWidget {
  MarkDownPage({Key key}) : super(key: key);

  @override
  _MarkDownPageState createState() => _MarkDownPageState();
}

class _MarkDownPageState extends State<MarkDownPage> {

  final String _markdownData = """
  # Markdown Example
  Markdown allows you to easily include formatted text, images, and even formatted Dart code in your app.

  ## Titles

  Setext-style

  ```
  This is an H1
  =============

  This is an H2
  -------------
  ```

  Atx-style

  ```
  # This is an H1

  ## This is an H2

  ###### This is an H6
  ```

  Select the valid headers:

  - [x] `# hello`
  - [ ] `#hello`

  ## Links

  [Google's Homepage][Google]

  ```
  [inline-style](https://www.google.cn)

  [reference-style][Google]
  ```

  ## Images

  ![Flutter logo](https://pub.flutter-io.cn/static/img/pub-dev-logo-2x.png?hash=umitaheu8hl7gd3mineshk2koqfngugi)

  ## Tables

  |Syntax                                 |Result                               |
  |---------------------------------------|-------------------------------------|
  |`*italic 1*`                           |*italic 1*                           |
  |`_italic 2_`                           | _italic 2_                          |
  |`**bold 1**`                           |**bold 1**                           |
  |`__bold 2__`                           |__bold 2__                           |
  |`This is a ~~strikethrough~~`          |This is a ~~strikethrough~~          |
  |`***italic bold 1***`                  |***italic bold 1***                  |
  |`___italic bold 2___`                  |___italic bold 2___                  |
  |`***~~italic bold strikethrough 1~~***`|***~~italic bold strikethrough 1~~***|
  |`~~***italic bold strikethrough 2***~~`|~~***italic bold strikethrough 2***~~|

  ## Styling
  Style text as _italic_, __bold__, ~~strikethrough~~, or `inline code`.

  - Use bulleted lists
  - To better clarify
  - Your points

  ## Code blocks
  Formatted Dart code looks really pretty too:

  ```
  void main() {
    runApp(MaterialApp(
      home: Scaffold(
        body: Markdown(data: markdownData),
      ),
    ));
  }
  ```

  ## Markdown widget

  This is an example of how to create your own Markdown widget:

      Markdown(data: 'Hello _world_!');

  Enjoy!
  # demo
  为了能够向您提供服务、客户帮助，并向您和其他用户提供更具针对性的、更好的服务，达理在服务过程中可能需要向您收集您本人的个人信息。使用服务前，请您仔细阅读以下内容并同意允许达理合理收集、存储及使用这些信息。达理不会将您的个人隐私信息使用于任何其他用途。
  [Google]: https://www.google.cn/


  
### <center>关于个人隐私信息保护</center>

为了能够向您提供服务、客户帮助，并向您和其他用户提供更具针对性的、更好的服务，达理在服务过程中可能需要向您收集您本人的个人信息。使用服务前，请您仔细阅读以下内容并同意允许达理合理收集、存储及使用这些信息。达理不会将您的个人隐私信息使用于任何其他用途。

1.您在使用达理服务的过程中，可能需要填写或提交一些必要信息，达理会根据您的同意和提供服务的需要，收集您的真实姓名、性别、手机号、手机设备识别码、详细地址等。

2.尊重和保护您的个人隐私信息是达理的一贯制度，达理将会采取技术措施和其他必要措施，确保您的个人隐私绝对安全，防止在本服务中收集的您的个人隐私信息泄露、损毁或丢失。

3.达理未经您的同意不会向任何第三方平台公开、透露您的个人隐私信息。但以下特定情形除外：

- 3.1 法律法规、法律程序、诉讼或政府主管部门强制性要求外，达理不会主动公开披露您的个人信息。如果存在其他必要公开披露个人信息的情形，达理会征得您的明示同意。
- 3.2 您将个人隐私信息告知他人或与他人共享个人隐私，由此导致的任何个人隐私泄露，或达理原因导致的个人隐私泄露；
- 3.3 黑客攻击、电脑病毒及其他不可抗力事件导致您的个人隐私信息的泄露。
  
4.对您信息的使用及披露，达理仅把您的个人信息用于提供服务的目的，包括向您拨打电话、发送相关服务等，您同意达理可以在以下事项中使用您的个人隐私信息：

- 4.1 达理及时向您发送有需要的通知，如个人服务信息、订单进程、本协议服务条款的变更；
- 4.2 达理内部进行数据调研、分析和研究，用于改进达理的产品、服务和用户体验；
- 4.3 适用法律法规规定的其他情形下。


|    左对齐   |    居中    |
|------------|----------:|
|TaoBeier    |  TaoBeier  |

  """;

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        title: "Markdown Demo",
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Markdown Demo'),
          ),
          body: SafeArea(
            child: Markdown(
              controller: controller,
              selectable: true,
              data: _markdownData,
              imageDirectory: 'https://raw.githubusercontent.com',
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.arrow_upward),
            onPressed: () => controller.animateTo(0,
                duration: Duration(seconds: 1), curve: Curves.easeOut),
          ),
        ),
      );
  }
}