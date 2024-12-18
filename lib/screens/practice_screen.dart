import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_state.dart';
import '../services/question_generator.dart';
import 'result_screen.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late QuestionGenerator _questionGenerator;
  late Question _currentQuestion;
  bool _showResult = false;
  bool? _isCorrect;
  int? _selectedAnswer;
  final int _questionsPerRound = 10;
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _questionGenerator = QuestionGenerator();
    _generateNewQuestion();
  }

  void _generateNewQuestion() {
    final gameState = context.read<GameState>();
    setState(() {
      _currentQuestion = _questionGenerator.generateQuestion(gameState.currentLevel);
      _showResult = false;
      _isCorrect = null;
      _selectedAnswer = null;
    });
  }

  void _checkAnswer(int answer) {
    if (_showResult) return;

    setState(() {
      _selectedAnswer = answer;
      _isCorrect = answer == _currentQuestion.answer;
      _showResult = true;
    });

    final gameState = context.read<GameState>();
    gameState.recordAnswer(_isCorrect!);

    Future.delayed(const Duration(seconds: 1), () {
      if (_currentQuestionIndex < _questionsPerRound - 1) {
        setState(() {
          _currentQuestionIndex++;
        });
        _generateNewQuestion();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ResultScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7F7FD5), Color(0xFF91EAE4)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '题目 ${_currentQuestionIndex + 1}/$_questionsPerRound',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Consumer<GameState>(
                      builder: (context, gameState, child) {
                        return Text(
                          '得分: ${gameState.score}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            _currentQuestion.question,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: _currentQuestion.options.map((option) {
                          Color? buttonColor;
                          if (_showResult && _selectedAnswer == option) {
                            buttonColor = _isCorrect! ? Colors.green : Colors.red;
                          }

                          return SizedBox(
                            width: 140,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: _showResult ? null : () => _checkAnswer(option),
                              child: Text(
                                option.toString(),
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
