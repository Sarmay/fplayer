import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sarmay_fplayer/fplayer.dart';
import 'package:sarmay_fplayer/fplayer_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FOption', () {
    test('returns a defensive copy of configured values', () {
      final option = FOption()
        ..setHostOption('request-screen-on', 1)
        ..setPlayerOption('reconnect', 20);

      final firstCopy = option.data;
      firstCopy[FOption.hostCategory]!['request-screen-on'] = 0;

      expect(option.data[FOption.hostCategory]!['request-screen-on'], 1);
      expect(option.data[FOption.playerCategory]!['reconnect'], 20);
    });
  });

  group('FVolume', () {
    final channel = MethodChannelFplayer().methodChannel;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

    tearDown(() {
      messenger.setMockMethodCallHandler(channel, null);
    });

    test('rejects UI modes outside the supported range', () async {
      await expectLater(FVolume.setUIMode(-1), throwsArgumentError);
      await expectLater(FVolume.setUIMode(4), throwsArgumentError);
    });

    test('forwards valid UI modes to the platform channel', () async {
      MethodCall? receivedCall;
      messenger.setMockMethodCallHandler(channel, (call) async {
        receivedCall = call;
        return null;
      });

      await FVolume.setUIMode(FVolume.neverShowUI);

      expect(receivedCall?.method, 'volUiMode');
      expect(receivedCall?.arguments, {'mode': FVolume.neverShowUI});
    });
  });

  group('FPlayer pause resume', () {
    const pluginChannel = MethodChannel('befovy.com/fijk');
    const playerChannel = MethodChannel('befovy.com/fijkplayer/7');
    const eventChannelName = 'befovy.com/fijkplayer/event/7';
    const codec = StandardMethodCodec();
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

    setUp(() {
      messenger.setMockMethodCallHandler(pluginChannel, (call) async {
        if (call.method == 'createPlayer') return 7;
        return null;
      });
      messenger.setMockMessageHandler(
        eventChannelName,
        (message) async => codec.encodeSuccessEnvelope(null),
      );
    });

    tearDown(() {
      messenger.setMockMethodCallHandler(pluginChannel, null);
      messenger.setMockMethodCallHandler(playerChannel, null);
      messenger.setMockMessageHandler(eventChannelName, null);
    });

    test(
      'restores the native position when starting after an explicit pause',
      () async {
        MethodCall? startCall;
        messenger.setMockMethodCallHandler(playerChannel, (call) async {
          if (call.method == 'getCurrentPosition') return 42000;
          if (call.method == 'start') startCall = call;
          return null;
        });

        final player = FPlayer();
        await player.id;
        await _emitPlayerEvent(messenger, eventChannelName, codec, {
          'event': 'prepared',
          'duration': 120000,
        });
        await _emitPlayerEvent(messenger, eventChannelName, codec, {
          'event': 'state_change',
          'new': FState.started.index,
          'old': FState.prepared.index,
        });

        await player.pause();
        await _emitPlayerEvent(messenger, eventChannelName, codec, {
          'event': 'state_change',
          'new': FState.paused.index,
          'old': FState.started.index,
        });
        await player.start();

        expect(startCall?.arguments, {'resumePosition': 42000});
        await player.release();
      },
    );
  });
}

Future<void> _emitPlayerEvent(
  TestDefaultBinaryMessenger messenger,
  String channel,
  StandardMethodCodec codec,
  Map<String, dynamic> event,
) async {
  await messenger.handlePlatformMessage(
    channel,
    codec.encodeSuccessEnvelope(event),
    (_) {},
  );
  await Future<void>.delayed(Duration.zero);
}
