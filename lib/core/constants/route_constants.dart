class RouteConstants {
  static const login = '/login';
  static const phoneLogin = '/login/phone';
  static const emailLogin = '/login/email';
  static const register = '/register';
  static const pendingActivation = '/pending-activation';

  static const dashboard = '/dashboard';

  static const clients = '/clients';
  static const clientDetail = '/clients/:id';

  static const work = '/work';
  static const tasks = '/work/tasks';
  static const newTask = '/work/tasks/new';
  static const campaigns = '/work/campaigns';
  static const campaignDetail = '/work/campaigns/:id';
  static const dailyReport = '/work/daily-report';
  static const meetings = '/work/meetings';
  static const newMeeting = '/work/meetings/new';

  static const news = '/news';
  static const newsPreferences = '/news/preferences';

  static const community = '/community';
  static const channel = '/community/:channelId';
  static const thread = '/community/:channelId/:threadId';
  static const createThread = '/community/:channelId/new';

  static const profile = '/profile';
  static const editProfile = '/profile/edit';

  static const admin = '/admin';
  static const adminUsers = '/admin/users';
  static const adminActivation = '/admin/activation';
  static const adminReports = '/admin/reports';
}
