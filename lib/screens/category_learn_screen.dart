import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryLearnScreen extends StatelessWidget {
  final LearnCategory category;

  const CategoryLearnScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        centerTitle: true,
      ),
      body: category.learnContent.isEmpty
          ? const Center(child: Text('No learning content available yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: category.learnContent.length,
              itemBuilder: (context, index) {
                final content = category.learnContent[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ExpansionTile(
                    title: Text(
                      content.question,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(content.answer),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}