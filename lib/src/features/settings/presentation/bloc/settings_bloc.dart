import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../notifications/domain/entities/notification_entity.dart';
import '../../../notifications/domain/repositories/notification_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

/// BLoC for the settings screen.
///
/// Manages notification preferences and locale selection.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final NotificationRepository _notificationRepository;

  SettingsBloc({
    required NotificationRepository notificationRepository,
  })  : _notificationRepository = notificationRepository,
        super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleNotificationPreference>(_onTogglePreference);
    on<ChangeLocale>(_onChangeLocale);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final prefs = await _notificationRepository.getPreferences();
      final sharedPrefs = await SharedPreferences.getInstance();
      final localeCode = sharedPrefs.getString('app_locale') ?? 'en';
      emit(state.copyWith(
        isLoading: false,
        preferences: prefs,
        locale: Locale(localeCode),
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load settings',
      ));
    }
  }

  Future<void> _onTogglePreference(
    ToggleNotificationPreference event,
    Emitter<SettingsState> emit,
  ) async {
    final current = state.preferences;
    NotificationPreferences updated;

    switch (event.category) {
      case 'story_updates':
        updated = current.copyWith(storyUpdates: event.value);
      case 'milestones_badges':
        updated = current.copyWith(milestonesBadges: event.value);
      case 'trending_stories':
        updated = current.copyWith(trendingStories: event.value);
      case 'community_activity':
        updated = current.copyWith(communityActivity: event.value);
      default:
        return;
    }

    // Optimistic update.
    emit(state.copyWith(preferences: updated));

    try {
      final serverPrefs =
          await _notificationRepository.updatePreferences(updated);
      emit(state.copyWith(preferences: serverPrefs));
    } on ServerException catch (e) {
      // Revert on failure.
      emit(state.copyWith(
        preferences: current,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        preferences: current,
        errorMessage: 'Failed to update preference',
      ));
    }
  }

  Future<void> _onChangeLocale(
    ChangeLocale event,
    Emitter<SettingsState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', event.locale.languageCode);
    emit(state.copyWith(locale: event.locale));
  }
}
