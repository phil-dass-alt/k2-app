class NewsPreferenceModel {
  final String userId;
  final List<String> categories;
  final List<String> trackedCompanies;
  final bool breakingNewsAlert;
  final bool dailyDigest;

  const NewsPreferenceModel({
    required this.userId,
    this.categories = const [],
    this.trackedCompanies = const [],
    this.breakingNewsAlert = true,
    this.dailyDigest = false,
  });

  factory NewsPreferenceModel.fromJson(Map<String, dynamic> json) {
    return NewsPreferenceModel(
      userId: json['userId'] as String,
      categories: List<String>.from(json['categories'] ?? []),
      trackedCompanies: List<String>.from(json['trackedCompanies'] ?? []),
      breakingNewsAlert: json['breakingNewsAlert'] as bool? ?? true,
      dailyDigest: json['dailyDigest'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'categories': categories,
      'trackedCompanies': trackedCompanies,
      'breakingNewsAlert': breakingNewsAlert,
      'dailyDigest': dailyDigest,
    };
  }

  NewsPreferenceModel copyWith({
    String? userId,
    List<String>? categories,
    List<String>? trackedCompanies,
    bool? breakingNewsAlert,
    bool? dailyDigest,
  }) {
    return NewsPreferenceModel(
      userId: userId ?? this.userId,
      categories: categories ?? this.categories,
      trackedCompanies: trackedCompanies ?? this.trackedCompanies,
      breakingNewsAlert: breakingNewsAlert ?? this.breakingNewsAlert,
      dailyDigest: dailyDigest ?? this.dailyDigest,
    );
  }
}
