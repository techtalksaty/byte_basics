import 'package:hive/hive.dart';

part 'learn_content_model.g.dart';

@HiveType(typeId: 4) // Unique typeId (0: Progress, 1: QuizBadge, 2: QuizCategory, 3: Question)
class LearnContent {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String question;

  @HiveField(2)
  final String answer;

  LearnContent({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory LearnContent.fromJson(Map<String, dynamic> json) {
    return LearnContent(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }
}