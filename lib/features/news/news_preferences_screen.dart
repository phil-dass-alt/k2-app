import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/constants/app_constants.dart';

class NewsPreferencesScreen extends ConsumerStatefulWidget {
  const NewsPreferencesScreen({super.key});

  @override
  ConsumerState<NewsPreferencesScreen> createState() =>
      _NewsPreferencesScreenState();
}

class _NewsPreferencesScreenState
    extends ConsumerState<NewsPreferencesScreen> {
  final Set<String> _selectedCategories = {
    'Technology & AI',
    'Company News',
    'Banking & Finance',
  };
  bool _breakingNewsAlert = true;
  bool _dailyDigest = false;
  final _companyController = TextEditingController();
  final List<String> _trackedCompanies = ['Infosys', 'HDFC Bank'];

  @override
  void dispose() {
    _companyController.dispose();
    super.dispose();
  }

  void _addCompany() {
    final company = _companyController.text.trim();
    if (company.isNotEmpty && !_trackedCompanies.contains(company)) {
      setState(() {
        _trackedCompanies.add(company);
        _companyController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Preferences')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Categories',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Select topics you want to follow',
            style: TextStyle(color: AppColors.textLight, fontSize: 13),
          ),
          const SizedBox(height: 12),
          ...AppConstants.newsCategories.where((c) => c != 'All').map(
                (cat) => SwitchListTile(
                  title: Text(cat),
                  value: _selectedCategories.contains(cat),
                  onChanged: (v) {
                    setState(() {
                      if (v) {
                        _selectedCategories.add(cat);
                      } else {
                        _selectedCategories.remove(cat);
                      }
                    });
                  },
                  activeColor: AppColors.primary,
                ),
              ),
          const Divider(height: 32),
          const Text(
            'Notifications',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Breaking News Alert'),
            subtitle: const Text('Get notified for breaking news'),
            value: _breakingNewsAlert,
            onChanged: (v) => setState(() => _breakingNewsAlert = v),
            activeColor: AppColors.primary,
          ),
          SwitchListTile(
            title: const Text('Daily Digest'),
            subtitle: const Text('Morning summary of top stories'),
            value: _dailyDigest,
            onChanged: (v) => setState(() => _dailyDigest = v),
            activeColor: AppColors.primary,
          ),
          const Divider(height: 32),
          const Text(
            'Tracked Companies',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Get news about specific companies',
            style: TextStyle(color: AppColors.textLight, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _companyController,
                  decoration: InputDecoration(
                    hintText: 'Add company name...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onSubmitted: (_) => _addCompany(),
                ),
              ),
              const SizedBox(width: 8),
              AppButton(
                label: 'Add',
                fullWidth: false,
                onPressed: _addCompany,
                variant: AppButtonVariant.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._trackedCompanies.map(
            (company) => ListTile(
              title: Text(company),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () =>
                    setState(() => _trackedCompanies.remove(company)),
              ),
              leading: const Icon(Icons.business, color: AppColors.primary),
              dense: true,
            ),
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Save Preferences',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Preferences saved!')),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
