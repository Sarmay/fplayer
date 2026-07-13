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
}
