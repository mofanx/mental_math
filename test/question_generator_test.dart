import 'package:flutter_test/flutter_test.dart';
import 'package:mental_math/services/question_generator.dart';

void main() {
  group('QuestionGenerator Tests', () {
    late QuestionGenerator generator;

    setUp(() {
      generator = QuestionGenerator();
    });

    test('生成的问题应该在指定范围内', () {
      const int maxNumber = 100;
      for (int i = 0; i < 100; i++) {
        final question = generator.generateQuestion(maxNumber: maxNumber);
        expect(question.firstNumber, lessThanOrEqualTo(maxNumber));
        expect(question.secondNumber, lessThanOrEqualTo(maxNumber));
      }
    });

    test('答案应该正确', () {
      const int maxNumber = 100;
      for (int i = 0; i < 100; i++) {
        final question = generator.generateQuestion(maxNumber: maxNumber);
        final expectedAnswer = question.firstNumber + question.secondNumber;
        expect(question.answer, equals(expectedAnswer));
      }
    });

    test('不同难度级别应该生成不同范围的数字', () {
      final easyQuestion = generator.generateQuestion(maxNumber: 10);
      expect(easyQuestion.firstNumber, lessThanOrEqualTo(10));
      expect(easyQuestion.secondNumber, lessThanOrEqualTo(10));

      final hardQuestion = generator.generateQuestion(maxNumber: 100);
      expect(hardQuestion.firstNumber, lessThanOrEqualTo(100));
      expect(hardQuestion.secondNumber, lessThanOrEqualTo(100));
    });
  });
}
