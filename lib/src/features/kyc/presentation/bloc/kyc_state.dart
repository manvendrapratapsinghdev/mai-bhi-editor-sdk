part of 'kyc_bloc.dart';

/// States for the KYC BLoC.
class KycState extends Equatable {
  /// Current verification status from the server.
  final KycVerificationStatus verificationStatus;

  /// Whether we are loading the initial status.
  final bool isLoadingStatus;

  /// Selected document type.
  final KycDocumentType selectedDocumentType;

  /// Path to the picked image file, or null if none.
  final String? pickedFilePath;

  /// Whether an upload is in progress.
  final bool isUploading;

  /// Upload progress from 0.0 to 1.0.
  final double uploadProgress;

  /// Error message, or null.
  final String? errorMessage;

  /// Success message, or null.
  final String? successMessage;

  const KycState({
    this.verificationStatus = KycVerificationStatus.none,
    this.isLoadingStatus = false,
    this.selectedDocumentType = KycDocumentType.aadhaar,
    this.pickedFilePath,
    this.isUploading = false,
    this.uploadProgress = 0.0,
    this.errorMessage,
    this.successMessage,
  });

  KycState copyWith({
    KycVerificationStatus? verificationStatus,
    bool? isLoadingStatus,
    KycDocumentType? selectedDocumentType,
    String? pickedFilePath,
    bool clearPickedFile = false,
    bool? isUploading,
    double? uploadProgress,
    String? errorMessage,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
  }) {
    return KycState(
      verificationStatus: verificationStatus ?? this.verificationStatus,
      isLoadingStatus: isLoadingStatus ?? this.isLoadingStatus,
      selectedDocumentType: selectedDocumentType ?? this.selectedDocumentType,
      pickedFilePath:
          clearPickedFile ? null : (pickedFilePath ?? this.pickedFilePath),
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  /// Whether the user has already submitted KYC (pending or approved).
  bool get hasSubmitted =>
      verificationStatus == KycVerificationStatus.pending ||
      verificationStatus == KycVerificationStatus.approved;

  @override
  List<Object?> get props => [
        verificationStatus,
        isLoadingStatus,
        selectedDocumentType,
        pickedFilePath,
        isUploading,
        uploadProgress,
        errorMessage,
        successMessage,
      ];
}
