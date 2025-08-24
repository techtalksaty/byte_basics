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
    final scrollController = ScrollController();

    // Scroll to highlighted category after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (highlightCategory != null) {
        final index = provider.categories.indexWhere((cat) => cat.name == highlightCategory);
        if (index != -1) {
          scrollController.animateTo(
            index * 100.0, // Approximate height per item
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        centerTitle: true,
      ),
      body: provider.categories.isEmpty
          ? const Center(child: Text('No progress data available'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Stats
                  Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Overall Progress',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Total Correct: $totalCorrect/$totalQuestions'),
                          Text('Completion: ${totalProgress.toStringAsFixed(1)}%'),
                          LinearProgressIndicator(
                            value: totalProgress / 100,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Reset Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Reset Progress'),
                            content: const Text('Are you sure you want to reset all progress? This cannot be undone.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  provider.resetProgress();
                                  Navigator.pop(context);
                                },
                                child: const Text('Reset'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Reset Progress'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Badges
                  const Text(
                    'Earned Badges',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  earnedBadges.isEmpty
                      ? const Text('No badges earned yet!')
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: earnedBadges.map((badge) {
                            return Chip(
                              label: Text(badge.name),
                              avatar: const Icon(Icons.star, color: Colors.yellow),
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 16),
                  // Category Progress
                  const Text(
                    'Category Progress',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: provider.categories.length,
                      itemBuilder: (context, index) {
                        final category = provider.categories[index];
                        final progressPercentage = provider.getProgressPercentage(category.name);
                        final correctAnswers = provider.getCorrectAnswers(category.name);
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          color: category.name == highlightCategory
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : null,
                          child: ListTile(
                            title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Correct: $correctAnswers/${category.questions.length}'),
                                Text('Progress: ${progressPercentage.toStringAsFixed(1)}%'),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: progressPercentage / 100,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}