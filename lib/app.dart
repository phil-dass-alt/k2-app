import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'models/user_model.dart';

// Auth screens
import 'features/auth/login_screen.dart';
import 'features/auth/phone_login_screen.dart';
import 'features/auth/email_login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/pending_activation_screen.dart';

// Main screens
import 'features/dashboard/dashboard_screen.dart';
import 'features/clients/clients_list_screen.dart';
import 'features/clients/client_detail_screen.dart';
import 'features/work/work_screen.dart';
import 'features/work/tasks/task_form_screen.dart';
import 'features/work/campaigns/campaign_detail_screen.dart';
import 'features/work/daily_report/daily_report_screen.dart';
import 'features/work/meetings/meeting_form_screen.dart';
import 'features/news/news_screen.dart';
import 'features/news/news_preferences_screen.dart';
import 'features/community/community_screen.dart';
import 'features/community/channel_screen.dart';
import 'features/community/thread_screen.dart';
import 'features/community/create_thread_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/profile/edit_profile_screen.dart';
import 'features/admin/admin_dashboard_screen.dart';
import 'features/admin/user_management_screen.dart';
import 'features/admin/activation_screen.dart';
import 'features/admin/reports_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      final user = authState.user;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register') ||
          state.matchedLocation == '/pending-activation';

      if (user == null) {
        // Not logged in: redirect to login unless already on auth route
        if (!isAuthRoute) return '/login';
        return null;
      }

      if (user.status == UserStatus.pending) {
        // Pending activation
        if (state.matchedLocation != '/pending-activation') {
          return '/pending-activation';
        }
        return null;
      }

      // Logged in and active: redirect away from auth routes
      if (isAuthRoute) return '/dashboard';
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'phone',
            builder: (_, __) => const PhoneLoginScreen(),
          ),
          GoRoute(
            path: 'email',
            builder: (_, __) => const EmailLoginScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/pending-activation',
        builder: (_, __) => const PendingActivationScreen(),
      ),

      // Shell route with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithBottomNav(child: child, location: state.matchedLocation);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (_, __) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/clients',
            builder: (_, __) => const ClientsListScreen(),
          ),
          GoRoute(
            path: '/work',
            builder: (_, __) => const WorkScreen(),
          ),
          GoRoute(
            path: '/news',
            builder: (_, __) => const NewsScreen(),
          ),
          GoRoute(
            path: '/community',
            builder: (_, __) => const CommunityScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
      ),

      // Deep routes outside shell
      GoRoute(
        path: '/clients/:id',
        builder: (_, state) =>
            ClientDetailScreen(clientId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/work/tasks/new',
        builder: (_, __) => const TaskFormScreen(),
      ),
      GoRoute(
        path: '/work/campaigns/:id',
        builder: (_, state) =>
            CampaignDetailScreen(campaignId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/work/daily-report',
        builder: (_, __) => const DailyReportScreen(),
      ),
      GoRoute(
        path: '/work/meetings/new',
        builder: (_, __) => const MeetingFormScreen(),
      ),
      GoRoute(
        path: '/news/preferences',
        builder: (_, __) => const NewsPreferencesScreen(),
      ),
      GoRoute(
        path: '/community/:channelId',
        builder: (_, state) =>
            ChannelScreen(channelId: state.pathParameters['channelId']!),
        routes: [
          GoRoute(
            path: 'new',
            builder: (_, state) => CreateThreadScreen(
                channelId: state.pathParameters['channelId']!),
          ),
          GoRoute(
            path: ':threadId',
            builder: (_, state) => ThreadScreen(
              channelId: state.pathParameters['channelId']!,
              threadId: state.pathParameters['threadId']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (_, __) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (_, __) => const AdminDashboardScreen(),
        routes: [
          GoRoute(
            path: 'users',
            builder: (_, __) => const UserManagementScreen(),
          ),
          GoRoute(
            path: 'activation',
            builder: (_, __) => const ActivationScreen(),
          ),
          GoRoute(
            path: 'reports',
            builder: (_, __) => const ReportsScreen(),
          ),
        ],
      ),
    ],
  );
});

class K2App extends ConsumerWidget {
  const K2App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'K2 Communications',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('kn'),
        Locale('mr'),
        Locale('ta'),
        Locale('te'),
        Locale('bn'),
      ],
    );
  }
}

class ScaffoldWithBottomNav extends ConsumerWidget {
  final Widget child;
  final String location;

  const ScaffoldWithBottomNav({
    super.key,
    required this.child,
    required this.location,
  });

  int _selectedIndex(String location) {
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/clients')) return 1;
    if (location.startsWith('/work')) return 2;
    if (location.startsWith('/news')) return 3;
    if (location.startsWith('/community')) return 4;
    if (location.startsWith('/profile')) return 5;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/clients');
        break;
      case 2:
        context.go('/work');
        break;
      case 3:
        context.go('/news');
        break;
      case 4:
        context.go('/community');
        break;
      case 5:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isAdmin = authState.user?.role == UserRole.admin;
    final selectedIndex = _selectedIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (i) => _onTap(context, i),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.business_outlined),
            activeIcon: Icon(Icons.business),
            label: 'Clients',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'Work',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            activeIcon: Icon(Icons.newspaper),
            label: 'News',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            activeIcon: Icon(Icons.forum),
            label: 'Community',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.small(
              onPressed: () => context.push('/admin'),
              backgroundColor: const Color(0xFF1A2B4A),
              child: const Icon(Icons.admin_panel_settings,
                  color: Colors.white, size: 18),
            )
          : null,
    );
  }
}
