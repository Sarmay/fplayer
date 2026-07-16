## Unreleased

## 1.1.17
* Keep fullscreen controls inside display cutout and system gesture safe areas.
* Fix fullscreen route cleanup so system back and view disposal restore the player reliably.
* Trigger automatic next-episode playback only once per completed-state transition.

## 1.1.16
* Upgrade the development baseline to Flutter 3.41, Dart 3.11, Java 17, and iOS 13.
* Fix player view listener cleanup, HTTP header ordering, volume mode validation, and screenshot state cleanup.
* Preserve the native Android playback position across long pauses before resuming.

## 1.1.15
* 修复试看提示出来后调用play方法，后台还能播放问题

## 1.1.14
* 新增视频时间更新回调触发间隔参数onVideoTimeChangeInterval
