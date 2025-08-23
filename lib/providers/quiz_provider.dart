import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/category_model.dart';
import '../models/progress_model.dart';

class QuizProvider with ChangeNotifier {
  List<Category> _categories = [];
  Category? _selectedCategory;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  bool _isLoading = true;
  String? _error;
  final Box<Progress> _progressBox = Hive.box<Progress>('progressBox');

  List<Category> get categories => _categories;
  Category? get selectedCategory => _selectedCategory;
  int get currentQuestionIndex => _currentQuestionIndex;
  String? get selectedAnswer => _selectedAnswer;
  bool get showResult => _showResult;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      final String response = await rootBundle.loadString('assets/questions.json');
      final Map<String, dynamic> data = jsonDecode(response);
      _categories = (data['categories'] as List)
          .map((c) => Category.fromJson(c))
          .toList();
      //print('Loaded categories: ${_categories.length}');
    } catch (e) {
      _error = 'Failed to load data: $e';
      //print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(Category category) {
    _selectedCategory = category;
    _currentQuestionIndex = 0;
    _selectedAnswer = null;
    _showResult = false;
    notifyListeners();
  }

  void selectAnswer(String answer) {
    if (_selectedCategory == null) return;
    final question = _selectedCategory!.questions[_currentQuestionIndex];
    final isCorrect = answer == question.options[question.answer];
    _selectedAnswer = answer;
    _showResult = true;

    // Save progress to Hive
    _progressBox.put(
      '${_selectedCategory!.name}_${question.id}',
      Progress(
        category: _selectedCategory!.name,
        questionId: question.id,
        correct: isCorrect,
      ),
    );

    notifyListeners();
  }

  void nextQuestion() {
    if (_selectedCategory != null &&
        _currentQuestionIndex < _selectedCategory!.questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswer = null;
      _showResult = false;
      notifyListeners();
    }
  }

  double getProgressPercentage(String categoryName) {
    final totalQuestions = _categories
        .firstWhere((cat) => cat.name == categoryName)
        .questions
        .length;
    final completedQuestions = _progressBox.values
        .where((p) => p.category == categoryName)
        .length;
    return totalQuestions > 0 ? (completedQuestions / totalQuestions) * 100 : 0.0;
  }

  int getCorrectAnswers(String categoryName) {
    return _progressBox.values
        .where((p) => p.category == categoryName && p.correct)
        .length;
  }
}