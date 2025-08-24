import 'package:hive/hive.dart';
import 'question_model.dart';
import 'learn_content_model.dart';

part 'category_model.g.dart';

@HiveType(typeId: 2)
class QuizCategory {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final List<Question> questions;

  @HiveField(2)
  final List<LearnContent> learnContent; // Added for learning material

  QuizCategory({
    required this.name,
    required this.questions,
    required this.learnContent,
  });

  factory QuizCategory.fromJson(Map<String, dynamic> json) {
    return QuizCategory(
      name: json['name'] as String,
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
      learnContent: (json['learnContent'] as List? ?? [])
          .map((c) => LearnContent.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}