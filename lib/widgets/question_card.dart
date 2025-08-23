import 'package:flutter/material.dart';
import '../models/question_model.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Custom radio-like selection using ListTile and GestureDetector
          ...question.options.map((option) {
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
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
                title: Text(option),
                enabled: !showResult,
              ),
            );
          }),
          if (showResult) ...[
            const SizedBox(height: 20),
            Text(
              selectedAnswer == question.options[question.answer]
                  ? 'Correct!'
                  : 'Incorrect. ${question.explanation}',
              style: TextStyle(
                color: selectedAnswer == question.options[question.answer]
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onNext,
              child: const Text('Next Question'),
            ),
          ],
        ],
      ),
    );
  }
}