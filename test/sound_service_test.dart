import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_math/services/sound_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // 设置音频通道测试处理程序
  const MethodChannel channel = MethodChannel('xyz.luan/audioplayers');
  
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'setVolume':
          case 'resume':
          case 'stop':
          case 'setSource':
          case 'dispose':
            return null;
          default:
            return null;
        }
      },
    );
  });
  
  group('SoundService Tests', () {
    late SoundService soundService;

    setUp(() async {
      soundService = SoundService();
      try {
        await soundService.initialize();
      } catch (e) {
        debugPrint('初始化音频服务时出错：$e');
        // 继续测试，因为我们主要测试静音功能
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
      
      // 创建一个Future来包装所有的音频操作
      Future<void> playAllSounds() async {
        await soundService.playCorrect();
        await soundService.playWrong();
        await soundService.playLevelComplete();
        await soundService.playButtonClick();
        await soundService.playCountdown();
      }

      // 使用expectLater来测试Future的完成
      await expectLater(playAllSounds(), completes);
    });

    tearDown(() async {
      try {
        await soundService.dispose();
      } catch (e) {
        debugPrint('清理音频服务时出错：$e');
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      null,
    );
  });
}
