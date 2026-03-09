import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fplayer_method_channel.dart';

abstract class FplayerPlatform extends PlatformInterface {
  /// Constructs a FplayerPlatform.
  FplayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FplayerPlatform _instance = MethodChannelFplayer();

  /// The default instance of [FplayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFplayer].
  static FplayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FplayerPlatform] when
  /// they register themselves.
  static set instance(FplayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> createPlayer() {
    throw UnimplementedError('createPlayer() has not been implemented.');
  }

  Future<void> releasePlayer(int pid) {
    throw UnimplementedError('releasePlayer() has not been implemented.');
  }

  Future<void> setLogLevel(int level) {
    throw UnimplementedError('setLogLevel() has not been implemented.');
  }

  Future<bool?> setOrientationPortrait() {
    throw UnimplementedError(
        'setOrientationPortrait() has not been implemented.');
  }

  Future<bool?> setOrientationLandscape() {
    throw UnimplementedError(
        'setOrientationLandscape() has not been implemented.');
  }

  Future<void> setOrientationAuto() {
    throw UnimplementedError('setOrientationAuto() has not been implemented.');
  }

  Future<void> setScreenOn(bool on) {
    throw UnimplementedError('setScreenOn() has not been implemented.');
  }

  Future<bool?> isScreenKeptOn() {
    throw UnimplementedError('isScreenKeptOn() has not been implemented.');
  }

  Future<double?> getBrightness() {
    throw UnimplementedError('getBrightness() has not been implemented.');
  }

  Future<void> setBrightness(double brightness) {
    throw UnimplementedError('setBrightness() has not been implemented.');
  }

  Future<void> requestAudioFocus() {
    throw UnimplementedError('requestAudioFocus() has not been implemented.');
  }

  Future<void> releaseAudioFocus() {
    throw UnimplementedError('releaseAudioFocus() has not been implemented.');
  }

  Future<void> onLoad() {
    throw UnimplementedError('onLoad() has not been implemented.');
  }

  Future<void> onUnload() {
    throw UnimplementedError('onUnload() has not been implemented.');
  }

  Stream<dynamic> get eventStream {
    throw UnimplementedError('eventStream has not been implemented.');
  }

  Future<double?> volumeMute() {
    throw UnimplementedError('volumeMute() has not been implemented.');
  }

  Future<double?> volumeSet(double vol) {
    throw UnimplementedError('volumeSet() has not been implemented.');
  }

  Future<double?> systemVolume() {
    throw UnimplementedError('systemVolume() has not been implemented.');
  }

  Future<double?> volumeUp({double step = 1.0 / 16.0}) {
    throw UnimplementedError('volumeUp() has not been implemented.');
  }

  Future<double?> volumeDown({double step = 1.0 / 16.0}) {
    throw UnimplementedError('volumeDown() has not been implemented.');
  }

  Future<void> volUiMode(int mode) {
    throw UnimplementedError('volUiMode() has not been implemented.');
  }

  Future<bool?> initTexture() {
    throw UnimplementedError('initTexture() has not been implemented.');
  }
}
