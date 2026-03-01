import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../services/campaign_service.dart';
import '../../../models/campaign_model.dart';
import '../../../services/client_service.dart';
import '../../../models/client_model.dart';
import '../../../core/utils/app_date_utils.dart';

class CampaignsScreen extends ConsumerWidget {
  final bool embedded;

  const CampaignsScreen({super.key, this.embedded = false});

  Color _statusColor(CampaignStatus s) {
    switch (s) {
      case CampaignStatus.planning:
        return AppColors.warning;
      case CampaignStatus.active:
        return AppColors.success;
      case CampaignStatus.paused:
        return AppColors.textLight;
      case CampaignStatus.completed:
        return AppColors.primary;
    }
  }

  String _statusLabel(CampaignStatus s) => s.name[0].toUpperCase() + s.name.substring(1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget body = FutureBuilder<List<CampaignModel>>(
      future: campaignService.getCampaigns(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final campaigns = snap.data ?? [];

        return FutureBuilder<List<ClientModel>>(
          future: clientService.getClients(),
          builder: (context, clientSnap) {
            final clients = {
              for (final c in (clientSnap.data ?? [])) c.id: c
            };

            if (campaigns.isEmpty) {
              return const Center(
                child: Text('No campaigns found',
                    style: TextStyle(color: AppColors.textLight)),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: campaigns.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final c = campaigns[i];
                final client = clients[c.clientId];
                final done = c.milestones.where((m) => m.isCompleted).length;
                final total = c.milestones.length;
                final progress = total > 0 ? done / total : 0.0;

                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                if (client != null)
                                  Text(
                                    client.name,
                                    style: const TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 13,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _statusColor(c.status).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _statusLabel(c.status),
                              style: TextStyle(
                                color: _statusColor(c.status),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (total > 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress: $done/$total milestones',
                              style: const TextStyle(
                                color: AppColors.textLight,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.divider,
                            color: AppColors.primary,
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      Row(
                        children: [
                          const Icon(Icons.date_range,
                              size: 13, color: AppColors.textLight),
                          const SizedBox(width: 4),
                          Text(
                            '${AppDateUtils.formatShortDate(c.startDate)} – '
                            '${c.endDate != null ? AppDateUtils.formatShortDate(c.endDate!) : 'Ongoing'}',
                            style: const TextStyle(
                              color: AppColors.textLight,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );

    if (embedded) return body;

    return Scaffold(
      appBar: AppBar(title: const Text('Campaigns')),
      body: body,
    );
  }
}
