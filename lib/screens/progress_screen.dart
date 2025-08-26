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
    final colorScheme = Theme.of(context).colorScheme;

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
              // Stats section
              Text(
                'Total Correct: $totalCorrect/$totalQuestions',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Completion: ${totalProgress.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              // Two-column layout for Category Progress and Badges/Reset
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column: Category Progress
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category Progress',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.categories.length,
                          itemBuilder: (context, index) {
                            final category = provider.categories[index];
                            final progress = provider.getProgressPercentage(category.name);
                            final correctAnswers = provider.getCorrectAnswers(category.name);
                            return Card(
                              color: category.name == highlightCategory ? colorScheme.surfaceContainerLow : null,
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                title: Text(category.name),
                                subtitle: Text(
                                  'Correct: $correctAnswers/${category.questions.length} (${progress.toStringAsFixed(1)}%)',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Right column: Reset button and Badges
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
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
                        const SizedBox(height: 16),
                        Text(
                          'Badges Earned',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        earnedBadges.isEmpty
                            ? Text(
                                'No badges earned yet!',
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            : Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: earnedBadges
                                    .map((badge) => Chip(
                                          label: Text(badge.name),
                                          backgroundColor: colorScheme.primaryContainer,
                                          labelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
                                        ))
                                    .toList(),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}