import 'dart:math';
import 'game_state.dart';

class Question {
  final String question;
  final int answer;
  final List<int> options;

  Question({
    required this.question,
    required this.answer,
    required this.options,
  });
}

class QuestionGenerator {
  final Random _random = Random();

  Question generateQuestion(GameLevel level) {
    switch (level) {
      case GameLevel.basic:
        return _generateBasicQuestion();
      case GameLevel.advanced:
        return _generateAdvancedQuestion();
      case GameLevel.expert:
        return _generateExpertQuestion();
    }
  }

  Question _generateBasicQuestion() {
    final isAddition = _random.nextBool();
    int num1, num2;

    if (isAddition) {
      num1 = _random.nextInt(10) + 1; // 1-10
      num2 = _random.nextInt(10) + 1; // 1-10
      return _createQuestion('$num1 + $num2 = ?', num1 + num2);
    } else {
      num1 = _random.nextInt(10) + 10; // 10-19
      num2 = _random.nextInt(num1 - 1) + 1; // 1-(num1-1)
      return _createQuestion('$num1 - $num2 = ?', num1 - num2);
    }
  }

  Question _generateAdvancedQuestion() {
    final isAddition = _random.nextBool();
    int num1, num2;

    if (isAddition) {
      num1 = _random.nextInt(50) + 1; // 1-50
      num2 = _random.nextInt(50) + 1; // 1-50
      return _createQuestion('$num1 + $num2 = ?', num1 + num2);
    } else {
      num1 = _random.nextInt(50) + 50; // 50-99
      num2 = _random.nextInt(50) + 1; // 1-50
      return _createQuestion('$num1 - $num2 = ?', num1 - num2);
    }
  }

  Question _generateExpertQuestion() {
    final isMultiplication = _random.nextBool();
    int num1, num2;

    if (isMultiplication) {
      num1 = _random.nextInt(9) + 2; // 2-10
      num2 = _random.nextInt(9) + 2; // 2-10
      return _createQuestion('$num1 × $num2 = ?', num1 * num2);
    } else {
      num2 = _random.nextInt(9) + 2; // 2-10
      num1 = num2 * (_random.nextInt(9) + 2); // 确保能整除
      return _createQuestion('$num1 ÷ $num2 = ?', num1 ~/ num2);
    }
  }

  Question _createQuestion(String questionText, int answer) {
    final List<int> options = _generateOptions(answer);
    return Question(
      question: questionText,
      answer: answer,
      options: options,
    );
  }

  List<int> _generateOptions(int correctAnswer) {
    final Set<int> options = {correctAnswer};
    
    while (options.length < 4) {
      // 生成一个在正确答案周围的随机数
      int offset = _random.nextInt(5) + 1;
      if (_random.nextBool()) offset = -offset;
      
      int option = correctAnswer + offset;
      if (option > 0) { // 确保选项为正数
        options.add(option);
      }
    }
    
    final List<int> shuffledOptions = options.toList()..shuffle();
    return shuffledOptions;
  }
}
