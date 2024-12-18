import 'package:flutter/foundation.dart';

enum GameLevel {
  basic,    // 20以内加减法
  advanced, // 100以内加减法
  expert    // 简单乘除法
}

class GameState with ChangeNotifier {
  GameLevel _currentLevel = GameLevel.basic;
  int _score = 0;
  int _consecutiveCorrect = 0;
  int _totalQuestions = 0;
  int _correctAnswers = 0;

  GameLevel get currentLevel => _currentLevel;
  int get score => _score;
  int get consecutiveCorrect => _consecutiveCorrect;
  int get totalQuestions => _totalQuestions;
  int get correctAnswers => _correctAnswers;
  double get accuracy => _totalQuestions == 0 ? 0 : _correctAnswers / _totalQuestions * 100;

  void setLevel(GameLevel level) {
    _currentLevel = level;
    notifyListeners();
  }

  void addScore(int points) {
    _score += points;
    notifyListeners();
  }

  void recordAnswer(bool correct) {
    _totalQuestions++;
    if (correct) {
      _correctAnswers++;
      _consecutiveCorrect++;
      // 连续答对奖励
      addScore(_consecutiveCorrect * 10);
    } else {
      _consecutiveCorrect = 0;
    }
    notifyListeners();
  }

  void resetGame() {
    _score = 0;
    _consecutiveCorrect = 0;
    _totalQuestions = 0;
    _correctAnswers = 0;
    notifyListeners();
  }
}
