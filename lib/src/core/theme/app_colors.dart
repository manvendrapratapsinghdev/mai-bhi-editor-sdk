// Backwards-compatible shim: maps the old AppColors static API to
// the default design system values. Features should migrate to
// DesignSystem.of(context) over time.
import 'package:flutter/material.dart';

import '../../design_system/default_design_system.dart';

class AppColors {
  AppColors._();

  // ── Brand ─────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF005CA9);
  static const Color primaryDark = Color(0xFF003D73);
  static const Color primaryLight = Color(0xFFE5F0FA);
  static const Color secondary = Color(0xFF0D2137);
  static const Color secondaryDark = Color(0xFF081525);
  static const Color secondaryLight = Color(0xFFE1E8F0);
  static const Color link = Color(0xFF005CA9);

  // ── Legacy aliases ────────────────────────────────────────────────────
  static const Color primaryRed = secondary;
  static const Color primaryRedDark = secondaryDark;
  static const Color primaryRedLight = secondaryLight;

  // ── Neutrals ──────────────────────────────────────────────────────────
  static const Color black = Color(0xFF111111);
  static const Color darkGrey = Color(0xFF4D4D4D);
  static const Color mediumGrey = Color(0xFF999999);
  static const Color lightGrey = Color(0xFFCCCCCC);
  static const Color extraLightGrey = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);

  // ── Status ────────────────────────────────────────────────────────────
  static const Color statusDraft = Color(0xFF69727D);
  static const Color statusInProgress = Color(0xFFF0AD4E);
  static const Color statusUnderReview = Color(0xFF5BC0DE);
  static const Color statusPublished = Color(0xFF5CB85C);
  static const Color statusRejected = Color(0xFFD9534F);

  static const Color statusDraftBg = Color(0xFFEEEEEE);
  static const Color statusInProgressBg = Color(0xFFFEF7E9);
  static const Color statusUnderReviewBg = Color(0xFFE8F6FB);
  static const Color statusPublishedBg = Color(0xFFEAF6EA);
  static const Color statusRejectedBg = Color(0xFFFCECEB);

  // ── Surface / scaffold ────────────────────────────────────────────────
  static const Color scaffoldLight = Color(0xFFFAFAFA);
  static const Color scaffoldDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // ── AI Confidence ─────────────────────────────────────────────────────
  static const Color confidenceHigh = Color(0xFF5CB85C);
  static const Color confidenceHighBg = Color(0xFFEAF6EA);
  static const Color confidenceMedium = Color(0xFFF0AD4E);
  static const Color confidenceMediumBg = Color(0xFFFEF7E9);
  static const Color confidenceLow = Color(0xFFD9534F);
  static const Color confidenceLowBg = Color(0xFFFCECEB);

  // ── Actions ───────────────────────────────────────────────────────────
  static const Color actionApprove = Color(0xFF5CB85C);
  static const Color actionEdit = Color(0xFF005CA9);
  static const Color actionReject = Color(0xFFD9534F);
  static const Color actionCorrection = Color(0xFFF0AD4E);

  // ── Safety ────────────────────────────────────────────────────────────
  static const Color safetyGood = Color(0xFF5CB85C);
  static const Color safetyWarning = Color(0xFFF0AD4E);
  static const Color safetyDanger = Color(0xFFD9534F);

  // ── Badge tiers ───────────────────────────────────────────────────────
  static const Color badgeBronze = Color(0xFFCD7F32);
  static const Color badgeBronzeBg = Color(0xFFFFF3E0);
  static const Color badgeSilver = Color(0xFF9E9E9E);
  static const Color badgeSilverBg = Color(0xFFF5F5F5);
  static const Color badgeGold = Color(0xFFF0AD4E);
  static const Color badgeGoldBg = Color(0xFFFEF7E9);
  static const Color badgePurple = Color(0xFF7E57C2);
  static const Color badgePurpleBg = Color(0xFFF3E5F5);

  // ── Misc ──────────────────────────────────────────────────────────────
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);
  static const Color unreadDot = Color(0xFF005CA9);
  static const Color diffHighlight = Color(0x405CB85C);

  static Color statusColor(String status) =>
      kDefaultDesignSystem.statusColor(status);

  static Color statusBackgroundColor(String status) =>
      kDefaultDesignSystem.statusBackgroundColor(status);

  static Color confidenceColor(double score) =>
      kDefaultDesignSystem.confidenceColor(score);

  static Color confidenceBackgroundColor(double score) =>
      kDefaultDesignSystem.confidenceBackgroundColor(score);
}
