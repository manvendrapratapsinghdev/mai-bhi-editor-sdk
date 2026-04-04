part of 'editor_analytics_bloc.dart';

/// Events for the Editor Analytics BLoC.
abstract class EditorAnalyticsEvent extends Equatable {
  const EditorAnalyticsEvent();

  @override
  List<Object?> get props => [];
}

/// Load editor analytics data.
class LoadEditorAnalytics extends EditorAnalyticsEvent {
  const LoadEditorAnalytics();
}

/// Filter editor analytics by city. Pass null for all cities.
class FilterEditorAnalyticsByCity extends EditorAnalyticsEvent {
  final String? city;

  const FilterEditorAnalyticsByCity(this.city);

  @override
  List<Object?> get props => [city];
}
