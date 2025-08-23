class Question {
  final int id;
  final String question;
  final List<String> options;
  final int answer;
  final String explanation;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
      explanation: json['explanation'],
    );
  }
}