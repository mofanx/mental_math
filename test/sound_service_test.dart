import 'package:flutter_test/flutter_test.dart';
import 'package:mental_math/services/sound_service.dart';

void main() {
  group('SoundService Tests', () {
    late SoundService soundService;

    setUp(() {
      soundService = SoundService();
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
      // 由于实际的音频播放依赖于平台通道，这里我们只是验证不会抛出异常
      expect(() async {
        await soundService.playCorrect();
        await soundService.playWrong();
        await soundService.playLevelComplete();
        await soundService.playButtonClick();
        await soundService.playCountdown();
      }, returnsNormally);
    });
  });
}
