import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/badge_model.dart';
import 'models/progress_model.dart';
import 'models/category_model.dart';
import 'models/question_model.dart';
import 'models/learn_content_model.dart';
import 'providers/quiz_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProgressAdapter());
  Hive.registerAdapter(QuizBadgeAdapter());
  Hive.registerAdapter(QuizCategoryAdapter());
  Hive.registerAdapter(QuestionAdapter());
  Hive.registerAdapter(LearnContentAdapter());
  Hive.registerAdapter(LearnCategoryAdapter());
  await Hive.openBox<Progress>('progressBox');
  await Hive.openBox<QuizBadge>('badgeBox');
  runApp(const ByteBasicsApp());
}

class ByteBasicsApp extends StatelessWidget {
  const ByteBasicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizProvider()..loadData(),
      child: MaterialApp(
        title: 'ByteBasics',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1976D2), // Blue primary color
            primary: const Color(0xFF1976D2), // Buttons, AppBar
            secondary: const Color(0xFF4CAF50), // Accents (e.g., correct answer)
            surface: const Color(0xFFF5F5F5), // Backgrounds, cards (light mode)
            onSurface: Colors.black87, // Text on backgrounds
            error: const Color(0xFFD32F2F), // Incorrect answer
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light grey background
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1976D2),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF1976D2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          textTheme: const TextTheme(
            headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1976D2),
            primary: const Color(0xFF42A5F5), // Lighter blue for dark mode
            secondary: const Color(0xFF66BB6A), // Lighter green for dark mode
            surface: const Color(0xFF2D2D2D), // Dark background
            onSurface: Colors.white70, // Text on dark backgrounds
            error: const Color(0xFFE57373), // Lighter red for errors
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF2D2D2D),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF42A5F5),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF424242),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF42A5F5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          textTheme: const TextTheme(
            headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white70),
            titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
            bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ),
        themeMode: ThemeMode.system, // Use system light/dark mode
        home: const HomeScreen(),
      ),
    );
  }
}