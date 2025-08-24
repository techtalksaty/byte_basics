import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/badge_model.dart';
import 'models/progress_model.dart';
import 'providers/quiz_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProgressAdapter());
  Hive.registerAdapter(QuizBadgeAdapter()); // Updated to QuizBadgeAdapter
  await Hive.openBox<Progress>('progressBox');
  await Hive.openBox<QuizBadge>('badgeBox'); // Updated to QuizBadge
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
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}