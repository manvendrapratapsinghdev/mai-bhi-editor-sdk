import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../../submission/domain/entities/submission_detail.dart';
import '../../data/models/editor_action_model.dart';
import '../../domain/repositories/editorial_repository.dart';
import '../../domain/usecases/flag_false_news_usecase.dart';
import '../../domain/usecases/perform_editor_action_usecase.dart';

part 'editor_review_event.dart';
part 'editor_review_state.dart';

/// BLoC managing the editor review detail screen.
///
/// Loads submission detail, allows performing editorial actions
/// (approve / edit / reject / mark-correction), and flagging false news.
class EditorReviewBloc extends Bloc<EditorReviewEvent, EditorReviewState> {
  final EditorialRepository _repository;
  final PerformEditorActionUseCase _performEditorActionUseCase;
  final FlagFalseNewsUseCase _flagFalseNewsUseCase;

  EditorReviewBloc({
    required EditorialRepository repository,
    required PerformEditorActionUseCase performEditorActionUseCase,
    required FlagFalseNewsUseCase flagFalseNewsUseCase,
  })  : _repository = repository,
        _performEditorActionUseCase = performEditorActionUseCase,
        _flagFalseNewsUseCase = flagFalseNewsUseCase,
        super(const EditorReviewInitial()) {
    on<LoadReview>(_onLoadReview);
    on<PerformAction>(_onPerformAction);
    on<UpdateEditedText>(_onUpdateEditedText);
    on<FlagAsFalse>(_onFlagAsFalse);
  }

  Future<void> _onLoadReview(
    LoadReview event,
    Emitter<EditorReviewState> emit,
  ) async {
    emit(const EditorReviewLoading());

    try {
      final detail = await _repository.getSubmissionDetail(event.submissionId);
      emit(EditorReviewLoaded(
        submissionDetail: detail,
        editedTitle: detail.title,
        editedDescription: detail.aiRewrittenText ?? detail.description,
      ));
    } on ServerException catch (e) {
      emit(EditorReviewError(e.message, submissionId: event.submissionId));
    } on NetworkException catch (e) {
      emit(EditorReviewError(e.message, submissionId: event.submissionId));
    } catch (e) {
      emit(EditorReviewError(
        'Failed to load submission for review.',
        submissionId: event.submissionId,
      ));
    }
  }

  Future<void> _onPerformAction(
    PerformAction event,
    Emitter<EditorReviewState> emit,
  ) async {
    final currentState = state;
    if (currentState is! EditorReviewLoaded) return;

    emit(EditorReviewSubmitting(currentState.submissionDetail));

    try {
      await _performEditorActionUseCase(
        submissionId: currentState.submissionDetail.id,
        action: event.action,
      );

      final message = _actionSuccessMessage(event.action.action);
      emit(EditorReviewActionSuccess(message));
    } on ServerException catch (e) {
      emit(EditorReviewError(
        e.message,
        submissionId: currentState.submissionDetail.id,
      ));
    } on NetworkException catch (e) {
      emit(EditorReviewError(
        e.message,
        submissionId: currentState.submissionDetail.id,
      ));
    } catch (e) {
      emit(EditorReviewError(
        'Failed to perform action.',
        submissionId: currentState.submissionDetail.id,
      ));
    }
  }

  void _onUpdateEditedText(
    UpdateEditedText event,
    Emitter<EditorReviewState> emit,
  ) {
    final currentState = state;
    if (currentState is EditorReviewLoaded) {
      emit(currentState.copyWith(
        editedTitle: event.editedTitle ?? currentState.editedTitle,
        editedDescription:
            event.editedDescription ?? currentState.editedDescription,
      ));
    }
  }

  Future<void> _onFlagAsFalse(
    FlagAsFalse event,
    Emitter<EditorReviewState> emit,
  ) async {
    final currentState = state;
    if (currentState is! EditorReviewLoaded) return;

    emit(currentState.copyWith(isFlagging: true));

    try {
      await _flagFalseNewsUseCase(currentState.submissionDetail.id);
      emit(EditorReviewFlagSuccess(
        submissionDetail: currentState.submissionDetail,
        message:
            'Story flagged as false. It has been removed from the feed.',
      ));
    } on ServerException catch (e) {
      emit(currentState.copyWith(isFlagging: false));
      emit(EditorReviewError(
        e.message,
        submissionId: currentState.submissionDetail.id,
      ));
    } on NetworkException catch (e) {
      emit(currentState.copyWith(isFlagging: false));
      emit(EditorReviewError(
        e.message,
        submissionId: currentState.submissionDetail.id,
      ));
    } catch (e) {
      emit(currentState.copyWith(isFlagging: false));
      emit(EditorReviewError(
        'Failed to flag story as false.',
        submissionId: currentState.submissionDetail.id,
      ));
    }
  }

  String _actionSuccessMessage(EditorActionType actionType) {
    switch (actionType) {
      case EditorActionType.approve:
        return 'Submission approved and published!';
      case EditorActionType.edit:
        return 'Edited submission submitted successfully!';
      case EditorActionType.reject:
        return 'Submission rejected.';
      case EditorActionType.markCorrection:
        return 'Correction notes submitted.';
    }
  }
}
