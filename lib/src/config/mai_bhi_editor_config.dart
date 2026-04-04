import '../auth/auth_provider.dart';
import '../core/constants/indian_cities.dart';
import '../design_system/default_design_system.dart';
import '../design_system/design_system.dart';

/// Immutable configuration for the Mai Bhi Editor SDK.
class MaiBhiEditorConfig {
  /// Base URL for the API (e.g., 'https://api.example.com/v1').
  final String baseUrl;

  /// Authentication provider implemented by the host app.
  final AuthProvider authProvider;

  /// Design system tokens. Defaults to the HT-branded design system.
  final DesignSystem designSystem;

  /// HTTP connection timeout.
  final Duration connectTimeout;

  /// HTTP receive timeout.
  final Duration receiveTimeout;

  /// HTTP send timeout.
  final Duration sendTimeout;

  /// Whether to enable analytics event collection.
  final bool enableAnalytics;

  /// City list shown in the submission form dropdown.
  /// Defaults to [kIndianCities] if not provided.
  final List<String> cities;

  const MaiBhiEditorConfig({
    required this.baseUrl,
    required this.authProvider,
    this.designSystem = kDefaultDesignSystem,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.sendTimeout = const Duration(seconds: 30),
    this.enableAnalytics = true,
    this.cities = kIndianCities,
  });
}
