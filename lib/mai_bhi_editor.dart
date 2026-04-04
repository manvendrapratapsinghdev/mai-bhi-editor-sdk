/// Mai Bhi Editor SDK - Reusable citizen journalism package for Flutter apps.
///
/// ## Quick Start
///
/// ```dart
/// await MaiBhiEditor.initialize(
///   authProvider: myAuthProvider,
///   baseUrl: 'https://api.example.com/v1',
/// );
/// ```
library;

// Config & initialization
export 'src/config/mai_bhi_editor_initializer.dart';
export 'src/config/mai_bhi_editor_config.dart';

// Auth contract
export 'src/auth/auth_provider.dart';
export 'src/auth/auth_status.dart';

// Design system
export 'src/design_system/design_system.dart';
export 'src/design_system/default_design_system.dart';
export 'src/design_system/design_system_scope.dart';

// Navigation
export 'src/router/mbe_routes.dart';
export 'src/router/mbe_screen_builder.dart';

// Theme
export 'src/design_system/mbe_theme.dart';

// Errors
export 'src/core/error/exceptions.dart';
