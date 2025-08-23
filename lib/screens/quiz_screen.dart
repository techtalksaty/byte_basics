import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/question_card.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);
    final category = provider.selectedCategory;

    if (category == null || category.questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No questions available')),
      );
    }

    final question = category.questions[provider.currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${category.name} Quiz'),
      ),
      body: QuestionCard(
        question: question,
        onAnswerSelected: provider.selectAnswer,
        showResult: provider.showResult,
        selectedAnswer: provider.selectedAnswer,
        onNext: provider.nextQuestion,
      ),
    );
  }
}