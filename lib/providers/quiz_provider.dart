import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';
import '../models/badge_model.dart';
import '../models/category_model.dart';
import '../models/progress_model.dart';

class QuizProvider with ChangeNotifier {
  List<QuizCategory> _categories = [];
  List<LearnCategory> _learnCategories = [];
  QuizCategory? _selectedCategory;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  bool _isLoading = true;
  String? _error;
  final Box<Progress> _progressBox = Hive.box<Progress>('progressBox');
  final Box<QuizBadge> _badgeBox = Hive.box<QuizBadge>('badgeBox');

  List<QuizCategory> get categories => _categories;
  List<LearnCategory> get learnCategories => _learnCategories;
  QuizCategory? get selectedCategory => _selectedCategory;
  int get currentQuestionIndex => _currentQuestionIndex;
  String? get selectedAnswer => _selectedAnswer;
  bool get showResult => _showResult;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLastQuestion =>
      _selectedCategory != null &&
      _currentQuestionIndex == _selectedCategory!.questions.length - 1;

  Future<void> loadData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Load quiz questions
      final String quizResponse = await rootBundle.loadString('assets/questions.json');
      // Debug-only: Log quiz JSON
      if (kDebugMode) {
        developer.log('Loaded quiz JSON: $quizResponse', name: 'QuizProvider');
      }
      final Map<String, dynamic> quizData = jsonDecode(quizResponse);
      _categories = (quizData['categories'] as List)
          .map((c) => QuizCategory.fromJson(c))
          .toList();

      // Load learning content
      final String learnResponse = await rootBundle.loadString('assets/learn_content.json');
      // Debug-only: Log learn JSON
      if (kDebugMode) {
        developer.log('Loaded learn JSON: $learnResponse', name: 'QuizProvider');
      }
      final Map<String, dynamic> learnData = jsonDecode(learnResponse);
      _learnCategories = (learnData['categories'] as List)
          .map((c) => LearnCategory.fromJson(c))
          .toList();

      // Debug-only: Validate category alignment
      if (kDebugMode) {
        final quizNames = _categories.map((c) => c.name).toSet();
        final learnNames = _learnCategories.map((c) => c.name).toSet();
        if (quizNames.length != learnNames.length || quizNames.difference(learnNames).isNotEmpty) {
          developer.log('Category mismatch between questions and learn content: Quiz=$quizNames, Learn=$learnNames', name: 'QuizProvider');
        }
        developer.log('Loaded quiz categories: ${_categories.length}, learn categories: ${_learnCategories.length}', name: 'QuizProvider');
      }

      // Initialize badges for each quiz category
      for (var category in _categories) {
        if (!_badgeBox.containsKey(category.name)) {
          _badgeBox.put(
            category.name,
            QuizBadge(
              name: '${category.name} Master',
              category: category.name,
              earned: false,
            ),
          );
        }
      }
    } catch (e) {
      _error = 'Failed to load data: $e';
      // Debug-only: Log errors
      if (kDebugMode) {
        developer.log('Error: $e', name: 'QuizProvider');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(QuizCategory category, {bool forLearning = false}) {
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

    // Check if category is fully completed correctly
    if (getCorrectAnswers(_selectedCategory!.name) == _selectedCategory!.questions.length) {
      _badgeBox.put(
        _selectedCategory!.name,
        QuizBadge(
          name: '${_selectedCategory!.name} Master',
          category: _selectedCategory!.name,
          earned: true,
        ),
      );
    }

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
        .firstWhere((cat) => cat.name == categoryName, orElse: () => QuizCategory(name: categoryName, questions: []))
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

  int getTotalCorrectAnswers() {
    return _progressBox.values.where((p) => p.correct).length;
  }

  int getTotalQuestions() {
    return _categories.fold(0, (sum, cat) => sum + cat.questions.length);
  }

  double getTotalProgressPercentage() {
    final totalQuestions = getTotalQuestions();
    final completedQuestions = _progressBox.values.length;
    return totalQuestions > 0 ? (completedQuestions / totalQuestions) * 100 : 0.0;
  }

  List<QuizBadge> getEarnedBadges() {
    return _badgeBox.values.where((badge) => badge.earned).toList();
  }

  void resetProgress() {
    _progressBox.clear();
    for (var category in _categories) {
      _badgeBox.put(
        category.name,
        QuizBadge(
          name: '${category.name} Master',
          category: category.name,
          earned: false,
        ),
      );
    }
    // Reset UI state
    _selectedAnswer = null;
    _showResult = false;
    _currentQuestionIndex = 0;
    notifyListeners();
  }
}