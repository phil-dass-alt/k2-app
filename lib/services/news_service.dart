import '../models/news_article_model.dart';

class NewsService {
  static final List<NewsArticleModel> _mockArticles = [
    NewsArticleModel(
      id: 'news-001',
      title: 'India\'s AI Startup Ecosystem Reaches \$5B Valuation',
      summary: 'Indian AI startups have collectively reached a combined valuation of over \$5 billion, driven by enterprise adoption and government initiatives.',
      source: 'TechCrunch India',
      category: 'Technology & AI',
      publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      url: 'https://example.com/news/001',
      isBreaking: true,
    ),
    NewsArticleModel(
      id: 'news-002',
      title: 'RBI Raises Interest Rates to Combat Inflation',
      summary: 'The Reserve Bank of India has announced a 25 basis point increase in the repo rate, marking the third consecutive hike this year.',
      source: 'Economic Times',
      category: 'Banking & Finance',
      publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
      url: 'https://example.com/news/002',
      isBreaking: false,
    ),
    NewsArticleModel(
      id: 'news-003',
      title: 'K2 Communications Wins Best Agency Award 2024',
      summary: 'K2 Communications has been recognized as the Best B2B Communications Agency at the India Marketing Excellence Awards 2024.',
      source: 'K2 Communications',
      category: 'Company News',
      publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
      url: 'https://example.com/news/003',
      isBreaking: true,
    ),
    NewsArticleModel(
      id: 'news-004',
      title: 'Digital Marketing Budgets to Increase by 40% in 2025',
      summary: 'A new industry report forecasts that enterprise digital marketing budgets will grow by 40% in 2025, with social media and AI-driven content leading the charge.',
      source: 'Marketing Week',
      category: 'Marketing',
      publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
      url: 'https://example.com/news/004',
      isBreaking: false,
    ),
    NewsArticleModel(
      id: 'news-005',
      title: 'SEBI Tightens Regulations for Financial Advertising',
      summary: 'SEBI has issued new guidelines for financial product advertising, requiring stricter disclaimers and performance data disclosures.',
      source: 'Business Standard',
      category: 'Regulations',
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      url: 'https://example.com/news/005',
      isBreaking: false,
    ),
    NewsArticleModel(
      id: 'news-006',
      title: 'Generative AI Tools Transforming Content Creation',
      summary: 'Marketing agencies across India are rapidly adopting generative AI tools for content creation, reducing production time by up to 60%.',
      source: 'Inc42',
      category: 'Technology & AI',
      publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      url: 'https://example.com/news/006',
      isBreaking: false,
    ),
    NewsArticleModel(
      id: 'news-007',
      title: 'HDFC Bank Surpasses 10 Crore Customer Milestone',
      summary: 'HDFC Bank has crossed the 10 crore customer mark, bolstered by its aggressive digital onboarding strategy and rural expansion.',
      source: 'Mint',
      category: 'Banking & Finance',
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      url: 'https://example.com/news/007',
      isBreaking: false,
    ),
    NewsArticleModel(
      id: 'news-008',
      title: 'K2 Communications Launches Employee Engagement Platform',
      summary: 'K2 Communications officially launches its proprietary employee engagement and client management platform to streamline operations.',
      source: 'K2 Communications',
      category: 'Company News',
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      url: 'https://example.com/news/008',
      isBreaking: false,
    ),
    NewsArticleModel(
      id: 'news-009',
      title: 'Influencer Marketing in India Grows 35% YoY',
      summary: 'India\'s influencer marketing industry has grown 35% year-over-year, with micro-influencers driving the highest engagement rates.',
      source: 'Afaqs',
      category: 'Marketing',
      publishedAt: DateTime.now().subtract(const Duration(days: 4)),
      url: 'https://example.com/news/009',
      isBreaking: false,
    ),
    NewsArticleModel(
      id: 'news-010',
      title: 'Data Privacy Act: New Compliance Requirements for Marketers',
      summary: 'The new Digital Personal Data Protection Act introduces key compliance requirements for marketers handling consumer data in India.',
      source: 'The Hindu Business Line',
      category: 'Regulations',
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      url: 'https://example.com/news/010',
      isBreaking: false,
    ),
  ];

  Future<List<NewsArticleModel>> getNews({String category = 'All'}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (category == 'All') return List.from(_mockArticles);
    return _mockArticles.where((a) => a.category == category).toList();
  }

  Future<List<NewsArticleModel>> getBreakingNews() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockArticles.where((a) => a.isBreaking).toList();
  }

  Future<List<NewsArticleModel>> searchNews(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lower = query.toLowerCase();
    return _mockArticles
        .where((a) =>
            a.title.toLowerCase().contains(lower) ||
            a.summary.toLowerCase().contains(lower) ||
            a.category.toLowerCase().contains(lower))
        .toList();
  }
}

final newsService = NewsService();
