import 'package:flutter/material.dart';

import 'design_system.dart';

/// InheritedWidget that provides [DesignSystem] to the widget tree.
///
/// Wrap your app with this (or use [MaiBhiEditor.wrap]) to enable
/// `DesignSystem.of(context)` access in all descendant widgets.
class DesignSystemScope extends InheritedWidget {
  final DesignSystem designSystem;

  const DesignSystemScope({
    super.key,
    required this.designSystem,
    required super.child,
  });

  @override
  bool updateShouldNotify(DesignSystemScope oldWidget) =>
      designSystem != oldWidget.designSystem;
}
