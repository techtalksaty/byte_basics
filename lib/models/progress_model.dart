import 'package:hive/hive.dart';

part 'progress_model.g.dart';

@HiveType(typeId: 0)
class Progress extends HiveObject {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final String questionId;

  @HiveField(2)
  final bool correct;

  Progress({
    required this.category,
    required this.questionId,
    required this.correct,
  });
}