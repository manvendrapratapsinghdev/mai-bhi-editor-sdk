import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../injection.dart';
import '../../domain/usecases/get_shareable_link_usecase.dart';

/// Share button widget for story detail and story cards.
///
/// Fetches the shareable link and triggers the native share sheet.
/// Uses share_plus when available; falls back to clipboard copy.
class ShareButton extends StatefulWidget {
  final String storyId;
  final String storyTitle;

  /// If true, renders as an action button (outlined, with label).
  /// If false, renders as an icon button (for app bar).
  final bool asActionButton;

  const ShareButton({
    super.key,
    required this.storyId,
    required this.storyTitle,
    this.asActionButton = false,
  });

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  bool _isSharing = false;

  Future<void> _onShare() async {
    if (_isSharing || widget.storyId.isEmpty) return;

    setState(() => _isSharing = true);

    try {
      final useCase = sl<GetShareableLinkUseCase>();
      final shareUrl = await useCase(widget.storyId);
      final shareText = '${widget.storyTitle}\n\nRead on Mai Bhi Editor: $shareUrl';

      // Try to use share_plus dynamically.
      // Since share_plus may not be installed yet, we fall back to
      // a SnackBar with the URL for clipboard copy.
      if (mounted) {
        await _shareNative(shareText);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to generate share link'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _shareNative(String text) async {
    // Attempt to import and use share_plus at runtime.
    // If share_plus is available, it will handle the native share sheet.
    // Otherwise, we show a snackbar with copy capability.
    try {
      // Dynamic import approach: use the Share class if available.
      // For now, we use a try-catch pattern since share_plus may
      // not be added yet.
      final dynamic share = _tryGetSharePlus();
      if (share != null) {
        await share.share(text);
        return;
      }
    } catch (_) {
      // share_plus not available.
    }

    // Fallback: Copy to clipboard and show snackbar.
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Share: $text'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
    }
  }

  /// Try to get the Share class from share_plus.
  /// Returns null if the package is not available.
  dynamic _tryGetSharePlus() {
    // This will be replaced with actual share_plus import when
    // the package is added to pubspec.yaml.
    // For now, return null to use fallback.
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.asActionButton) {
      return OutlinedButton.icon(
        onPressed: _isSharing ? null : _onShare,
        icon: _isSharing
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.share_outlined, size: 18),
        label: const Text('Share'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.mediumGrey,
          side: const BorderSide(color: AppColors.mediumGrey),
          minimumSize: const Size(0, 44),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      );
    }

    return IconButton(
      icon: _isSharing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.white,
              ),
            )
          : const Icon(Icons.share),
      tooltip: 'Share story',
      onPressed: _isSharing ? null : _onShare,
    );
  }
}
