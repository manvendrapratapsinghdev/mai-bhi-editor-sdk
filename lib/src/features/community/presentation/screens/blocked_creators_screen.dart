import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection.dart';
import '../../domain/entities/creator_profile.dart';
import '../../domain/repositories/community_repository.dart';

/// Screen showing the list of blocked creators.
///
/// Accessible from profile/settings.
/// Each entry shows the creator name and an "Unblock" button.
class BlockedCreatorsScreen extends StatefulWidget {
  const BlockedCreatorsScreen({super.key});

  @override
  State<BlockedCreatorsScreen> createState() => _BlockedCreatorsScreenState();
}

class _BlockedCreatorsScreenState extends State<BlockedCreatorsScreen> {
  List<CreatorProfile>? _blockedCreators;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBlockedCreators();
  }

  Future<void> _loadBlockedCreators() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = sl<CommunityRepository>();
      final creators = await repo.getBlockedCreators();
      if (mounted) {
        setState(() {
          _blockedCreators = creators;
          _isLoading = false;
        });
      }
    } on ServerException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load blocked creators.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _unblock(CreatorProfile creator) async {
    try {
      final repo = sl<CommunityRepository>();
      await repo.blockCreator(creator.id);
      if (mounted) {
        setState(() {
          _blockedCreators?.removeWhere((c) => c.id == creator.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${creator.name} has been unblocked.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to unblock creator.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Creators'),
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.statusRejected,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.mediumGrey,
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: _loadBlockedCreators,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final creators = _blockedCreators ?? [];
    if (creators.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.block,
                size: 64,
                color: AppColors.lightGrey,
              ),
              const SizedBox(height: 16),
              Text(
                'No blocked creators.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.mediumGrey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBlockedCreators,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: creators.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final creator = creators[index];
          return _BlockedCreatorTile(
            creator: creator,
            onUnblock: () => _showUnblockDialog(creator),
          );
        },
      ),
    );
  }

  void _showUnblockDialog(CreatorProfile creator) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Unblock Creator'),
        content: Text(
          'Unblock ${creator.name}? Their stories will appear in your feed again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _unblock(creator);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.statusPublished,
            ),
            child: const Text('Unblock'),
          ),
        ],
      ),
    );
  }
}

class _BlockedCreatorTile extends StatelessWidget {
  final CreatorProfile creator;
  final VoidCallback onUnblock;

  const _BlockedCreatorTile({
    required this.creator,
    required this.onUnblock,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        backgroundColor: AppColors.extraLightGrey,
        backgroundImage: creator.avatarUrl != null
            ? NetworkImage(ApiConstants.resolveImageUrl(creator.avatarUrl!))
            : null,
        child: creator.avatarUrl == null
            ? Text(
                creator.name.isNotEmpty ? creator.name[0].toUpperCase() : '?',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.mediumGrey,
                ),
              )
            : null,
      ),
      title: Text(
        creator.name,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${creator.storiesPublished} stories published',
        style: theme.textTheme.bodySmall,
      ),
      trailing: OutlinedButton(
        onPressed: onUnblock,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.statusRejected,
          side: const BorderSide(color: AppColors.statusRejected),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          minimumSize: Size.zero,
        ),
        child: const Text('Unblock'),
      ),
    );
  }
}
