import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fplayer_platform_interface.dart';

/// An implementation of [FplayerPlatform] that uses method channels.
class MethodChannelFplayer extends FplayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('befovy.com/fijk');

  /// The event channel used to receive events from the native platform.
  @visibleForTesting
  final eventChannel = const EventChannel('befovy.com/fijk/event');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int?> createPlayer() async {
    final pid = await methodChannel.invokeMethod<int>('createPlayer');
    return pid;
  }

  @override
  Future<void> releasePlayer(int pid) {
    return methodChannel.invokeMethod('releasePlayer', {'pid': pid});
  }

  @override
  Future<void> setLogLevel(int level) {
    return methodChannel.invokeMethod('logLevel', {'level': level});
  }

  @override
  Future<bool?> setOrientationPortrait() {
    return methodChannel.invokeMethod<bool>('setOrientationPortrait');
  }

  @override
  Future<bool?> setOrientationLandscape() {
    return methodChannel.invokeMethod<bool>('setOrientationLandscape');
  }

  @override
  Future<void> setOrientationAuto() {
    return methodChannel.invokeMethod('setOrientationAuto');
  }

  @override
  Future<void> setScreenOn(bool on) {
    return methodChannel.invokeMethod('setScreenOn', {'on': on});
  }

  @override
  Future<bool?> isScreenKeptOn() {
    return methodChannel.invokeMethod<bool>('isScreenKeptOn');
  }

  @override
  Future<double?> getBrightness() {
    return methodChannel.invokeMethod<double>('brightness');
  }

  @override
  Future<void> setBrightness(double brightness) {
    return methodChannel
        .invokeMethod('setBrightness', {'brightness': brightness});
  }

  @override
  Future<void> requestAudioFocus() {
    return methodChannel.invokeMethod('requestAudioFocus');
  }

  @override
  Future<void> releaseAudioFocus() {
    return methodChannel.invokeMethod('releaseAudioFocus');
  }

  @override
  Future<void> onLoad() {
    return methodChannel.invokeMethod('onLoad');
  }

  @override
  Future<void> onUnload() {
    return methodChannel.invokeMethod('onUnload');
  }

  @override
  Stream<dynamic> get eventStream {
    return eventChannel.receiveBroadcastStream();
  }

  @override
  Future<double?> volumeMute() {
    return methodChannel.invokeMethod<double>('volumeMute');
  }

  @override
  Future<double?> volumeSet(double vol) {
    return methodChannel.invokeMethod<double>('volumeSet', {'vol': vol});
  }

  @override
  Future<double?> systemVolume() {
    return methodChannel.invokeMethod<double>('systemVolume');
  }

  @override
  Future<double?> volumeUp({double step = 1.0 / 16.0}) {
    return methodChannel.invokeMethod<double>('volumeUp', {'step': step});
  }

  @override
  Future<double?> volumeDown({double step = 1.0 / 16.0}) {
    return methodChannel.invokeMethod<double>('volumeDown', {'step': step});
  }

  @override
  Future<void> volUiMode(int mode) {
    return methodChannel.invokeMethod('volUiMode', {'mode': mode});
  }
}
