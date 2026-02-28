import '../models/campaign_model.dart';

class CampaignService {
  static final List<CampaignModel> _mockCampaigns = [
    CampaignModel(
      id: 'camp-001',
      title: 'HDFC Digital Banking Q4',
      clientId: 'client-002',
      status: CampaignStatus.active,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 60)),
      milestones: [
        const CampaignMilestone(title: 'Strategy Finalized', isCompleted: true),
        const CampaignMilestone(title: 'Creative Assets Ready', isCompleted: true),
        const CampaignMilestone(title: 'Campaign Launch', isCompleted: false),
        const CampaignMilestone(title: 'Mid-campaign Review', isCompleted: false),
        const CampaignMilestone(title: 'Final Report', isCompleted: false),
      ],
      notes: 'Focus on UPI and mobile banking features.',
      createdBy: 'emp-001',
      createdAt: DateTime.now().subtract(const Duration(days: 35)),
    ),
    CampaignModel(
      id: 'camp-002',
      title: 'Infosys Tech Leadership Series',
      clientId: 'client-001',
      status: CampaignStatus.planning,
      startDate: DateTime.now().add(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 90)),
      milestones: [
        const CampaignMilestone(title: 'Topic Identification', isCompleted: true),
        const CampaignMilestone(title: 'Speaker Confirmation', isCompleted: false),
        const CampaignMilestone(title: 'Content Creation', isCompleted: false),
      ],
      createdBy: 'emp-001',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    CampaignModel(
      id: 'camp-003',
      title: 'Reliance Festive Retail Push',
      clientId: 'client-003',
      status: CampaignStatus.completed,
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      endDate: DateTime.now().subtract(const Duration(days: 5)),
      milestones: [
        const CampaignMilestone(title: 'Planning', isCompleted: true),
        const CampaignMilestone(title: 'Execution', isCompleted: true),
        const CampaignMilestone(title: 'Post-campaign Analysis', isCompleted: true),
      ],
      notes: 'Achieved 143% of target engagement.',
      createdBy: 'emp-002',
      createdAt: DateTime.now().subtract(const Duration(days: 65)),
    ),
    CampaignModel(
      id: 'camp-004',
      title: 'Bajaj Insurance Awareness',
      clientId: 'client-004',
      status: CampaignStatus.active,
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 50)),
      milestones: [
        const CampaignMilestone(title: 'Target Audience Research', isCompleted: true),
        const CampaignMilestone(title: 'Ad Creative Design', isCompleted: false),
        const CampaignMilestone(title: 'Media Buy', isCompleted: false),
      ],
      createdBy: 'emp-003',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  Future<List<CampaignModel>> getCampaigns({String? clientId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (clientId != null) {
      return _mockCampaigns.where((c) => c.clientId == clientId).toList();
    }
    return List.from(_mockCampaigns);
  }

  Future<CampaignModel?> getCampaign(String campaignId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockCampaigns.firstWhere((c) => c.id == campaignId);
    } catch (_) {
      return null;
    }
  }

  Future<CampaignModel> createCampaign(CampaignModel campaign) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockCampaigns.add(campaign);
    return campaign;
  }

  Future<CampaignModel> updateCampaign(CampaignModel campaign) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _mockCampaigns.indexWhere((c) => c.id == campaign.id);
    if (idx != -1) {
      _mockCampaigns[idx] = campaign;
    }
    return campaign;
  }
}

final campaignService = CampaignService();
