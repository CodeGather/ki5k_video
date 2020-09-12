import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class FullScreen extends StatefulWidget {
  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  var controller = IjkMediaController();

  Orientation get orientation => MediaQuery.of(context).orientation;
  DataSource source = DataSource.network(
    "https://youku.cdn7-okzy.com/20200530/19802_7ff6f2f4/1000k/hls/index.m3u8",
  );

  @override
  void initState() {
    super.initState();
    OptionUtils.addDefaultOptions(controller);
    controller.setDataSource(source, autoPlay: true);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (orientation == Orientation.landscape) {
      return _buildFullScreenPlayer();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("全屏"),
      ),
      body: ListView(
        children: <Widget>[
          _buildPlayerItem(),
        ],
      ),
    );
  }

  _buildPlayerItem() {
    return Container(
      height: 200,
      child: IjkPlayer(
        mediaController: controller,
      ),
    );
  }

  _buildFullScreenPlayer() {
    var data = MediaQuery.of(context);
    return Material(
      child: Container(
        width: data.size.width,
        height: data.size.height,
        child: IjkPlayer(
          mediaController: controller,
        ),
      ),
    );
  }
}

class FullScreen2 extends StatefulWidget {
  @override
  _FullScreen2State createState() => _FullScreen2State();
}

class _FullScreen2State extends State<FullScreen2> {
  var controller = IjkMediaController();

  Orientation get orientation => MediaQuery.of(context).orientation;
  DataSource source = DataSource.network(
    "https://youku.cdn7-okzy.com/20200530/19802_7ff6f2f4/1000k/hls/index.m3u8",
  );

  @override
  void initState() {
    super.initState();
    portraitUp();
  }

  @override
  void dispose() {
    controller.dispose();
    unlockOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (orientation == Orientation.landscape) {
      return buildLandscape();
    }
    return buildNormal();
  }

  Widget buildLandscape() {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    // OrientationPlugin.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            IjkPlayer(
              mediaController: controller,
            ),
            Container(
              height: 44.0,
              width: 44.0,
              child: IconButton(
                icon: Icon(
                  Icons.fullscreen_exit,
                  color: Colors.white,
                ),
                onPressed: portraitUp,
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        if (orientation == Orientation.landscape) {
          portraitUp();
          return false;
        }
        return true;
      },
    );
  }

  Widget buildNormal() {
    return Scaffold(
      appBar: AppBar(
        title: Text("全屏"),
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: IjkPlayer(
              mediaController: controller,
              controllerWidgetBuilder: (ctl) {
                return DefaultIJKControllerWidget(
                  controller: ctl,
                  verticalGesture: false,
                );
              },
            ),
          ),
          RaisedButton(
            onPressed: () async {
              await controller.setDataSource(source);
              await controller.play();
            },
            child: Text("播放"),
          ),
          RaisedButton(
            onPressed: setLandScapeLeft,
            child: Text("全屏"),
          ),
        ],
      ),
    );
  }

  setLandScapeLeft() async {
    await IjkManager.setLandScape();
  }

  portraitUp() async {
    await IjkManager.setPortrait();
  }

  unlockOrientation() async {
    await IjkManager.unlockOrientation();
  }
}

class CustomFullControllerPage extends StatefulWidget {
  @override
  _CustomFullControllerPageState createState() =>
      _CustomFullControllerPageState();
}

class _CustomFullControllerPageState extends State<CustomFullControllerPage> {
  IjkMediaController controller;

  @override
  void initState() {
    super.initState();
    controller = IjkMediaController();
    controller.setNetworkDataSource(
      "https://youku.cdn7-okzy.com/20200530/19802_7ff6f2f4/1000k/hls/index.m3u8",
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: 500,
        child: IjkPlayer(
          mediaController: controller,
          controllerWidgetBuilder: (ctl) {
            return DefaultIJKControllerWidget(
              controller: ctl,
              fullscreenControllerWidgetBuilder: _buildFullScrrenCtl,
            );
          },
        ),
      ),
    );
  }

  Widget _buildFullScrrenCtl(IjkMediaController controller) {
    return DefaultIJKControllerWidget(
      controller: controller,
      doubleTapPlay: true,
      currentFullScreenState: true,
    );
  }
}

class OptionUtils {
  static void addDefaultOptions(IjkMediaController controller) {
    controller.addIjkPlayerOptions(
      [TargetPlatform.iOS, TargetPlatform.android],
      createIJKOptions(),
    );
  }

  static Set<IjkOption> createIJKOptions() {
    return <IjkOption>[
      IjkOption(IjkOptionCategory.player, "mediacodec", 1),
      IjkOption(IjkOptionCategory.player, "mediacodec-hevc", 1),
      IjkOption(IjkOptionCategory.player, "videotoolbox", 1),
      IjkOption(IjkOptionCategory.player, "opensles", 0),
      IjkOption(IjkOptionCategory.player, "overlay-format", 0x32335652),
      IjkOption(IjkOptionCategory.player, "framedrop", 1),
      IjkOption(IjkOptionCategory.player, "start-on-prepared", 0),
      IjkOption(IjkOptionCategory.format, "http-detect-range-support", 0),
      IjkOption(IjkOptionCategory.codec, "skip_loop_filter", 48),
    ].toSet();
  }
}