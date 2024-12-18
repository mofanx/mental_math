import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_state.dart';
import 'practice_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '心算练习',
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                _buildLevelButton(
                  context,
                  '基础级：20以内加减法',
                  GameLevel.basic,
                  Colors.green,
                ),
                const SizedBox(height: 20),
                _buildLevelButton(
                  context,
                  '进阶级：100以内加减法',
                  GameLevel.advanced,
                  Colors.orange,
                ),
                const SizedBox(height: 20),
                _buildLevelButton(
                  context,
                  '高级级：简单乘除法',
                  GameLevel.expert,
                  Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelButton(
    BuildContext context,
    String text,
    GameLevel level,
    Color color,
  ) {
    return SizedBox(
      width: 280,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        onPressed: () {
          context.read<GameState>().setLevel(level);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PracticeScreen(),
            ),
          );
        },
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
