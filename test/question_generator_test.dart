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
        // 解析问题字符串来获取数字
        final numbers = _extractNumbers(question.question);
        expect(numbers.length, 2, reason: '问题应该包含两个数字');
        
        if (question.question.contains('+')) {
          expect(numbers[0], lessThanOrEqualTo(10));
          expect(numbers[1], lessThanOrEqualTo(10));
        } else {
          expect(numbers[0], inRange(10, 20));
          expect(numbers[1], lessThan(numbers[0]));
        }
      }
    });

    test('高级级别的问题应该在合适的范围内', () {
      for (int i = 0; i < 100; i++) {
        final question = generator.generateQuestion(GameLevel.advanced);
        final numbers = _extractNumbers(question.question);
        expect(numbers.length, 2, reason: '问题应该包含两个数字');
        
        if (question.question.contains('+')) {
          expect(numbers[0], lessThanOrEqualTo(50));
          expect(numbers[1], lessThanOrEqualTo(50));
        } else {
          expect(numbers[0], inRange(20, 100));
          expect(numbers[1], lessThan(numbers[0]));
        }
      }
    });

    test('专家级别的问题应该在合适的范围内', () {
      for (int i = 0; i < 100; i++) {
        final question = generator.generateQuestion(GameLevel.expert);
        final numbers = _extractNumbers(question.question);
        expect(numbers.length, 2, reason: '问题应该包含两个数字');
        
        if (question.question.contains('+')) {
          expect(numbers[0], lessThanOrEqualTo(100));
          expect(numbers[1], lessThanOrEqualTo(100));
        } else {
          expect(numbers[0], inRange(50, 200));
          expect(numbers[1], lessThan(numbers[0]));
        }
      }
    });

    test('答案应该正确', () {
      for (int i = 0; i < 100; i++) {
        final question = generator.generateQuestion(GameLevel.basic);
        final numbers = _extractNumbers(question.question);
        final expectedAnswer = question.question.contains('+') 
            ? numbers[0] + numbers[1] 
            : numbers[0] - numbers[1];
        expect(question.answer, equals(expectedAnswer));
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
