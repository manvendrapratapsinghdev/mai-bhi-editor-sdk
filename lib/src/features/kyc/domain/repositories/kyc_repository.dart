import '../entities/kyc_status.dart';

/// Abstract contract for KYC operations.
abstract class KycRepository {
  /// Get the current KYC verification status.
  Future<KycVerificationStatus> getKycStatus();

  /// Upload a KYC document.
  ///
  /// [documentType] — type of ID document.
  /// [filePath] — local path to the document image.
  /// [onProgress] — optional callback for upload progress (0.0 to 1.0).
  Future<void> uploadDocument({
    required KycDocumentType documentType,
    required String filePath,
    void Function(double progress)? onProgress,
  });
}
