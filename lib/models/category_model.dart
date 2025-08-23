import 'package:byte_basics/models/question_model.dart';

class Category {
  final String name;
  final List<Question> questions;

  Category({required this.name, required this.questions});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}