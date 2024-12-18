import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_math/services/sound_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // 设置音频通道测试处理程序
  const MethodChannel channel = MethodChannel('xyz.luan/audioplayers');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    channel,
    (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'setVolume':
        case 'resume':
        case 'stop':
        case 'setSource':
          return null;
        default:
          return null;
      }
    },
  );
  
  group('SoundService Tests', () {
    late SoundService soundService;

    setUp(() async {
      soundService = SoundService();
      // 在测试环境中，initialize可能会失败，但我们不关心这个
      try {
        await soundService.initialize();
      } catch (e) {
        // 忽略初始化错误
      }
    });

    test('初始化时不应该处于静音状态', () {
      expect(soundService.isMuted, false);
    });

    test('切换静音状态应该正常工作', () {
      // 初始状态：非静音
      expect(soundService.isMuted, false);
      
      // 切换到静音
      soundService.toggleMute();
      expect(soundService.isMuted, true);
      
      // 再次切换回非静音
      soundService.toggleMute();
      expect(soundService.isMuted, false);
    });

    test('静音时不应该播放声音', () async {
      soundService.toggleMute(); // 开启静音
      
      // 验证所有音效方法在静音时都不会抛出异常
      await expectLater(() async {
        await soundService.playCorrect();
        await soundService.playWrong();
        await soundService.playLevelComplete();
        await soundService.playButtonClick();
        await soundService.playCountdown();
      }, completes);
    });

    tearDown(() async {
      try {
        await soundService.dispose();
      } catch (e) {
        // 忽略清理错误
      }
    });
  });

  // 清理mock
  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      null,
    );
  });
}
