part of 'submission_form_bloc.dart';

/// State for the submission form BLoC.
class SubmissionFormState extends Equatable {
  /// Optional draft ID if editing a saved draft.
  final String? draftId;

  /// Title field value.
  final String title;

  /// Description field value.
  final String description;

  /// Selected city.
  final String city;

  /// Path to the selected cover image.
  final String? coverImagePath;

  /// Paths to additional images (up to 9).
  final List<String> additionalImagePaths;

  /// Whether the form is being submitted.
  final bool isSubmitting;

  /// Whether submission was successful.
  final bool isSuccess;

  /// Whether the draft was saved successfully.
  final bool isDraftSaved;

  /// Inline validation error for the title field.
  final String? titleError;

  /// Inline validation error for the description field.
  final String? descriptionError;

  /// Inline validation error for the city field.
  final String? cityError;

  /// Inline validation error for the cover image.
  final String? coverImageError;

  /// General error message.
  final String? errorMessage;

  const SubmissionFormState({
    this.draftId,
    this.title = '',
    this.description = '',
    this.city = '',
    this.coverImagePath,
    this.additionalImagePaths = const [],
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isDraftSaved = false,
    this.titleError,
    this.descriptionError,
    this.cityError,
    this.coverImageError,
    this.errorMessage,
  });

  SubmissionFormState copyWith({
    String? draftId,
    String? title,
    String? description,
    String? city,
    String? coverImagePath,
    bool clearCoverImage = false,
    List<String>? additionalImagePaths,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isDraftSaved,
    String? titleError,
    String? descriptionError,
    String? cityError,
    String? coverImageError,
    String? errorMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return SubmissionFormState(
      draftId: draftId ?? this.draftId,
      title: title ?? this.title,
      description: description ?? this.description,
      city: city ?? this.city,
      coverImagePath: clearCoverImage
          ? null
          : (coverImagePath ?? this.coverImagePath),
      additionalImagePaths:
          additionalImagePaths ?? this.additionalImagePaths,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: clearSuccess ? false : (isSuccess ?? this.isSuccess),
      isDraftSaved: clearSuccess ? false : (isDraftSaved ?? this.isDraftSaved),
      titleError: titleError,
      descriptionError: descriptionError,
      cityError: cityError,
      coverImageError: coverImageError,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  /// Total number of images including cover.
  int get totalImageCount =>
      (coverImagePath != null ? 1 : 0) + additionalImagePaths.length;

  /// Whether the form has content worth saving.
  bool get hasContent =>
      title.isNotEmpty ||
      description.isNotEmpty ||
      city.isNotEmpty ||
      coverImagePath != null ||
      additionalImagePaths.isNotEmpty;

  @override
  List<Object?> get props => [
        draftId,
        title,
        description,
        city,
        coverImagePath,
        additionalImagePaths,
        isSubmitting,
        isSuccess,
        isDraftSaved,
        titleError,
        descriptionError,
        cityError,
        coverImageError,
        errorMessage,
      ];
}
