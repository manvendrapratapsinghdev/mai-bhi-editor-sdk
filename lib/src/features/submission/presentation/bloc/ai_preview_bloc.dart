import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/ai_review_result.dart';
import '../../domain/entities/submission_detail.dart';
import '../../domain/usecases/get_submission_detail_usecase.dart';
import '../../domain/usecases/trigger_ai_processing_usecase.dart';

part 'ai_preview_event.dart';
part 'ai_preview_state.dart';

/// BLoC managing the "Your post corrected by AI" preview screen.
///
/// Flow:
/// 1. [LoadAiPreview] fetches the submission detail.
/// 2. If aiReview is already present, emits [AiPreviewLoaded].
/// 3. If aiReview is null, emits [AiPreviewProcessing] and triggers
///    AI processing, then reloads the detail.
class AiPreviewBloc extends Bloc<AiPreviewEvent, AiPreviewState> {
  final GetSubmissionDetailUseCase _getSubmissionDetailUseCase;
  final TriggerAiProcessingUseCase _triggerAiProcessingUseCase;

  AiPreviewBloc({
    required GetSubmissionDetailUseCase getSubmissionDetailUseCase,
    required TriggerAiProcessingUseCase triggerAiProcessingUseCase,
  })  : _getSubmissionDetailUseCase = getSubmissionDetailUseCase,
        _triggerAiProcessingUseCase = triggerAiProcessingUseCase,
        super(const AiPreviewInitial()) {
    on<LoadAiPreview>(_onLoadAiPreview);
    on<TriggerAiProcessing>(_onTriggerAiProcessing);
    on<AcceptAndProceed>(_onAcceptAndProceed);
    on<ToggleTag>(_onToggleTag);
    on<UpdateCategory>(_onUpdateCategory);
  }

  Future<void> _onLoadAiPreview(
    LoadAiPreview event,
    Emitter<AiPreviewState> emit,
  ) async {
    emit(const AiPreviewLoading());

    try {
      final detail = await _getSubmissionDetailUseCase(event.submissionId);

      if (detail.aiReview != null) {
        // AI review already available.
        emit(AiPreviewLoaded(
          submissionDetail: detail,
          aiReview: detail.aiReview!,
          selectedTags: detail.aiReview!.suggestedTags.toSet(),
          selectedCategory: detail.aiReview!.suggestedCategory,
        ));
      } else {
        // AI review not yet done — trigger processing.
        emit(AiPreviewProcessing(detail));
        await _processAi(event.submissionId, detail, emit);
      }
    } on ServerException catch (e) {
      emit(AiPreviewError(
        e.message,
        submissionId: event.submissionId,
      ));
    } on NetworkException catch (e) {
      emit(AiPreviewError(
        e.message,
        submissionId: event.submissionId,
      ));
    } catch (e) {
      emit(AiPreviewError(
        'Failed to load submission. Please try again.',
        submissionId: event.submissionId,
      ));
    }
  }

  Future<void> _onTriggerAiProcessing(
    TriggerAiProcessing event,
    Emitter<AiPreviewState> emit,
  ) async {
    // Fetch fresh detail first to get the submission context.
    try {
      final detail = await _getSubmissionDetailUseCase(event.submissionId);
      emit(AiPreviewProcessing(detail));
      await _processAi(event.submissionId, detail, emit);
    } on ServerException catch (e) {
      emit(AiPreviewError(
        e.message,
        submissionId: event.submissionId,
      ));
    } on NetworkException catch (e) {
      emit(AiPreviewError(
        e.message,
        submissionId: event.submissionId,
      ));
    } catch (e) {
      emit(AiPreviewError(
        'AI processing failed. Please try again.',
        submissionId: event.submissionId,
      ));
    }
  }

  Future<void> _processAi(
    String submissionId,
    SubmissionDetail detail,
    Emitter<AiPreviewState> emit,
  ) async {
    try {
      final aiResult =
          await _triggerAiProcessingUseCase(submissionId);

      // Build the updated detail with the AI review result.
      final updatedDetail = SubmissionDetail(
        id: detail.id,
        title: detail.title,
        description: detail.description,
        city: detail.city,
        status: detail.status,
        coverImageUrl: detail.coverImageUrl,
        createdAt: detail.createdAt,
        creator: detail.creator,
        originalText: detail.originalText,
        aiRewrittenText: aiResult.rewrittenText,
        aiReview: aiResult,
        additionalImages: detail.additionalImages,
        editorNotes: detail.editorNotes,
      );

      emit(AiPreviewLoaded(
        submissionDetail: updatedDetail,
        aiReview: aiResult,
        selectedTags: aiResult.suggestedTags.toSet(),
        selectedCategory: aiResult.suggestedCategory,
      ));
    } on ServerException catch (e) {
      emit(AiPreviewError(
        e.message,
        submissionId: submissionId,
      ));
    } on NetworkException catch (e) {
      emit(AiPreviewError(
        e.message,
        submissionId: submissionId,
      ));
    } catch (e) {
      emit(AiPreviewError(
        'AI processing failed. Please try again.',
        submissionId: submissionId,
      ));
    }
  }

  Future<void> _onAcceptAndProceed(
    AcceptAndProceed event,
    Emitter<AiPreviewState> emit,
  ) async {
    // The navigation to the editorial queue is handled in the UI layer
    // via BlocListener. This event signals that the user accepted
    // the AI corrections. The current loaded state remains unchanged.
    //
    // In a production implementation, this would POST to submit the
    // submission to the editorial queue with the selected tags/category.
  }

  void _onToggleTag(
    ToggleTag event,
    Emitter<AiPreviewState> emit,
  ) {
    final currentState = state;
    if (currentState is AiPreviewLoaded) {
      final updatedTags = Set<String>.from(currentState.selectedTags);
      if (updatedTags.contains(event.tag)) {
        updatedTags.remove(event.tag);
      } else {
        updatedTags.add(event.tag);
      }
      emit(currentState.copyWith(selectedTags: updatedTags));
    }
  }

  void _onUpdateCategory(
    UpdateCategory event,
    Emitter<AiPreviewState> emit,
  ) {
    final currentState = state;
    if (currentState is AiPreviewLoaded) {
      emit(currentState.copyWith(selectedCategory: event.category));
    }
  }
}
