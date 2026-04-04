import 'package:flutter/material.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../di/injection.dart';
import '../../domain/repositories/community_repository.dart';

/// Bottom sheet for reporting a creator or story.
///
/// Shows reason categories, optional details field, and submit button.
class ReportBottomSheet extends StatefulWidget {
  final String targetType; // 'creator' or 'story'
  final String targetId;
  final CommunityRepository _repository;

  const ReportBottomSheet({
    super.key,
    required this.targetType,
    required this.targetId,
    required CommunityRepository repository,
  }) : _repository = repository;

  /// Show the report bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required String targetType,
    required String targetId,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ReportBottomSheet(
        targetType: targetType,
        targetId: targetId,
        repository: sl<CommunityRepository>(),
      ),
    );
  }

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  static const _reasons = <String, String>{
    'misinformation': 'Misinformation',
    'hate_speech': 'Hate Speech',
    'spam': 'Spam',
    'harassment': 'Harassment',
    'other': 'Other',
  };

  String? _selectedReason;
  final _detailsController = TextEditingController();
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedReason == null || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      await widget._repository.report(
        targetType: widget.targetType,
        targetId: widget.targetId,
        reason: _selectedReason!,
        details: _detailsController.text.trim().isNotEmpty
            ? _detailsController.text.trim()
            : null,
      );
      if (mounted) {
        setState(() {
          _isSubmitted = true;
          _isSubmitting = false;
        });
      }
    } on ServerException catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit report.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: _isSubmitted ? _buildSuccessView(theme) : _buildForm(theme),
    );
  }

  Widget _buildSuccessView(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        _handleBar(),
        const SizedBox(height: 24),
        const Icon(
          Icons.check_circle_outline,
          size: 64,
          color: AppColors.statusPublished,
        ),
        const SizedBox(height: 16),
        Text(
          'Report Submitted',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Report submitted. Our team will review it.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.mediumGrey,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(ThemeData theme) {
    final entityLabel =
        widget.targetType == 'creator' ? 'Creator' : 'Story';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Handle bar
        _handleBar(),
        const SizedBox(height: 12),

        // Title
        Text(
          'Report $entityLabel',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Select a reason for your report.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.mediumGrey,
          ),
        ),
        const SizedBox(height: 16),

        // Reason categories
        RadioGroup<String>(
          groupValue: _selectedReason ?? '',
          onChanged: (val) => setState(() => _selectedReason = val),
          child: Column(
            children: _reasons.entries.map((entry) {
              return RadioListTile<String>(
                title: Text(entry.value),
                value: entry.key,
                dense: true,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primaryRed,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        // Optional details
        TextField(
          controller: _detailsController,
          maxLines: 3,
          maxLength: 500,
          decoration: const InputDecoration(
            labelText: 'Additional details (optional)',
            hintText: 'Provide more context...',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 16),

        // Submit button
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _selectedReason != null && !_isSubmitting
                ? _submit
                : null,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: AppColors.white,
              minimumSize: const Size(0, 48),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : const Text('Submit Report'),
          ),
        ),
      ],
    );
  }

  Widget _handleBar() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
