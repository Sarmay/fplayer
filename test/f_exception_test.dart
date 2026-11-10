import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sarmay_fplayer/fplayer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('FException', () {
    test('parses integer platform details as the extra code', () {
      final exception = FException.fromPlatformException(
        PlatformException(
          code: '-542398533',
          message: 'native error',
          details: -22,
        ),
      );

      expect(exception.code, FException.extErr);
      expect(exception.message, 'native error');
      expect(exception.extraCode, -22);
      expect(exception.toString(), 'FException(-542398533, native error, -22)');
    });

    test('parses integer string details as the extra code', () {
      final exception = FException.fromPlatformException(
        PlatformException(code: '17', details: '-22'),
      );

      expect(exception.extraCode, -22);
    });

    test('ignores non-integer details and preserves unknown primary codes', () {
      final exception = FException.fromPlatformException(
        PlatformException(code: 'native-error', details: 'not-an-int'),
      );

      expect(exception.code, FException.unknown);
      expect(exception.extraCode, isNull);
      expect(exception.toString(), 'FException(${FException.unknown}, null)');
    });

    test('keeps missing details null and includes extraCode in equality', () {
      const withoutDetails = FException(1, 'error');
      const withDetails = FException(1, 'error', 2);

      expect(withoutDetails.extraCode, isNull);
      expect(withoutDetails.toString(), 'FException(1, error)');
      expect(withoutDetails, isNot(withDetails));
      expect(withoutDetails.hashCode, isNot(withDetails.hashCode));
    });
  });

  test(
    'keeps secondary codes through native events and notifies when they change',
    () async {
      const pluginChannel = MethodChannel('befovy.com/fijk');
      const playerChannel = MethodChannel('befovy.com/fijkplayer/91');
      const events = 'befovy.com/fijkplayer/event/91';
      const codec = StandardMethodCodec();
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(
        pluginChannel,
        (call) async => call.method == 'createPlayer' ? 91 : null,
      );
      messenger.setMockMethodCallHandler(playerChannel, (call) async => null);
      messenger.setMockMessageHandler(
        events,
        (message) async => codec.encodeSuccessEnvelope(null),
      );
      addTearDown(() {
        messenger.setMockMethodCallHandler(pluginChannel, null);
        messenger.setMockMethodCallHandler(playerChannel, null);
        messenger.setMockMessageHandler(events, null);
      });
      final player = FPlayer();
      await player.id;
      addTearDown(player.release);
      final received = <FException>[];
      player.addListener(() {
        if (player.state == FState.error) received.add(player.value.exception);
      });
      for (final extraCode in [-22, -23, -23]) {
        await messenger.handlePlatformMessage(
          events,
          codec.encodeErrorEnvelope(
            code: '-10000',
            message: 'native playback failure',
            details: extraCode,
          ),
          (_) {},
        );
        await Future<void>.delayed(Duration.zero);
      }
      expect(player.state, FState.error);
      expect(received.map((error) => error.extraCode), [-22, -23]);
      expect(received.every((error) => error.code == -10000), isTrue);
    },
  );
}
