part of 'settings_bloc.dart';

/// Events for the settings BLoC.
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Load notification preferences and locale setting.
class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

/// Toggle a notification preference category.
class ToggleNotificationPreference extends SettingsEvent {
  /// One of: 'story_updates', 'milestones_badges',
  /// 'trending_stories', 'community_activity'.
  final String category;
  final bool value;

  const ToggleNotificationPreference({
    required this.category,
    required this.value,
  });

  @override
  List<Object?> get props => [category, value];
}

/// Change the application locale.
class ChangeLocale extends SettingsEvent {
  final Locale locale;

  const ChangeLocale(this.locale);

  @override
  List<Object?> get props => [locale];
}
