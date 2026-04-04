import '../../domain/entities/kyc_status.dart';
import '../../domain/repositories/kyc_repository.dart';
import '../datasources/kyc_remote_datasource.dart';

/// Concrete implementation of [KycRepository].
class KycRepositoryImpl implements KycRepository {
  final KycRemoteDataSource _remoteDataSource;

  const KycRepositoryImpl({
    required KycRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<KycVerificationStatus> getKycStatus() {
    return _remoteDataSource.getKycStatus();
  }

  @override
  Future<void> uploadDocument({
    required KycDocumentType documentType,
    required String filePath,
    void Function(double progress)? onProgress,
  }) {
    return _remoteDataSource.uploadDocument(
      documentType: documentType,
      filePath: filePath,
      onProgress: onProgress,
    );
  }
}
