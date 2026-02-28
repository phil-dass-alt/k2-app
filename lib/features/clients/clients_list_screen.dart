import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../services/client_service.dart';
import '../../models/client_model.dart';

final _clientsProvider = FutureProvider<List<ClientModel>>((ref) async {
  return clientService.getClients();
});

class ClientsListScreen extends ConsumerStatefulWidget {
  const ClientsListScreen({super.key});

  @override
  ConsumerState<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends ConsumerState<ClientsListScreen> {
  String _search = '';
  ClientStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(_clientsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Clients')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search clients...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _filterStatus == null,
                  onSelected: (_) => setState(() => _filterStatus = null),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Active',
                  selected: _filterStatus == ClientStatus.active,
                  onSelected: (_) =>
                      setState(() => _filterStatus = ClientStatus.active),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Inactive',
                  selected: _filterStatus == ClientStatus.inactive,
                  onSelected: (_) =>
                      setState(() => _filterStatus = ClientStatus.inactive),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Prospect',
                  selected: _filterStatus == ClientStatus.prospect,
                  onSelected: (_) =>
                      setState(() => _filterStatus = ClientStatus.prospect),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: clientsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (clients) {
                var filtered = clients;
                if (_filterStatus != null) {
                  filtered = filtered
                      .where((c) => c.status == _filterStatus)
                      .toList();
                }
                if (_search.isNotEmpty) {
                  filtered = filtered
                      .where((c) =>
                          c.name
                              .toLowerCase()
                              .contains(_search.toLowerCase()) ||
                          c.industry
                              .toLowerCase()
                              .contains(_search.toLowerCase()))
                      .toList();
                }
                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      'No clients found',
                      style: TextStyle(color: AppColors.textLight),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final client = filtered[i];
                    return AppCard(
                      onTap: () =>
                          context.push('/clients/${client.id}'),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                client.name.substring(0, 1),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  client.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  client.industry,
                                  style: const TextStyle(
                                    color: AppColors.textLight,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  client.contactName,
                                  style: const TextStyle(
                                    color: AppColors.textLight,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _StatusBadge(client.status),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: AppColors.primary.withOpacity(0.15),
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : AppColors.text,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ClientStatus status;

  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case ClientStatus.active:
        color = AppColors.success;
        label = 'Active';
        break;
      case ClientStatus.inactive:
        color = AppColors.error;
        label = 'Inactive';
        break;
      case ClientStatus.prospect:
        color = AppColors.warning;
        label = 'Prospect';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
