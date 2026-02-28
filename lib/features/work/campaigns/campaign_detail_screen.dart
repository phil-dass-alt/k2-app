import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../services/campaign_service.dart';
import '../../../models/campaign_model.dart';
import '../../../core/utils/app_date_utils.dart';

class CampaignDetailScreen extends ConsumerWidget {
  final String campaignId;

  const CampaignDetailScreen({super.key, required this.campaignId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<CampaignModel?>(
      future: campaignService.getCampaign(campaignId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final campaign = snap.data;
        if (campaign == null) {
          return const Scaffold(body: Center(child: Text('Campaign not found')));
        }

        final done =
            campaign.milestones.where((m) => m.isCompleted).length;
        final total = campaign.milestones.length;
        final progress = total > 0 ? done / total : 0.0;

        return Scaffold(
          appBar: AppBar(title: Text(campaign.title)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Status',
                              style: TextStyle(color: AppColors.textLight)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              campaign.status.name.toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.date_range,
                              size: 16, color: AppColors.textLight),
                          const SizedBox(width: 8),
                          Text(
                            '${AppDateUtils.formatDate(campaign.startDate)} – '
                            '${campaign.endDate != null ? AppDateUtils.formatDate(campaign.endDate!) : 'Ongoing'}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      if (total > 0) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Progress: $done/$total milestones (${(progress * 100).toInt()}%)',
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.divider,
                            color: AppColors.primary,
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Milestones',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                AppCard(
                  child: Column(
                    children: campaign.milestones
                        .asMap()
                        .entries
                        .map((entry) {
                          final idx = entry.key;
                          final m = entry.value;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    m.isCompleted
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: m.isCompleted
                                        ? AppColors.success
                                        : AppColors.textLight,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    m.title,
                                    style: TextStyle(
                                      decoration: m.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: m.isCompleted
                                          ? AppColors.textLight
                                          : AppColors.text,
                                    ),
                                  ),
                                ],
                              ),
                              if (idx < campaign.milestones.length - 1)
                                const Divider(height: 16),
                            ],
                          );
                        })
                        .toList(),
                  ),
                ),
                if (campaign.notes != null &&
                    campaign.notes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppCard(
                    child: Text(
                      campaign.notes!,
                      style: const TextStyle(
                        color: AppColors.textLight,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
