import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Dot indicators for the onboarding page view.
class DotIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const DotIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryRed : AppColors.lightGrey,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
