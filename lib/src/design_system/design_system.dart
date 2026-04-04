import 'package:flutter/material.dart';

import 'design_system_scope.dart';

/// Immutable design token set for the Mai Bhi Editor SDK.
///
/// Contains all visual tokens: colors, spacing, radii, and font families.
/// Access via `DesignSystem.of(context)` inside any widget wrapped by
/// [DesignSystemScope].
///
/// The host app can provide a custom instance at initialization, or the
/// SDK falls back to [kDefaultDesignSystem].
class DesignSystem {
  // ── Brand colors ──────────────────────────────────────────────────────
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color secondary;
  final Color secondaryDark;
  final Color secondaryLight;

  // ── Neutrals ──────────────────────────────────────────────────────────
  final Color black;
  final Color darkGrey;
  final Color mediumGrey;
  final Color lightGrey;
  final Color extraLightGrey;
  final Color white;

  // ── Semantic / status colors ──────────────────────────────────────────
  final Color statusDraft;
  final Color statusInProgress;
  final Color statusUnderReview;
  final Color statusPublished;
  final Color statusRejected;

  // ── Tinted chip backgrounds ───────────────────────────────────────────
  final Color statusDraftBg;
  final Color statusInProgressBg;
  final Color statusUnderReviewBg;
  final Color statusPublishedBg;
  final Color statusRejectedBg;

  // ── Surface / scaffold ────────────────────────────────────────────────
  final Color scaffoldLight;
  final Color scaffoldDark;
  final Color surfaceDark;

  // ── AI Confidence score colours ───────────────────────────────────────
  final Color confidenceHigh;
  final Color confidenceHighBg;
  final Color confidenceMedium;
  final Color confidenceMediumBg;
  final Color confidenceLow;
  final Color confidenceLowBg;

  // ── Action button colours ─────────────────────────────────────────────
  final Color actionApprove;
  final Color actionEdit;
  final Color actionReject;
  final Color actionCorrection;

  // ── Safety ────────────────────────────────────────────────────────────
  final Color safetyGood;
  final Color safetyWarning;
  final Color safetyDanger;

  // ── Badge tiers ───────────────────────────────────────────────────────
  final Color badgeBronze;
  final Color badgeBronzeBg;
  final Color badgeSilver;
  final Color badgeSilverBg;
  final Color badgeGold;
  final Color badgeGoldBg;
  final Color badgePurple;
  final Color badgePurpleBg;

  // ── Misc ──────────────────────────────────────────────────────────────
  final Color divider;
  final Color shadow;
  final Color unreadDot;
  final Color diffHighlight;
  final Color link;

  // ── Spacing tokens ────────────────────────────────────────────────────
  final double spacingXxs;
  final double spacingXs;
  final double spacingSm;
  final double spacingMd;
  final double spacingLg;
  final double spacingXl;
  final double spacingXxl;
  final double spacingXxxl;

  // ── Border radius tokens ──────────────────────────────────────────────
  final double radiusXs;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double radiusXl;
  final double radiusFull;

  // ── Typography ────────────────────────────────────────────────────────
  final String headingFontFamily;
  final String bodyFontFamily;

  const DesignSystem({
    // Brand
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.secondary,
    required this.secondaryDark,
    required this.secondaryLight,
    // Neutrals
    required this.black,
    required this.darkGrey,
    required this.mediumGrey,
    required this.lightGrey,
    required this.extraLightGrey,
    required this.white,
    // Status
    required this.statusDraft,
    required this.statusInProgress,
    required this.statusUnderReview,
    required this.statusPublished,
    required this.statusRejected,
    // Status backgrounds
    required this.statusDraftBg,
    required this.statusInProgressBg,
    required this.statusUnderReviewBg,
    required this.statusPublishedBg,
    required this.statusRejectedBg,
    // Surface / scaffold
    required this.scaffoldLight,
    required this.scaffoldDark,
    required this.surfaceDark,
    // Confidence
    required this.confidenceHigh,
    required this.confidenceHighBg,
    required this.confidenceMedium,
    required this.confidenceMediumBg,
    required this.confidenceLow,
    required this.confidenceLowBg,
    // Actions
    required this.actionApprove,
    required this.actionEdit,
    required this.actionReject,
    required this.actionCorrection,
    // Safety
    required this.safetyGood,
    required this.safetyWarning,
    required this.safetyDanger,
    // Badges
    required this.badgeBronze,
    required this.badgeBronzeBg,
    required this.badgeSilver,
    required this.badgeSilverBg,
    required this.badgeGold,
    required this.badgeGoldBg,
    required this.badgePurple,
    required this.badgePurpleBg,
    // Misc
    required this.divider,
    required this.shadow,
    required this.unreadDot,
    required this.diffHighlight,
    required this.link,
    // Spacing
    this.spacingXxs = 2.0,
    this.spacingXs = 4.0,
    this.spacingSm = 8.0,
    this.spacingMd = 12.0,
    this.spacingLg = 16.0,
    this.spacingXl = 24.0,
    this.spacingXxl = 32.0,
    this.spacingXxxl = 48.0,
    // Radii
    this.radiusXs = 2.0,
    this.radiusSm = 4.0,
    this.radiusMd = 8.0,
    this.radiusLg = 12.0,
    this.radiusXl = 16.0,
    this.radiusFull = 20.0,
    // Typography
    this.headingFontFamily = 'Inter',
    this.bodyFontFamily = 'Roboto',
  });

  /// Access the design system from the widget tree.
  static DesignSystem of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<DesignSystemScope>();
    assert(scope != null,
        'No DesignSystemScope found. Wrap your app with MaiBhiEditor.wrap().');
    return scope!.designSystem;
  }

  // ── Convenience helpers ───────────────────────────────────────────────

  Color statusColor(String status) {
    switch (status) {
      case 'draft':
        return statusDraft;
      case 'in_progress':
        return statusInProgress;
      case 'under_review':
        return statusUnderReview;
      case 'published':
        return statusPublished;
      case 'rejected':
        return statusRejected;
      default:
        return mediumGrey;
    }
  }

  Color statusBackgroundColor(String status) {
    switch (status) {
      case 'draft':
        return statusDraftBg;
      case 'in_progress':
        return statusInProgressBg;
      case 'under_review':
        return statusUnderReviewBg;
      case 'published':
        return statusPublishedBg;
      case 'rejected':
        return statusRejectedBg;
      default:
        return extraLightGrey;
    }
  }

  Color confidenceColor(double score) {
    if (score >= 0.7) return confidenceHigh;
    if (score >= 0.4) return confidenceMedium;
    return confidenceLow;
  }

  Color confidenceBackgroundColor(double score) {
    if (score >= 0.7) return confidenceHighBg;
    if (score >= 0.4) return confidenceMediumBg;
    return confidenceLowBg;
  }
}
