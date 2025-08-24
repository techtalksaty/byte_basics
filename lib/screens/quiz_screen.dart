import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/question_card.dart';
import 'progress_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);
    final category = provider.selectedCategory;

    if (category == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
          centerTitle: true,
        ),
        body: const Center(child: Text('No category selected')),
      );
    }

    final question = category.questions[provider.currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: QuestionCard(
              question: question,
              onAnswerSelected: provider.selectAnswer,
              showResult: provider.showResult,
              selectedAnswer: provider.selectedAnswer,
              onNext: provider.isLastQuestion
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProgressScreen(highlightCategory: category.name),
                        ),
                      );
                    }
                  : provider.nextQuestion,
            ),
          ),
          if (provider.showResult && provider.isLastQuestion)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProgressScreen(highlightCategory: category.name),
                    ),
                  );
                },
                child: const Text('Show Results'),
              ),
            ),
        ],
      ),
    );
  }
}