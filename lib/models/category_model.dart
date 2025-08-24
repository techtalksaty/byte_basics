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

  QuizCategory({
    required this.name,
    required this.questions,
  });

  factory QuizCategory.fromJson(Map<String, dynamic> json) {
    return QuizCategory(
      name: json['name'] as String,
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}

@HiveType(typeId: 5) // Unique typeId (0: Progress, 1: QuizBadge, 2: QuizCategory, 3: Question, 4: LearnContent)
class LearnCategory {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final List<LearnContent> learnContent;

  LearnCategory({
    required this.name,
    required this.learnContent,
  });

  factory LearnCategory.fromJson(Map<String, dynamic> json) {
    return LearnCategory(
      name: json['name'] as String,
      learnContent: (json['learnContent'] as List)
          .map((c) => LearnContent.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}