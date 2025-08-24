import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/question_model.dart';
import '../providers/quiz_provider.dart';
import '../screens/progress_screen.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final Function(String) onAnswerSelected;
  final bool showResult;
  final String? selectedAnswer;
  final VoidCallback onNext;

  const QuestionCard({
    super.key,
    required this.question,
    required this.onAnswerSelected,
    required this.showResult,
    this.selectedAnswer,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context, listen: false);
    final isCorrect = showResult && selectedAnswer == question.options[question.answer];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = selectedAnswer == option;
            return GestureDetector(
              onTap: showResult ? null : () => onAnswerSelected(option),
              child: ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).primaryColor),
                    color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                  ),
                  child: isSelected && showResult
                      ? Icon(
                          isCorrect ? Icons.check : Icons.close,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
                title: Text(option),
              ),
            );
          }),
          if (showResult) ...[
            const SizedBox(height: 16),
            Text(
              isCorrect ? 'Correct!' : 'Incorrect. The correct answer is: ${question.options[question.answer]}',
              style: TextStyle(
                color: isCorrect ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (provider.isLastQuestion) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProgressScreen(
                          highlightCategory: provider.selectedCategory?.name,
                        ),
                      ),
                    );
                  } else {
                    onNext();
                  }
                },
                child: Text(provider.isLastQuestion ? 'Show Results' : 'Next Question'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}