part of 'kyc_bloc.dart';

/// Events for the KYC BLoC.
abstract class KycEvent extends Equatable {
  const KycEvent();

  @override
  List<Object?> get props => [];
}

/// Load the current KYC verification status.
class KycStatusRequested extends KycEvent {
  const KycStatusRequested();
}

/// User selected a document type.
class KycDocumentTypeChanged extends KycEvent {
  final KycDocumentType documentType;

  const KycDocumentTypeChanged(this.documentType);

  @override
  List<Object?> get props => [documentType];
}

/// User picked an image file for upload.
class KycImagePicked extends KycEvent {
  final String filePath;

  const KycImagePicked(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

/// User tapped the upload button.
class KycUploadRequested extends KycEvent {
  const KycUploadRequested();
}
