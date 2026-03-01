class NewsArticleModel {
  final String id;
  final String title;
  final String summary;
  final String? imageUrl;
  final String source;
  final String category;
  final DateTime publishedAt;
  final String url;
  final bool isBreaking;

  const NewsArticleModel({
    required this.id,
    required this.title,
    required this.summary,
    this.imageUrl,
    required this.source,
    required this.category,
    required this.publishedAt,
    required this.url,
    this.isBreaking = false,
  });
}
