import 'package:hive/hive.dart';

part 'question_model.g.dart';

@HiveType(typeId: 3) // Unique typeId (0: Progress, 1: QuizBadge, 2: QuizCategory)
class Question {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String question;

  @HiveField(2)
  final List<String> options;

  @HiveField(3)
  final int answer;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List).cast<String>(),
      answer: json['answer'] as int,
    );
  }
}