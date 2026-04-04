import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../data/local/draft_local_datasource.dart';
import '../../data/models/submission_create_model.dart';
import '../../domain/usecases/create_submission_usecase.dart';

part 'submission_form_event.dart';
part 'submission_form_state.dart';

/// BLoC that manages the submission creation form state.
class SubmissionFormBloc
    extends Bloc<SubmissionFormEvent, SubmissionFormState> {
  final CreateSubmissionUseCase _createSubmissionUseCase;
  final DraftLocalDataSource _draftLocalDataSource;

  SubmissionFormBloc({
    required CreateSubmissionUseCase createSubmissionUseCase,
    required DraftLocalDataSource draftLocalDataSource,
  })  : _createSubmissionUseCase = createSubmissionUseCase,
        _draftLocalDataSource = draftLocalDataSource,
        super(const SubmissionFormState()) {
    on<SubmissionTitleChanged>(_onTitleChanged);
    on<SubmissionDescriptionChanged>(_onDescriptionChanged);
    on<SubmissionCityChanged>(_onCityChanged);
    on<SubmissionCoverImagePicked>(_onCoverImagePicked);
    on<SubmissionCoverImageRemoved>(_onCoverImageRemoved);
    on<SubmissionAdditionalImageAdded>(_onAdditionalImageAdded);
    on<SubmissionAdditionalImageRemoved>(_onAdditionalImageRemoved);
    on<SubmissionImagesReordered>(_onImagesReordered);
    on<SubmissionFormSubmitted>(_onSubmitted);
    on<SubmissionDraftLoaded>(_onDraftLoaded);
    on<SubmissionDraftSaveRequested>(_onDraftSaveRequested);
    on<SubmissionDraftDeleteRequested>(_onDraftDeleteRequested);
    on<SubmissionFormReset>(_onFormReset);
  }

  void _onTitleChanged(
    SubmissionTitleChanged event,
    Emitter<SubmissionFormState> emit,
  ) {
    emit(state.copyWith(
      title: event.title,
      titleError: null,
      clearError: true,
      clearSuccess: true,
    ));
  }

  void _onDescriptionChanged(
    SubmissionDescriptionChanged event,
    Emitter<SubmissionFormState> emit,
  ) {
    emit(state.copyWith(
      description: event.description,
      descriptionError: null,
      clearError: true,
      clearSuccess: true,
    ));
  }

  void _onCityChanged(
    SubmissionCityChanged event,
    Emitter<SubmissionFormState> emit,
  ) {
    emit(state.copyWith(
      city: event.city,
      cityError: null,
      clearError: true,
      clearSuccess: true,
    ));
  }

  void _onCoverImagePicked(
    SubmissionCoverImagePicked event,
    Emitter<SubmissionFormState> emit,
  ) {
    // Validate image size (max 10MB).
    final file = File(event.imagePath);
    if (file.existsSync()) {
      final sizeInBytes = file.lengthSync();
      if (sizeInBytes > 10 * 1024 * 1024) {
        emit(state.copyWith(
          coverImageError: 'Image must be under 10MB',
        ));
        return;
      }

      // Validate file extension.
      final ext = event.imagePath.split('.').last.toLowerCase();
      if (!_allowedExtensions.contains(ext)) {
        emit(state.copyWith(
          coverImageError: 'Allowed formats: JPG, PNG, WebP',
        ));
        return;
      }
    }

    emit(state.copyWith(
      coverImagePath: event.imagePath,
      coverImageError: null,
      clearError: true,
      clearSuccess: true,
    ));
  }

  void _onCoverImageRemoved(
    SubmissionCoverImageRemoved event,
    Emitter<SubmissionFormState> emit,
  ) {
    emit(state.copyWith(
      clearCoverImage: true,
      clearError: true,
      clearSuccess: true,
    ));
  }

  void _onAdditionalImageAdded(
    SubmissionAdditionalImageAdded event,
    Emitter<SubmissionFormState> emit,
  ) {
    if (state.additionalImagePaths.length >= 9) {
      emit(state.copyWith(
        errorMessage: 'Maximum 9 additional images allowed',
      ));
      return;
    }

    // Validate image.
    final file = File(event.imagePath);
    if (file.existsSync()) {
      final sizeInBytes = file.lengthSync();
      if (sizeInBytes > 10 * 1024 * 1024) {
        emit(state.copyWith(
          errorMessage: 'Image must be under 10MB',
        ));
        return;
      }

      final ext = event.imagePath.split('.').last.toLowerCase();
      if (!_allowedExtensions.contains(ext)) {
        emit(state.copyWith(
          errorMessage: 'Allowed formats: JPG, PNG, WebP',
        ));
        return;
      }
    }

    final updated = [...state.additionalImagePaths, event.imagePath];
    emit(state.copyWith(
      additionalImagePaths: updated,
      clearError: true,
      clearSuccess: true,
    ));
  }

  void _onAdditionalImageRemoved(
    SubmissionAdditionalImageRemoved event,
    Emitter<SubmissionFormState> emit,
  ) {
    final updated = [...state.additionalImagePaths]..removeAt(event.index);
    emit(state.copyWith(
      additionalImagePaths: updated,
      clearError: true,
      clearSuccess: true,
    ));
  }

  void _onImagesReordered(
    SubmissionImagesReordered event,
    Emitter<SubmissionFormState> emit,
  ) {
    final updated = [...state.additionalImagePaths];
    final item = updated.removeAt(event.oldIndex);
    updated.insert(event.newIndex, item);
    emit(state.copyWith(additionalImagePaths: updated));
  }

  Future<void> _onSubmitted(
    SubmissionFormSubmitted event,
    Emitter<SubmissionFormState> emit,
  ) async {
    // Validate.
    final errors = _validate();
    if (errors != null) {
      emit(errors);
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));

    try {
      await _createSubmissionUseCase(
        data: SubmissionCreate(
          title: state.title.trim(),
          description: state.description.trim(),
          city: state.city,
        ),
        coverImagePath: state.coverImagePath!,
        additionalImagePaths: state.additionalImagePaths,
      );

      // If this was a loaded draft, delete it on successful submission.
      if (state.draftId != null) {
        await _draftLocalDataSource.deleteDraft(state.draftId!);
      }

      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: true,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: e.message,
      ));
    } on NetworkException catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Submission failed. Please try again.',
      ));
    }
  }

  Future<void> _onDraftLoaded(
    SubmissionDraftLoaded event,
    Emitter<SubmissionFormState> emit,
  ) async {
    final draft = await _draftLocalDataSource.getDraft(event.draftId);
    if (draft == null) return;

    emit(state.copyWith(
      draftId: draft.id,
      title: draft.title,
      description: draft.description,
      city: draft.city,
      coverImagePath: draft.coverImagePath,
      additionalImagePaths: draft.additionalImagePaths,
    ));
  }

  Future<void> _onDraftSaveRequested(
    SubmissionDraftSaveRequested event,
    Emitter<SubmissionFormState> emit,
  ) async {
    final now = DateTime.now();
    final draftId = state.draftId ?? 'draft_${now.millisecondsSinceEpoch}';

    final draft = DraftSubmission(
      id: draftId,
      title: state.title,
      description: state.description,
      city: state.city,
      coverImagePath: state.coverImagePath,
      additionalImagePaths: state.additionalImagePaths,
      createdAt: now,
      updatedAt: now,
    );

    await _draftLocalDataSource.saveDraft(draft);

    emit(state.copyWith(
      draftId: draftId,
      isDraftSaved: true,
    ));
  }

  Future<void> _onDraftDeleteRequested(
    SubmissionDraftDeleteRequested event,
    Emitter<SubmissionFormState> emit,
  ) async {
    if (state.draftId != null) {
      await _draftLocalDataSource.deleteDraft(state.draftId!);
    }
    emit(const SubmissionFormState());
  }

  void _onFormReset(
    SubmissionFormReset event,
    Emitter<SubmissionFormState> emit,
  ) {
    emit(const SubmissionFormState());
  }

  /// Validates the form and returns a state with errors, or null if valid.
  SubmissionFormState? _validate() {
    String? titleError;
    String? descriptionError;
    String? cityError;
    String? coverImageError;

    if (state.title.trim().isEmpty) {
      titleError = 'Title is required';
    } else if (state.title.trim().length > 200) {
      titleError = 'Title must be 200 characters or less';
    }

    if (state.description.trim().isEmpty) {
      descriptionError = 'Description is required';
    } else if (state.description.trim().length > 5000) {
      descriptionError = 'Description must be 5000 characters or less';
    }

    if (state.city.isEmpty) {
      cityError = 'City is required';
    }

    if (state.coverImagePath == null) {
      coverImageError = 'Cover image is required';
    }

    if (titleError != null ||
        descriptionError != null ||
        cityError != null ||
        coverImageError != null) {
      return state.copyWith(
        titleError: titleError,
        descriptionError: descriptionError,
        cityError: cityError,
        coverImageError: coverImageError,
      );
    }

    return null;
  }

  /// Whether the form has unsaved content.
  bool get hasUnsavedContent {
    return state.title.isNotEmpty ||
        state.description.isNotEmpty ||
        state.city.isNotEmpty ||
        state.coverImagePath != null ||
        state.additionalImagePaths.isNotEmpty;
  }

  static const _allowedExtensions = {'jpg', 'jpeg', 'png', 'webp'};
}
