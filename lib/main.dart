import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/game_state.dart';

void main() {
  runApp(const MentalMathApp());
}

class MentalMathApp extends StatelessWidget {
  const MentalMathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: MaterialApp(
        title: '心算练习',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'RubikBubbles',
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
