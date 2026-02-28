import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news_article_model.dart';
import '../services/news_service.dart';

class NewsState {
  final List<NewsArticleModel> articles;
  final List<NewsArticleModel> breakingNews;
  final bool isLoading;
  final String? error;
  final String selectedCategory;
  final String searchQuery;

  const NewsState({
    this.articles = const [],
    this.breakingNews = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory = 'All',
    this.searchQuery = '',
  });

  NewsState copyWith({
    List<NewsArticleModel>? articles,
    List<NewsArticleModel>? breakingNews,
    bool? isLoading,
    String? error,
    String? selectedCategory,
    String? searchQuery,
    bool clearError = false,
  }) {
    return NewsState(
      articles: articles ?? this.articles,
      breakingNews: breakingNews ?? this.breakingNews,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class NewsNotifier extends StateNotifier<NewsState> {
  final NewsService _newsService;

  NewsNotifier(this._newsService) : super(const NewsState()) {
    loadNews();
  }

  Future<void> loadNews({String category = 'All'}) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      selectedCategory: category,
    );
    try {
      final articles = await _newsService.getNews(category: category);
      final breaking = await _newsService.getBreakingNews();
      state = state.copyWith(
        articles: articles,
        breakingNews: breaking,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> search(String query) async {
    state = state.copyWith(isLoading: true, searchQuery: query, clearError: true);
    try {
      if (query.isEmpty) {
        final articles = await _newsService.getNews(category: state.selectedCategory);
        state = state.copyWith(articles: articles, isLoading: false);
      } else {
        final articles = await _newsService.searchNews(query);
        state = state.copyWith(articles: articles, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void selectCategory(String category) => loadNews(category: category);
}

final newsProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) {
  return NewsNotifier(newsService);
});
