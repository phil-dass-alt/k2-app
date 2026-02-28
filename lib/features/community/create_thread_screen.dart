import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/utils/validators.dart';
import '../../providers/forum_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/forum_thread_model.dart';
import 'package:uuid/uuid.dart';

class CreateThreadScreen extends ConsumerStatefulWidget {
  final String channelId;

  const CreateThreadScreen({super.key, required this.channelId});

  @override
  ConsumerState<CreateThreadScreen> createState() => _CreateThreadScreenState();
}

class _CreateThreadScreenState extends ConsumerState<CreateThreadScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authProvider).user;
    if (user == null) return;

    setState(() => _isLoading = true);

    final thread = ForumThreadModel(
      id: const Uuid().v4(),
      channelId: widget.channelId,
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      authorId: user.id,
      authorName: user.name,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success =
        await ref.read(forumProvider.notifier).createThread(thread);
    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Post')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _titleController,
                label: 'Title',
                hint: 'Give your post a title',
                validator: (v) => AppValidators.minLength(v, 5, 'Title'),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _bodyController,
                label: 'Body',
                hint: 'Write your post...',
                maxLines: 8,
                validator: (v) => AppValidators.minLength(v, 10, 'Body'),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Post',
                isLoading: _isLoading,
                onPressed: _submit,
                icon: Icons.send,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
