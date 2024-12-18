import 'package:flutter_test/flutter_test.dart';
import 'package:mental_math/services/question_generator.dart';
import 'package:mental_math/services/game_state.dart';

void main() {
  group('QuestionGenerator Tests', () {
    late QuestionGenerator generator;

    setUp(() {
      generator = QuestionGenerator();
    });

    test('基础级别的问题应该在合适的范围内', () {
      for (int i = 0; i < 100; i++) {
        final question = generator.generateQuestion(GameLevel.basic);
        final numbers = _extractNumbers(question.question);
        expect(numbers.length, 2, reason: '问题应该包含两个数字');
        
        if (question.question.contains('+')) {
          expect(numbers[0], inRange(1, 10));
          expect(numbers[1], inRange(1, 10));
        } else {
          expect(numbers[0], inRange(10, 19));
          expect(numbers[1], lessThan(numbers[0]));
          expect(numbers[1], greaterThan(0));
        }
      }
    });

    test('高级级别的问题应该在合适的范围内', () {
      for (int i = 0; i < 100; i++) {
        final question = generator.generateQuestion(GameLevel.advanced);
        final numbers = _extractNumbers(question.question);
        expect(numbers.length, 2, reason: '问题应该包含两个数字');
        
        if (question.question.contains('+')) {
          expect(numbers[0], inRange(1, 50));
          expect(numbers[1], inRange(1, 50));
        } else {
          expect(numbers[0], inRange(50, 99));
          expect(numbers[1], inRange(1, 50));
        }
      }
    });

    test('专家级别的问题应该在合适的范围内', () {
      for (int i = 0; i < 100; i++) {
        final question = generator.generateQuestion(GameLevel.expert);
        final numbers = _extractNumbers(question.question);
        expect(numbers.length, 2, reason: '问题应该包含两个数字');
        
        if (question.question.contains('×')) {
          expect(numbers[0], inRange(2, 10));
          expect(numbers[1], inRange(2, 10));
        } else if (question.question.contains('÷')) {
          expect(numbers[1], inRange(2, 10));
          // 第一个数字应该是第二个数字的倍数
          expect(numbers[0] % numbers[1], equals(0));
        }
      }
    });

    test('答案应该正确', () {
      for (int i = 0; i < 100; i++) {
        final question = generator.generateQuestion(GameLevel.expert);
        final numbers = _extractNumbers(question.question);
        int expectedAnswer;
        
        if (question.question.contains('+')) {
          expectedAnswer = numbers[0] + numbers[1];
        } else if (question.question.contains('-')) {
          expectedAnswer = numbers[0] - numbers[1];
        } else if (question.question.contains('×')) {
          expectedAnswer = numbers[0] * numbers[1];
        } else {
          expectedAnswer = numbers[0] ~/ numbers[1];
        }
        
        expect(question.answer, equals(expectedAnswer));
      }
    });

    test('选项应该包含正确答案', () {
      for (int i = 0; i < 100; i++) {
        final question = generator.generateQuestion(GameLevel.basic);
        expect(question.options.length, equals(4));
        expect(question.options.contains(question.answer), isTrue);
      }
    });
  });
}

List<int> _extractNumbers(String question) {
  final regex = RegExp(r'\d+');
  return regex.allMatches(question)
      .map((match) => int.parse(match.group(0)!))
      .toList();
}

Matcher inRange(int start, int end) => 
    allOf(greaterThanOrEqualTo(start), lessThanOrEqualTo(end));
