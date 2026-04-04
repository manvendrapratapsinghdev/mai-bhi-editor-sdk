import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/appeal.dart';
import '../../domain/usecases/get_appeal_usecase.dart';
import '../../domain/usecases/submit_appeal_usecase.dart';

part 'appeal_event.dart';
part 'appeal_state.dart';

/// BLoC managing the appeal submission flow (S4-08).
///
/// Allows creators to check appeal status and file new appeals for
/// rejected submissions.
class AppealBloc extends Bloc<AppealEvent, AppealState> {
  final GetAppealUseCase _getAppealUseCase;
  final SubmitAppealUseCase _submitAppealUseCase;

  AppealBloc({
    required GetAppealUseCase getAppealUseCase,
    required SubmitAppealUseCase submitAppealUseCase,
  })  : _getAppealUseCase = getAppealUseCase,
        _submitAppealUseCase = submitAppealUseCase,
        super(const AppealInitial()) {
    on<LoadAppealStatus>(_onLoadAppealStatus);
    on<SubmitAppealEvent>(_onSubmitAppeal);
  }

  Future<void> _onLoadAppealStatus(
    LoadAppealStatus event,
    Emitter<AppealState> emit,
  ) async {
    emit(const AppealLoading());

    try {
      final appeal = await _getAppealUseCase(event.submissionId);

      if (appeal == null) {
        emit(const AppealNotFiled());
      } else if (appeal.status == AppealStatus.pending) {
        emit(AppealPending(appeal));
      } else {
        emit(AppealReviewed(appeal));
      }
    } on ServerException catch (e) {
      emit(AppealError(e.message));
    } on NetworkException catch (e) {
      emit(AppealError(e.message));
    } catch (e) {
      // If we can't fetch appeal status, assume none filed.
      emit(const AppealNotFiled());
    }
  }

  Future<void> _onSubmitAppeal(
    SubmitAppealEvent event,
    Emitter<AppealState> emit,
  ) async {
    emit(const AppealSubmitting());

    try {
      final appeal = await _submitAppealUseCase(
        submissionId: event.submissionId,
        justification: event.justification,
      );
      emit(AppealSubmitted(appeal));
    } on ServerException catch (e) {
      emit(AppealError(e.message));
    } on NetworkException catch (e) {
      emit(AppealError(e.message));
    } catch (e) {
      emit(const AppealError('Failed to submit appeal. Please try again.'));
    }
  }
}
