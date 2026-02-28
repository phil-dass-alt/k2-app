class AppConstants {
  static const appName = 'K2 Communications';
  static const appVersion = '1.0.0';
  static const appBuildNumber = '1';

  // Firebase Collections
  static const colUsers = 'users';
  static const colClients = 'clients';
  static const colTasks = 'tasks';
  static const colCampaigns = 'campaigns';
  static const colMeetings = 'meetings';
  static const colDailyReports = 'daily_reports';
  static const colForumChannels = 'forum_channels';
  static const colForumThreads = 'forum_threads';
  static const colForumComments = 'forum_comments';
  static const colNotifications = 'notifications';
  static const colNewsPreferences = 'news_preferences';

  // Pagination
  static const pageSize = 20;
  static const newsFeedPageSize = 10;
  static const threadPageSize = 15;

  // Cache durations (minutes)
  static const newsCacheDuration = 15;
  static const userCacheDuration = 60;

  // OTP
  static const otpLength = 6;
  static const otpResendSeconds = 60;

  // Demo credentials
  static const demoAdminEmail = 'admin@k2.com';
  static const demoAdminPassword = 'password';
  static const demoEmployeeEmail = 'emp@k2.com';
  static const demoEmployeePassword = 'password';

  // News categories
  static const newsCategories = [
    'All',
    'Technology & AI',
    'Company News',
    'Banking & Finance',
    'Marketing',
    'Industry Updates',
    'Regulations',
  ];

  // Task priorities
  static const taskPriorities = ['Low', 'Medium', 'High', 'Urgent'];

  // Regions
  static const regions = [
    'North',
    'South',
    'East',
    'West',
    'Central',
    'Northeast',
  ];

  // Languages
  static const supportedLanguages = [
    'English',
    'Hindi',
    'Kannada',
    'Marathi',
    'Tamil',
    'Telugu',
    'Bengali',
  ];
}
