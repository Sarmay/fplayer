## Unreleased

## 1.1.20
* Add an iOS XCFramework with arm64 device and arm64/x86_64 simulator slices.
* Fix black video textures after resetting or switching sources on Apple Silicon simulators.
* Preserve and synchronize Flutter texture pixel buffers across playback and shutdown.
* Link Swift compatibility libraries when the iOS plugin is used by Objective-C apps.
* Upgrade the maintained Android core to `1.1.0-sarmay.3`.

## 1.1.19
* Upgrade Android to the maintained `io.github.sarmay:fplayer-core:1.1.0-sarmay.2` artifact based on upstream core 1.1.0.
* Require the Android core release to pass 16KB ELF verification, with final APK ZIP alignment checked in consumer CI.
* Verify the release example APK keeps all native libraries and ZIP entries 16KB compatible.
* Keep iOS on the separately validated CocoaPods `fplayer-core 1.0.4` release.
* Ignore stale or duplicate native state callbacks after playback has already advanced.
* Keep play and pause controls synchronized across prepare, pause, resume, reset, and source changes.

## 1.1.18
* Improve fullscreen title contrast and typography, with the drama name as the primary title and the episode as secondary text.
* Keep long player titles and subtitles from colliding with fullscreen controls.

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
