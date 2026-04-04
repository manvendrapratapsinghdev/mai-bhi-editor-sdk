part of 'settings_bloc.dart';

/// State for the settings BLoC.
class SettingsState extends Equatable {
  final bool isLoading;
  final NotificationPreferences preferences;
  final Locale locale;
  final String? errorMessage;

  const SettingsState({
    this.isLoading = false,
    this.preferences = const NotificationPreferences(),
    this.locale = const Locale('en'),
    this.errorMessage,
  });

  SettingsState copyWith({
    bool? isLoading,
    NotificationPreferences? preferences,
    Locale? locale,
    String? errorMessage,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      preferences: preferences ?? this.preferences,
      locale: locale ?? this.locale,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, preferences, locale, errorMessage];
}
