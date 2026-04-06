import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A single shimmer placeholder rectangle.
///
/// Use inside a [ShimmerEffect] to get the animated gradient sweep.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 4.0,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.extraLightGrey,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Wraps its [child] with an animated shimmer gradient sweep.
///
/// The gradient travels left-to-right over 1500 ms using [Curves.easeInOut],
/// repeating infinitely. No external packages required.
class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor = AppColors.extraLightGrey,
    this.highlightColor = const Color(0xBBFFFFFF), // white @ ~73% opacity
    this.duration = const Duration(milliseconds: 1500),
  });

  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Animate the gradient position from -1.0 to 2.0
        final value = Curves.easeInOut.transform(_controller.value);
        final offset = -1.0 + 3.0 * value;

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                (offset - 0.3).clamp(0.0, 1.0),
                offset.clamp(0.0, 1.0),
                (offset + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
