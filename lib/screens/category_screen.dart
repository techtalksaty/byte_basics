import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'quiz_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);
    final categories = provider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
              ? Center(child: Text(provider.error!))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final progressPercentage = provider.getProgressPercentage(category.name);
                    final correctAnswers = provider.getCorrectAnswers(category.name);
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          category.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
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
                        onTap: () {
                          provider.selectCategory(category);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const QuizScreen()),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}