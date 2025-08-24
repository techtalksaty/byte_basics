import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';

class ProgressScreen extends StatelessWidget {
  final String? highlightCategory;

  const ProgressScreen({super.key, this.highlightCategory});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);
    final totalCorrect = provider.getTotalCorrectAnswers();
    final totalQuestions = provider.getTotalQuestions();
    final totalProgress = provider.getTotalProgressPercentage();
    final earnedBadges = provider.getEarnedBadges();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Progress',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text('Total Correct: $totalCorrect/$totalQuestions'),
              Text('Completion: ${totalProgress.toStringAsFixed(1)}%'),
              const SizedBox(height: 16),
              Text(
                'Badges Earned',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              earnedBadges.isEmpty
                  ? const Text('No badges earned yet!')
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: earnedBadges
                          .map((badge) => Chip(
                                label: Text(badge.name),
                                backgroundColor: Colors.blue.shade100,
                              ))
                          .toList(),
                    ),
              const SizedBox(height: 16),
              Text(
                'Category Progress',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ...provider.categories.map((category) {
                final progress = provider.getProgressPercentage(category.name);
                final correctAnswers = provider.getCorrectAnswers(category.name);
                return Card(
                  color: category.name == highlightCategory ? Colors.blue.shade50 : null,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text(category.name),
                    subtitle: Text(
                      'Correct: $correctAnswers/${category.questions.length} (${progress.toStringAsFixed(1)}%)',
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Reset Progress'),
                        content: const Text('Are you sure you want to reset all progress and badges?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await provider.resetProgress();
                    }
                  },
                  child: const Text('Reset Progress'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}