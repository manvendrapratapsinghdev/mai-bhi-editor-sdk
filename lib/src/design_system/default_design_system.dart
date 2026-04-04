import 'package:flutter/material.dart';

import 'design_system.dart';

/// The default Hindustan Times-branded design system.
///
/// Used when the host app does not provide a custom [DesignSystem] at
/// initialization. Contains all 130+ design tokens matching the original
/// Mai Bhi Editor app branding.
const kDefaultDesignSystem = DesignSystem(
  // ── Brand (Hindustan Times palette) ──────────────────────────────────
  primary: Color(0xFF005CA9),
  primaryDark: Color(0xFF003D73),
  primaryLight: Color(0xFFE5F0FA),
  secondary: Color(0xFF0D2137),
  secondaryDark: Color(0xFF081525),
  secondaryLight: Color(0xFFE1E8F0),

  // ── Neutrals ─────────────────────────────────────────────────────────
  black: Color(0xFF111111),
  darkGrey: Color(0xFF4D4D4D),
  mediumGrey: Color(0xFF999999),
  lightGrey: Color(0xFFCCCCCC),
  extraLightGrey: Color(0xFFF5F5F5),
  white: Color(0xFFFFFFFF),

  // ── Semantic / status ────────────────────────────────────────────────
  statusDraft: Color(0xFF69727D),
  statusInProgress: Color(0xFFF0AD4E),
  statusUnderReview: Color(0xFF5BC0DE),
  statusPublished: Color(0xFF5CB85C),
  statusRejected: Color(0xFFD9534F),

  // ── Tinted chip backgrounds ──────────────────────────────────────────
  statusDraftBg: Color(0xFFEEEEEE),
  statusInProgressBg: Color(0xFFFEF7E9),
  statusUnderReviewBg: Color(0xFFE8F6FB),
  statusPublishedBg: Color(0xFFEAF6EA),
  statusRejectedBg: Color(0xFFFCECEB),

  // ── Surface / scaffold ───────────────────────────────────────────────
  scaffoldLight: Color(0xFFFAFAFA),
  scaffoldDark: Color(0xFF121212),
  surfaceDark: Color(0xFF1E1E1E),

  // ── AI Confidence ────────────────────────────────────────────────────
  confidenceHigh: Color(0xFF5CB85C),
  confidenceHighBg: Color(0xFFEAF6EA),
  confidenceMedium: Color(0xFFF0AD4E),
  confidenceMediumBg: Color(0xFFFEF7E9),
  confidenceLow: Color(0xFFD9534F),
  confidenceLowBg: Color(0xFFFCECEB),

  // ── Action buttons ───────────────────────────────────────────────────
  actionApprove: Color(0xFF5CB85C),
  actionEdit: Color(0xFF005CA9),
  actionReject: Color(0xFFD9534F),
  actionCorrection: Color(0xFFF0AD4E),

  // ── Safety ───────────────────────────────────────────────────────────
  safetyGood: Color(0xFF5CB85C),
  safetyWarning: Color(0xFFF0AD4E),
  safetyDanger: Color(0xFFD9534F),

  // ── Badge tiers ──────────────────────────────────────────────────────
  badgeBronze: Color(0xFFCD7F32),
  badgeBronzeBg: Color(0xFFFFF3E0),
  badgeSilver: Color(0xFF9E9E9E),
  badgeSilverBg: Color(0xFFF5F5F5),
  badgeGold: Color(0xFFF0AD4E),
  badgeGoldBg: Color(0xFFFEF7E9),
  badgePurple: Color(0xFF7E57C2),
  badgePurpleBg: Color(0xFFF3E5F5),

  // ── Misc ─────────────────────────────────────────────────────────────
  divider: Color(0xFFE0E0E0),
  shadow: Color(0x1A000000),
  unreadDot: Color(0xFF005CA9),
  diffHighlight: Color(0x405CB85C),
  link: Color(0xFF005CA9),

  // ── Spacing ──────────────────────────────────────────────────────────
  spacingXxs: 2.0,
  spacingXs: 4.0,
  spacingSm: 8.0,
  spacingMd: 12.0,
  spacingLg: 16.0,
  spacingXl: 24.0,
  spacingXxl: 32.0,
  spacingXxxl: 48.0,

  // ── Radii ────────────────────────────────────────────────────────────
  radiusXs: 2.0,
  radiusSm: 4.0,
  radiusMd: 8.0,
  radiusLg: 12.0,
  radiusXl: 16.0,
  radiusFull: 20.0,

  // ── Typography ───────────────────────────────────────────────────────
  headingFontFamily: 'Inter',
  bodyFontFamily: 'Roboto',
);
