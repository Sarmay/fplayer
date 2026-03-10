# fplayer

[![pub package](https://img.shields.io/pub/v/sarmay_fplayer.svg)](https://pub.dartlang.org/packages/sarmay_fplayer)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter video player plugin for iOS and Android based on [fplayer-core](https://github.com/FlutterPlayer/ijkplayer).

## Features 功能

- **多协议支持**: 支持 HTTP、HTTPS、RTSP、RTMP、M3U8 等常见流媒体协议
- **多种编码格式**: 支持 H.264、H.265、VP8、VP9 等视频编码
- **丰富 UI 面板**: 提供开箱即用的视频播放器控制面板
- **视频列表**: 支持多集视频列表播放
- **倍速播放**: 支持 0.5x、1.0x、1.5x、2.0x 等多种倍速
- **清晰度切换**: 支持多清晰度切换
- **截屏功能**: 支持视频截屏
- **试看功能**: 支持试看时间限制
- **全屏模式**: 支持竖屏和横屏全屏
- **播放记录**: 支持记录和恢复播放进度
- **手势控制**: 支持双击、滑动等手势操作

## Installation 安装

Add `sarmay_fplayer` as a dependency in your `pubspec.yaml`:

```yaml
dependencies:
  sarmay_fplayer: ^1.1.13
```

Or use git:

```yaml
dependencies:
  sarmay_fplayer:
    git:
      url: https://github.com/Sarmay/fplayer.git
      ref: main
```

## Quick Start 快速开始

```dart
import 'package:flutter/material.dart';
import 'package:sarmay_fplayer/sarmay_fplayer.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final FPlayer player = FPlayer();

  @override
  void initState() {
    super.initState();
    player.setDataSource(
      'https://www.runoob.com/try/demo_source/mov_bbb.mp4',
      autoPlay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Player')),
      body: FView(
        player: player,
        width: double.infinity,
        height: 300,
        color: Colors.black,
        panelBuilder: fPanelBuilder(
          title: '视频标题',
          subTitle: '视频副标题',
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}
```

## Advanced Usage 高级用法

### Video List 视频列表

```dart
List<VideoItem> videoList = [
  VideoItem(
    url: 'https://example.com/video1.mp4',
    title: '第一集',
    subTitle: '视频1副标题',
  ),
  VideoItem(
    url: 'https://example.com/video2.mp4',
    title: '第二集',
    subTitle: '视频2副标题',
  ),
];

FView(
  player: player,
  panelBuilder: fPanelBuilder(
    isVideos: true,
    videoList: videoList,
    videoIndex: 0,
    playNextVideoFun: () {
      // 播放下一集
    },
  ),
)
```

### Speed Control 倍速控制

```dart
Map<String, double> speedList = {
  "2.0x": 2.0,
  "1.5x": 1.5,
  "1.0x": 1.0,
  "0.5x": 0.5,
};

fPanelBuilder(
  speedList: speedList,
)
```

### Resolution Switching 清晰度切换

```dart
Map<String, ResolutionItem> resolutionList = {
  "1080P": ResolutionItem(
    value: 1080,
    url: 'https://example.com/video_1080p.mp4',
  ),
  "720P": ResolutionItem(
    value: 720,
    url: 'https://example.com/video_720p.mp4',
  ),
};

fPanelBuilder(
  isResolution: true,
  resolutionList: resolutionList,
)
```

### Screenshot 截屏

```dart
fPanelBuilder(
  isSnapShot: true,
)
```

### Preview / Trial Watch 试看功能

```dart
fPanelBuilder(
  tipTime: 30, // 试看30秒
  tipWidget: CustomTipWidget(), // 自定义试看结束提示
  onTipShow: () {
    // 试看结束回调
  },
)
```

### Time Change Callback 时间更新回调

```dart
fPanelBuilder(
  onVideoTimeChange: (Duration duration) {
    print('Current position: $duration');
  },
  onVideoTimeChangeInterval: 10, // 每10次位置更新触发一次回调
)
```

### Callbacks 回调

```dart
fPanelBuilder(
  onError: () async {
    await player.reset();
    // 处理播放错误
  },
  onVideoEnd: () async {
    // 视频播放完成
  },
  onVideoPrepared: () async {
    // 视频准备完成，可以进行 seekTo 等操作
  },
  onVideoStateChange: (FState state, bool isPlaying) {
    // 播放状态变化
  },
)
```

### Custom Right Button 自定义右侧按钮

```dart
fPanelBuilder(
  isRightButton: true,
  rightButtonList: [
    IconButton(
      icon: Icon(Icons.favorite),
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.share),
      onPressed: () {},
    ),
  ],
)
```

## Configuration 配置

```dart
await player.setOption(FOption.hostCategory, "enable-snapshot", 1);
await player.setOption(FOption.hostCategory, "request-screen-on", 1);
await player.setOption(FOption.hostCategory, "request-audio-focus", 1);
await player.setOption(FOption.playerCategory, "reconnect", 20);
await player.setOption(FOption.playerCategory, "framedrop", 20);
await player.setOption(FOption.playerCategory, "enable-accurate-seek", 1);
await player.setOption(FOption.playerCategory, "mediacodec", 1);
await player.setOption(FOption.playerCategory, "packet-buffering", 0);
await player.setOption(FOption.playerCategory, "soundtouch", 1);
```

## API Reference API 参考

### FPlayer

| Method | Description |
|--------|-------------|
| `setDataSource(String url, {bool autoPlay, bool showCover})` | 设置视频源 |
| `prepareAsync()` | 异步准备播放 |
| `start()` | 开始播放 |
| `pause()` | 暂停播放 |
| `stop()` | 停止播放 |
| `seekTo(Duration position)` | 跳转进度 |
| `takeSnapShot()` | 截屏 |
| `release()` | 释放资源 |

### fPanelBuilder Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `String` | `''` | 视频标题 |
| `subTitle` | `String` | `''` | 视频副标题 |
| `isVideos` | `bool` | `false` | 是否显示视频列表 |
| `videoList` | `List<VideoItem>` | `null` | 视频列表 |
| `videoIndex` | `int` | `0` | 当前视频索引 |
| `isSnapShot` | `bool` | `false` | 是否显示截屏按钮 |
| `isResolution` | `bool` | `false` | 是否显示清晰度切换 |
| `speedList` | `Map<String, double>` | `null` | 倍速列表 |
| `resolutionList` | `Map<String, ResolutionItem>` | `null` | 清晰度列表 |
| `isRightButton` | `bool` | `false` | 是否显示右侧按钮 |
| `rightButtonList` | `List<Widget>` | `null` | 右侧按钮列表 |
| `doubleTap` | `bool` | `true` | 是否启用双击播放/暂停 |
| `hideDuration` | `int` | `5000` | 控制栏自动隐藏时间(毫秒) |
| `tipTime` | `int` | `-1` | 试看时间(秒)，-1表示无需试看 |
| `tipWidget` | `Widget` | `null` | 自定义试看结束提示组件 |
| `onVideoTimeChange` | `Function(Duration)` | `null` | 时间更新回调 |
| `onVideoTimeChangeInterval` | `int` | `50` | 时间更新回调触发间隔 |
| `onError` | `Function()` | `null` | 播放错误回调 |
| `onVideoEnd` | `Function()` | `null` | 播放结束回调 |
| `onVideoPrepared` | `Function()` | `null` | 准备完成回调 |
| `onTipShow` | `Function()` | `null` | 试看结束回调 |
| `settingFun` | `Function()` | `null` | 设置按钮点击回调 |
| `playNextVideoFun` | `Function()` | `null` | 播放下一集回调 |

## iOS Note

Note: The fplayer video player plugin may not function properly on iOS simulators. An iOS device is recommended for development and testing.

## License 许可证

MIT License

## Acknowledgments 鸣谢

- [fijkplayer](https://github.com/befovy/fijkplayer)
- [ijkplayer](https://github.com/bilibili/ijkplayer)
- [ffmpeg](https://github.com/FFmpeg/FFmpeg)
- [fplayer](https://github.com/FlutterPlayer/fplayer)