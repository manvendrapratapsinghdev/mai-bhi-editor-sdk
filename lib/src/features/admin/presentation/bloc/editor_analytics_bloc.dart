import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/editor_analytics.dart';
import '../../domain/repositories/admin_repository.dart';

part 'editor_analytics_event.dart';
part 'editor_analytics_state.dart';

/// BLoC for the editor analytics dashboard.
class EditorAnalyticsBloc
    extends Bloc<EditorAnalyticsEvent, EditorAnalyticsState> {
  final AdminRepository _repository;

  EditorAnalyticsBloc({required AdminRepository repository})
      : _repository = repository,
        super(const EditorAnalyticsState()) {
    on<LoadEditorAnalytics>(_onLoadAnalytics);
    on<FilterEditorAnalyticsByCity>(_onFilterByCity);
  }

  Future<void> _onLoadAnalytics(
    LoadEditorAnalytics event,
    Emitter<EditorAnalyticsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final analytics =
          await _repository.getEditorAnalytics(city: state.cityFilter);
      emit(state.copyWith(isLoading: false, analytics: analytics));
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load editor analytics',
      ));
    }
  }

  Future<void> _onFilterByCity(
    FilterEditorAnalyticsByCity event,
    Emitter<EditorAnalyticsState> emit,
  ) async {
    emit(state.copyWith(
      cityFilter: event.city,
      clearCityFilter: event.city == null,
      isLoading: true,
      clearError: true,
    ));
    try {
      final analytics =
          await _repository.getEditorAnalytics(city: event.city);
      emit(state.copyWith(isLoading: false, analytics: analytics));
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to filter analytics',
      ));
    }
  }
}
