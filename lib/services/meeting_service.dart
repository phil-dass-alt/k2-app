import '../models/meeting_model.dart';

class MeetingService {
  static final List<MeetingModel> _mockMeetings = [
    MeetingModel(
      id: 'meet-001',
      title: 'HDFC Campaign Review',
      description: 'Review Q4 digital banking campaign progress and align on next steps.',
      dateTime: DateTime.now().add(const Duration(hours: 2)),
      location: 'Conference Room A / Google Meet',
      attendees: ['emp-001', 'emp-002', 'admin-001'],
      clientId: 'client-002',
      reminderMinutes: 30,
      isCompleted: false,
      createdBy: 'emp-001',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    MeetingModel(
      id: 'meet-002',
      title: 'Weekly Team Sync',
      description: 'Regular weekly team standup and updates.',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
      location: 'Main Meeting Room',
      attendees: ['admin-001', 'emp-001', 'emp-002', 'emp-003', 'emp-004'],
      reminderMinutes: 15,
      isCompleted: false,
      createdBy: 'admin-001',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    MeetingModel(
      id: 'meet-003',
      title: 'Infosys Onboarding Call',
      description: 'Initial discovery and onboarding call with new Infosys stakeholders.',
      dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      location: 'Zoom',
      attendees: ['emp-001', 'admin-001'],
      clientId: 'client-001',
      reminderMinutes: 30,
      isCompleted: true,
      createdBy: 'emp-001',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    MeetingModel(
      id: 'meet-004',
      title: 'Bajaj Insurance Strategy',
      description: 'Deep-dive strategy session for insurance awareness campaign.',
      dateTime: DateTime.now().add(const Duration(days: 3)),
      location: 'Client Office - Pune',
      attendees: ['emp-003', 'admin-001'],
      clientId: 'client-004',
      reminderMinutes: 60,
      isCompleted: false,
      createdBy: 'emp-003',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  Future<List<MeetingModel>> getMeetings({String? userId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (userId != null) {
      return _mockMeetings
          .where((m) => m.attendees.contains(userId) || m.createdBy == userId)
          .toList();
    }
    return List.from(_mockMeetings);
  }

  Future<MeetingModel?> getMeeting(String meetingId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockMeetings.firstWhere((m) => m.id == meetingId);
    } catch (_) {
      return null;
    }
  }

  Future<MeetingModel> createMeeting(MeetingModel meeting) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockMeetings.add(meeting);
    return meeting;
  }

  Future<MeetingModel> updateMeeting(MeetingModel meeting) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _mockMeetings.indexWhere((m) => m.id == meeting.id);
    if (idx != -1) {
      _mockMeetings[idx] = meeting;
    }
    return meeting;
  }
}

final meetingService = MeetingService();
