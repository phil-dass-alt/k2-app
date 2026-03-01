import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../work/tasks/tasks_screen.dart';
import '../work/campaigns/campaigns_screen.dart';
import '../work/daily_report/daily_report_screen.dart';
import '../work/meetings/meetings_screen.dart';

class WorkScreen extends ConsumerStatefulWidget {
  const WorkScreen({super.key});

  @override
  ConsumerState<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends ConsumerState<WorkScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: AppColors.accent,
          tabs: const [
            Tab(text: 'Tasks'),
            Tab(text: 'Campaigns'),
            Tab(text: 'Report'),
            Tab(text: 'Meetings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TasksScreen(embedded: true, onNewTask: () => context.push('/work/tasks/new')),
          CampaignsScreen(embedded: true),
          DailyReportScreen(embedded: true),
          MeetingsScreen(embedded: true, onNewMeeting: () => context.push('/work/meetings/new')),
        ],
      ),
    );
  }
}
