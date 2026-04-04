import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../di/injection.dart';
import '../../data/onboarding_preferences.dart';
import '../widgets/dot_indicator.dart';
import '../widgets/onboarding_page.dart';

/// Onboarding walkthrough screen for first-time users.
///
/// 4-step PageView explaining the app's features:
/// 1. Welcome to News By You
/// 2. AI Assists Your Writing
/// 3. Editors Verify
/// 4. Earn Reputation
///
/// After the last step, shows community guidelines acceptance
/// and navigates to the feed after completion.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _guidelinesAccepted = false;

  static const int _totalPages = 4;

  // Onboarding page data.
  static const _pages = [
    _PageData(
      icon: Icons.newspaper,
      iconColor: AppColors.primaryRed,
      iconBg: AppColors.primaryRedLight,
      title: 'Welcome to News By You',
      description:
          'Become a citizen journalist! Report local news from your city and share stories that matter to your community.',
    ),
    _PageData(
      icon: Icons.auto_awesome,
      iconColor: AppColors.primary,
      iconBg: AppColors.primaryLight,
      title: 'AI Assists Your Writing',
      description:
          'Our AI tool helps rephrase and structure your reports for clarity and readability. Write naturally and let AI polish it.',
    ),
    _PageData(
      icon: Icons.verified_user,
      iconColor: AppColors.safetyGood,
      iconBg: AppColors.statusPublishedBg,
      title: 'Editors Verify',
      description:
          'Every story goes through HT editorial review before publication. This ensures accuracy and builds trust in citizen journalism.',
    ),
    _PageData(
      icon: Icons.emoji_events,
      iconColor: AppColors.statusInProgress,
      iconBg: AppColors.statusInProgressBg,
      title: 'Earn Reputation',
      description:
          'Gain points, unlock badges, and level up from Basic Creator to Trusted Reporter. Your credibility grows with every published story.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isLastPage => _currentPage == _totalPages - 1;

  void _nextPage() {
    if (_isLastPage) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _skip() {
    _pageController.animateToPage(
      _totalPages - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _completeOnboarding() async {
    if (!_guidelinesAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the community guidelines to continue'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final prefs = sl<OnboardingPreferences>();
    await prefs.markOnboardingComplete();

    if (mounted) {
      context.go(AppRoutes.feed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip button ───────────────────────────────────────────
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: _isLastPage
                    ? const SizedBox(height: 48)
                    : TextButton(
                        onPressed: _skip,
                        child: Text(
                          'Skip',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.mediumGrey,
                          ),
                        ),
                      ),
              ),
            ),

            // ── PageView ──────────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _totalPages,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingPage(
                    icon: page.icon,
                    iconColor: page.iconColor,
                    iconBackgroundColor: page.iconBg,
                    title: page.title,
                    description: page.description,
                  );
                },
              ),
            ),

            // ── Dot indicators ────────────────────────────────────────
            DotIndicator(
              count: _totalPages,
              currentIndex: _currentPage,
            ),
            const SizedBox(height: 24),

            // ── Bottom section ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: _isLastPage
                  ? _buildGuidelinesSection(theme)
                  : _buildNextButton(theme),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _nextPage,
        child: const Text('Next'),
      ),
    );
  }

  Widget _buildGuidelinesSection(ThemeData theme) {
    return Column(
      children: [
        // Guidelines checkbox.
        Semantics(
          label: 'Accept community guidelines checkbox',
          child: CheckboxListTile(
            value: _guidelinesAccepted,
            onChanged: (value) {
              setState(() => _guidelinesAccepted = value ?? false);
            },
            title: Text(
              'I agree to the Community Guidelines and will report responsibly',
              style: theme.textTheme.bodyMedium,
            ),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppColors.primaryRed,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 16),

        // Accept & Continue button.
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _guidelinesAccepted ? _completeOnboarding : null,
            child: const Text('Accept & Continue'),
          ),
        ),
      ],
    );
  }
}

/// Data holder for an onboarding page.
class _PageData {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String description;

  const _PageData({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.description,
  });
}
