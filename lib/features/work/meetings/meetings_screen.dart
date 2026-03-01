import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../services/meeting_service.dart';
import '../../../models/meeting_model.dart';
import '../../../core/utils/app_date_utils.dart';

class MeetingsScreen extends ConsumerWidget {
  final bool embedded;
  final VoidCallback? onNewMeeting;

  const MeetingsScreen({super.key, this.embedded = false, this.onNewMeeting});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget body = FutureBuilder<List<MeetingModel>>(
      future: meetingService.getMeetings(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final meetings = snap.data ?? [];
        meetings.sort((a, b) => a.dateTime.compareTo(b.dateTime));

        final upcoming =
            meetings.where((m) => !m.isCompleted).toList();
        final past = meetings.where((m) => m.isCompleted).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (upcoming.isNotEmpty) ...[
              const Text(
                'Upcoming',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.text),
              ),
              const SizedBox(height: 8),
              ...upcoming.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _MeetingCard(meeting: m),
                  )),
              const SizedBox(height: 16),
            ],
            if (past.isNotEmpty) ...[
              const Text(
                'Past',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textLight),
              ),
              const SizedBox(height: 8),
              ...past.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _MeetingCard(meeting: m, isPast: true),
                  )),
            ],
            if (meetings.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No meetings scheduled',
                      style: TextStyle(color: AppColors.textLight)),
                ),
              ),
          ],
        );
      },
    );

    if (embedded) return body;

    return Scaffold(
      appBar: AppBar(title: const Text('Meetings')),
      floatingActionButton: FloatingActionButton(
        onPressed: onNewMeeting,
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: body,
    );
  }
}

class _MeetingCard extends StatelessWidget {
  final MeetingModel meeting;
  final bool isPast;

  const _MeetingCard({required this.meeting, this.isPast = false});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: isPast ? AppColors.surface : AppColors.background,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPast
                  ? AppColors.divider
                  : AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.video_call,
              color: isPast ? AppColors.textLight : AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meeting.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isPast ? AppColors.textLight : AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 13, color: AppColors.textLight),
                    const SizedBox(width: 4),
                    Text(
                      AppDateUtils.formatDateTime(meeting.dateTime),
                      style: const TextStyle(
                          color: AppColors.textLight, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 13, color: AppColors.textLight),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        meeting.location,
                        style: const TextStyle(
                            color: AppColors.textLight, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (meeting.attendees.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${meeting.attendees.length} attendee(s)',
                      style: const TextStyle(
                          color: AppColors.textLight, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          if (isPast)
            const Icon(Icons.check_circle,
                color: AppColors.success, size: 18),
        ],
      ),
    );
  }
}
