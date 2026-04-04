import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../di/injection.dart';
import '../../domain/entities/kyc_status.dart';
import '../bloc/kyc_bloc.dart';

/// KYC document upload screen.
///
/// If the user has already submitted KYC, shows their current status.
/// Otherwise, shows the upload form with document type selection,
/// image picker, and upload button with progress.
class KycUploadScreen extends StatelessWidget {
  const KycUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<KycBloc>()..add(const KycStatusRequested()),
      child: const _KycUploadView(),
    );
  }
}

class _KycUploadView extends StatelessWidget {
  const _KycUploadView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KYC Verification'),
      ),
      body: BlocConsumer<KycBloc, KycState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.statusRejected,
                  behavior: SnackBarBehavior.floating,
                ),
              );
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: AppColors.statusPublished,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 4),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.isLoadingStatus) {
            return const Center(child: CircularProgressIndicator());
          }

          // If already submitted (pending or approved), show status view.
          if (state.hasSubmitted) {
            return _KycStatusView(status: state.verificationStatus);
          }

          // Show upload form for 'none' or 'rejected' status.
          return _KycUploadForm(state: state);
        },
      ),
    );
  }
}

/// Shows the current KYC verification status when already submitted.
class _KycStatusView extends StatelessWidget {
  final KycVerificationStatus status;

  const _KycStatusView({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final IconData icon;
    final Color color;
    final String title;
    final String subtitle;

    switch (status) {
      case KycVerificationStatus.pending:
        icon = Icons.hourglass_top;
        color = AppColors.statusInProgress;
        title = 'Verification Pending';
        subtitle =
            'Your documents are being reviewed. This usually takes 1-2 '
            'business days. We will notify you once the review is complete.';
      case KycVerificationStatus.approved:
        icon = Icons.verified;
        color = AppColors.statusPublished;
        title = 'Verified';
        subtitle =
            'Your identity has been verified. You are now an HT Approved '
            'Creator with access to additional features.';
      default:
        icon = Icons.help_outline;
        color = AppColors.mediumGrey;
        title = 'Unknown Status';
        subtitle = 'Please try again later.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 64),
            ),
            const SizedBox(height: 24),
            Semantics(
              header: true,
              child: Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.mediumGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Semantics(
              button: true,
              label: 'Refresh verification status',
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<KycBloc>().add(const KycStatusRequested());
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Status'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The upload form with document type selector, image picker, and upload button.
class _KycUploadForm extends StatelessWidget {
  final KycState state;

  const _KycUploadForm({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Status banner for rejected ─────────────────────────────
          if (state.verificationStatus == KycVerificationStatus.rejected)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.statusRejectedBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.statusRejected),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.statusRejected,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your previous submission was rejected. Please '
                      'upload a clearer document image.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.statusRejected,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ── Instructions ──────────────────────────────────────────
          Semantics(
            header: true,
            child: Text(
              'Verify Your Identity',
              style: theme.textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'To become an HT Approved Creator, please upload a valid '
            'government-issued ID document.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.mediumGrey,
            ),
          ),
          const SizedBox(height: 24),

          // ── Document type selector ────────────────────────────────
          Semantics(
            label: 'Select document type',
            child: Text(
              'Document Type',
              style: theme.textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: 8),
          _DocumentTypeSelector(
            selectedType: state.selectedDocumentType,
            onChanged: (type) {
              context.read<KycBloc>().add(KycDocumentTypeChanged(type));
            },
          ),
          const SizedBox(height: 24),

          // ── Image picker area ─────────────────────────────────────
          Semantics(
            label: 'Document photo',
            child: Text(
              'Document Photo',
              style: theme.textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: 8),
          _ImagePickerArea(
            filePath: state.pickedFilePath,
            isUploading: state.isUploading,
          ),
          const SizedBox(height: 24),

          // ── Upload progress ───────────────────────────────────────
          if (state.isUploading) ...[
            Semantics(
              label:
                  'Uploading document, ${(state.uploadProgress * 100).toInt()} percent complete',
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: state.uploadProgress > 0
                        ? state.uploadProgress
                        : null,
                    backgroundColor: AppColors.extraLightGrey,
                    color: AppColors.primaryRed,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.uploadProgress > 0
                        ? 'Uploading... ${(state.uploadProgress * 100).toInt()}%'
                        : 'Uploading...',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── Upload button ─────────────────────────────────────────
          Semantics(
            button: true,
            label: 'Upload document for verification',
            child: ElevatedButton.icon(
              onPressed: state.isUploading || state.pickedFilePath == null
                  ? null
                  : () {
                      context
                          .read<KycBloc>()
                          .add(const KycUploadRequested());
                    },
              icon: state.isUploading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Icon(Icons.cloud_upload_outlined),
              label: Text(
                state.isUploading ? 'Uploading...' : 'Upload Document',
              ),
            ),
          ),
          const SizedBox(height: 32),

          // ── Guidelines ────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 20,
                        color: AppColors.statusUnderReview,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Guidelines',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.statusUnderReview,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _guidelineItem(theme, 'Ensure the document is clearly visible'),
                  _guidelineItem(theme, 'All four corners should be in frame'),
                  _guidelineItem(theme, 'No glare or blur on the document'),
                  _guidelineItem(theme, 'Name on document must match your profile'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _guidelineItem(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline,
              size: 16, color: AppColors.statusPublished),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

/// Grid of document type chips.
class _DocumentTypeSelector extends StatelessWidget {
  final KycDocumentType selectedType;
  final ValueChanged<KycDocumentType> onChanged;

  const _DocumentTypeSelector({
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: KycDocumentType.values.map((type) {
        final isSelected = type == selectedType;
        return Semantics(
          selected: isSelected,
          label: type.displayName,
          child: ChoiceChip(
            label: Text(type.displayName),
            selected: isSelected,
            onSelected: (_) => onChanged(type),
            selectedColor: AppColors.primaryRedLight,
            avatar: isSelected
                ? const Icon(Icons.check, size: 18, color: AppColors.primaryRed)
                : null,
          ),
        );
      }).toList(),
    );
  }
}

/// Tappable area for picking or displaying a document image.
class _ImagePickerArea extends StatelessWidget {
  final String? filePath;
  final bool isUploading;

  const _ImagePickerArea({
    required this.filePath,
    required this.isUploading,
  });

  Future<void> _pickImage(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null || !context.mounted) return;

    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (xFile != null && context.mounted) {
      context.read<KycBloc>().add(KycImagePicked(xFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: filePath == null,
      label: filePath == null
          ? 'Tap to select a document photo'
          : 'Document photo selected. Tap to change.',
      child: GestureDetector(
        onTap: isUploading ? null : () => _pickImage(context),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.extraLightGrey,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: filePath != null
                  ? AppColors.primaryRed
                  : AppColors.lightGrey,
              width: filePath != null ? 2 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: filePath != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(filePath!),
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: AppColors.black.withValues(alpha: 0.6),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Photo selected. Tap to change.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_a_photo_outlined,
                      size: 48,
                      color: AppColors.mediumGrey,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tap to select document photo',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.mediumGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Camera or Gallery',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
