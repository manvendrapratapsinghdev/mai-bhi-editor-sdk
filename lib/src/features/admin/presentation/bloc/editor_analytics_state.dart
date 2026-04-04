part of 'editor_analytics_bloc.dart';

/// State for the Editor Analytics BLoC.
class EditorAnalyticsState extends Equatable {
  final bool isLoading;
  final EditorAnalytics analytics;
  final String? cityFilter;
  final String? errorMessage;

  const EditorAnalyticsState({
    this.isLoading = false,
    this.analytics = const EditorAnalytics(),
    this.cityFilter,
    this.errorMessage,
  });

  EditorAnalyticsState copyWith({
    bool? isLoading,
    EditorAnalytics? analytics,
    String? cityFilter,
    bool clearCityFilter = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EditorAnalyticsState(
      isLoading: isLoading ?? this.isLoading,
      analytics: analytics ?? this.analytics,
      cityFilter:
          clearCityFilter ? null : (cityFilter ?? this.cityFilter),
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, analytics, cityFilter, errorMessage];
}
