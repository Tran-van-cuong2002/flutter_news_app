import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/api_service.dart';

class NewsProvider with ChangeNotifier {
  List<Article> _allArticles = [];
  List<Article> _displayedArticles = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';

  // === TÍNH NĂNG MỚI: CHẾ ĐỘ SÁNG / TỐI ===
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  List<Article> get articles => _displayedArticles;
  List<Article> get favoriteArticles => _allArticles.where((a) => a.isFavorite).toList();
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final ApiService _apiService = ApiService();

  Future<void> loadNews() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _allArticles = await _apiService.fetchArticles();
      _applySearch();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _displayedArticles = List.from(_allArticles);
    } else {
      _displayedArticles = _allArticles
          .where((article) => article.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void toggleFavorite(Article article) {
    final index = _allArticles.indexWhere((a) => a.id == article.id);
    if (index != -1) {
      _allArticles[index].isFavorite = !_allArticles[index].isFavorite;
      notifyListeners();
    }
  }

  // === CÁC HÀM XỬ LÝ CHO CÀI ĐẶT ===
  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners(); // Cập nhật lại toàn bộ giao diện app
  }

  void clearAllFavorites() {
    for (var article in _allArticles) {
      article.isFavorite = false; // Bỏ tim tất cả
    }
    notifyListeners();
  }
}