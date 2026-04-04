import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_provider.dart';
import '../core/analytics/analytics_service.dart';
import '../core/constants/indian_cities.dart';
import '../design_system/default_design_system.dart';
import '../design_system/design_system.dart';
import '../design_system/design_system_scope.dart';
import '../design_system/mbe_theme.dart';
import '../di/injection.dart' as di;
import '../network/api_client.dart';
import '../router/mbe_router.dart';
import 'mai_bhi_editor_config.dart';

/// Main entry point for the Mai Bhi Editor SDK.
///
/// Call [initialize] once before using any SDK widget or screen.
///
/// ## Usage
///
/// ```dart
/// await MaiBhiEditor.initialize(
///   authProvider: myAuthProvider,
///   baseUrl: 'https://api.example.com/v1',
///   designSystem: customDesignSystem, // optional
/// );
///
/// // In your widget tree:
/// MaiBhiEditor.wrap(
///   child: MaterialApp.router(
///     theme: MaiBhiEditor.lightTheme,
///     darkTheme: MaiBhiEditor.darkTheme,
///     routerConfig: MaiBhiEditor.router,
///   ),
/// );
/// ```
class MaiBhiEditor {
  MaiBhiEditor._();

  static bool _initialized = false;
  static late MaiBhiEditorConfig _config;

  /// Initialize the SDK. Must be called once in your app's `main()`.
  static Future<void> initialize({
    required AuthProvider authProvider,
    required String baseUrl,
    DesignSystem? designSystem,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 15),
    Duration sendTimeout = const Duration(seconds: 30),
    bool enableAnalytics = true,
    List<String>? cities,
  }) async {
    if (_initialized) return;

    _config = MaiBhiEditorConfig(
      baseUrl: baseUrl,
      authProvider: authProvider,
      designSystem: designSystem ?? kDefaultDesignSystem,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      enableAnalytics: enableAnalytics,
      cities: cities ?? kIndianCities,
    );

    // Initialize the HTTP client.
    MbeApiClient.init(
      baseUrl: baseUrl,
      authProvider: authProvider,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
    );

    // Register package-scoped DI dependencies.
    await di.registerSdkDependencies();

    // Start the analytics flush timer (if analytics are enabled).
    if (enableAnalytics) {
      di.sl<AnalyticsService>().initialize();
    }

    _initialized = true;
  }

  /// Initialize from a pre-built config object.
  static Future<void> initializeWithConfig(MaiBhiEditorConfig config) async {
    return initialize(
      authProvider: config.authProvider,
      baseUrl: config.baseUrl,
      designSystem: config.designSystem,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      enableAnalytics: config.enableAnalytics,
      cities: config.cities,
    );
  }

  // ── Accessors ─────────────────────────────────────────────────────────

  static void _assertInitialized() {
    if (!_initialized) {
      throw StateError(
          'MaiBhiEditor.initialize() must be called before accessing SDK.');
    }
  }

  /// The current configuration.
  static MaiBhiEditorConfig get config {
    _assertInitialized();
    return _config;
  }

  /// The host-provided auth provider.
  static AuthProvider get authProvider {
    _assertInitialized();
    return _config.authProvider;
  }

  /// The active design system.
  static DesignSystem get designSystem {
    _assertInitialized();
    return _config.designSystem;
  }

  /// The API base URL.
  static String get baseUrl {
    _assertInitialized();
    return _config.baseUrl;
  }

  /// Whether the SDK has been initialized.
  static bool get isInitialized => _initialized;

  // ── Router ────────────────────────────────────────────────────────────

  /// GoRouter with all SDK routes and auth guards (Mode A).
  static GoRouter get router {
    _assertInitialized();
    return MbeRouter.router;
  }

  // ── Theme ─────────────────────────────────────────────────────────────

  /// Light theme derived from the active design system.
  static ThemeData get lightTheme {
    _assertInitialized();
    return MbeTheme.light(_config.designSystem);
  }

  /// Dark theme derived from the active design system.
  static ThemeData get darkTheme {
    _assertInitialized();
    return MbeTheme.dark(_config.designSystem);
  }

  // ── Widget Wrapper ────────────────────────────────────────────────────

  /// Wraps the host app's widget tree with the SDK's [DesignSystemScope].
  ///
  /// Place this at the root of your widget tree to enable
  /// `DesignSystem.of(context)` in all descendant widgets.
  static Widget wrap({required Widget child}) {
    _assertInitialized();
    return DesignSystemScope(
      designSystem: _config.designSystem,
      child: child,
    );
  }

  /// Reset the SDK (for testing only).
  static Future<void> reset() async {
    if (_initialized) {
      await di.sl<AnalyticsService>().dispose();
    }
    _initialized = false;
    MbeRouter.reset();
    MbeApiClient.reset();
    await di.resetSdkDependencies();
  }
}
