import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;

  // 音效路径
  static const String _correctSound = 'assets/sounds/correct.mp3';
  static const String _wrongSound = 'assets/sounds/wrong.mp3';
  static const String _levelCompleteSound = 'assets/sounds/level_complete.mp3';
  static const String _buttonClickSound = 'assets/sounds/button_click.mp3';
  static const String _countdownSound = 'assets/sounds/countdown.mp3';

  // 音量设置
  static const double _defaultVolume = 0.5;
  static const double _buttonVolume = 0.3;

  bool get isMuted => _isMuted;

  // 初始化
  Future<void> initialize() async {
    await _audioPlayer.setVolume(_defaultVolume);
  }

  // 切换静音状态
  void toggleMute() {
    _isMuted = !_isMuted;
  }

  // 播放正确答案音效
  Future<void> playCorrect() async {
    if (_isMuted) return;
    await _playSound(_correctSound);
  }

  // 播放错误答案音效
  Future<void> playWrong() async {
    if (_isMuted) return;
    await _playSound(_wrongSound);
  }

  // 播放完成关卡音效
  Future<void> playLevelComplete() async {
    if (_isMuted) return;
    await _playSound(_levelCompleteSound);
  }

  // 播放按钮点击音效
  Future<void> playButtonClick() async {
    if (_isMuted) return;
    await _playSound(_buttonClickSound, volume: _buttonVolume);
  }

  // 播放倒计时音效
  Future<void> playCountdown() async {
    if (_isMuted) return;
    await _playSound(_countdownSound);
  }

  // 通用播放音效方法
  Future<void> _playSound(String assetPath, {double? volume}) async {
    try {
      await _audioPlayer.stop(); // 停止当前正在播放的音效
      await _audioPlayer.setVolume(volume ?? _defaultVolume);
      await _audioPlayer.setSource(AssetSource(assetPath));
      await _audioPlayer.resume();
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  // 释放资源
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
