import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../injection.dart';
import '../../domain/entities/appeal.dart';
import '../bloc/appeal_bloc.dart';

/// Shows the appeal bottom sheet for a rejected submission (S4-08).
///
/// Displays the rejection reason (read-only), a justification text area
/// (required, min 50 chars), and a submit button.
void showAppealBottomSheet({
  required BuildContext context,
  required String submissionId,
  String? rejectionReason,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return BlocProvider(
        create: (_) => sl<AppealBloc>()
          ..add(LoadAppealStatus(submissionId)),
        child: _AppealBottomSheetContent(
          submissionId: submissionId,
          rejectionReason: rejectionReason,
        ),
      );
    },
  );
}

class _AppealBottomSheetContent extends StatefulWidget {
  final String submissionId;
  final String? rejectionReason;

  const _AppealBottomSheetContent({
    required this.submissionId,
    this.rejectionReason,
  });

  @override
  State<_AppealBottomSheetContent> createState() =>
      _AppealBottomSheetContentState();
}

class _AppealBottomSheetContentState
    extends State<_AppealBottomSheetContent> {
  final _justificationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _justificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<AppealBloc, AppealState>(
      listener: (context, state) {
        if (state is AppealSubmitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appeal submitted successfully'),
              backgroundColor: AppColors.statusPublished,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is AppealError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.statusRejected,
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: bottomInset + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar.
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title.
              Text(
                'Appeal Rejection',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              _buildContent(context, state, theme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppealState state,
    ThemeData theme,
  ) {
    // Loading state.
    if (state is AppealLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Appeal already pending.
    if (state is AppealPending) {
      return _buildAppealPendingView(theme, state.appeal);
    }

    // Appeal already reviewed.
    if (state is AppealReviewed) {
      return _buildAppealReviewedView(theme, state.appeal);
    }

    // Submitting.
    if (state is AppealSubmitting) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Submitting appeal...'),
            ],
          ),
        ),
      );
    }

    // No appeal filed yet — show the form.
    return _buildAppealForm(context, theme);
  }

  Widget _buildAppealForm(BuildContext context, ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rejection reason (read-only).
          if (widget.rejectionReason != null &&
              widget.rejectionReason!.isNotEmpty) ...[
            Text(
              'Rejection Reason',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.statusRejected,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.statusRejectedBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.statusRejected.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                widget.rejectionReason!,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Justification text area.
          Text(
            'Your Justification',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: _justificationController,
            decoration: const InputDecoration(
              hintText:
                  'Explain why you believe this rejection was incorrect (minimum 50 characters)...',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Justification is required';
              }
              if (value.trim().length < 50) {
                return 'Justification must be at least 50 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Submit button.
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AppealBloc>().add(
                        SubmitAppealEvent(
                          submissionId: widget.submissionId,
                          justification:
                              _justificationController.text.trim(),
                        ),
                      );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Submit Appeal'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppealPendingView(ThemeData theme, Appeal appeal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.statusInProgressBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.statusInProgress.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              const Icon(Icons.hourglass_top,
                  size: 48, color: AppColors.statusInProgress),
              const SizedBox(height: 12),
              Text(
                'Appeal Pending',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.statusInProgress,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your appeal is being reviewed by an editor.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: null, // Disabled.
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Appeal Pending'),
          ),
        ),
      ],
    );
  }

  Widget _buildAppealReviewedView(ThemeData theme, Appeal appeal) {
    final isApproved = appeal.status == AppealStatus.approved;
    final color =
        isApproved ? AppColors.statusPublished : AppColors.statusRejected;
    final bgColor = isApproved
        ? AppColors.statusPublishedBg
        : AppColors.statusRejectedBg;
    final icon = isApproved ? Icons.check_circle : Icons.cancel;
    final statusText =
        isApproved ? 'Appeal Approved' : 'Appeal Rejected';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                statusText,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (appeal.reviewNotes != null &&
                  appeal.reviewNotes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  appeal.reviewNotes!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
