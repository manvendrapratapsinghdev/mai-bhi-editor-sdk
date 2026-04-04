import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/kyc_status.dart';

/// Remote data source for KYC endpoints.
abstract class KycRemoteDataSource {
  Future<KycVerificationStatus> getKycStatus();
  Future<void> uploadDocument({
    required KycDocumentType documentType,
    required String filePath,
    void Function(double progress)? onProgress,
  });
}

class KycRemoteDataSourceImpl implements KycRemoteDataSource {
  final Dio _dio;

  const KycRemoteDataSourceImpl(this._dio);

  @override
  Future<KycVerificationStatus> getKycStatus() async {
    try {
      final response = await _dio.get('/auth/kyc/status');
      final data = response.data as Map<String, dynamic>;
      final status = data['status'] as String? ?? 'none';
      return _parseStatus(status);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // No KYC submission found.
        return KycVerificationStatus.none;
      }
      throw ServerException(
        message: e.message ?? 'Failed to fetch KYC status',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> uploadDocument({
    required KycDocumentType documentType,
    required String filePath,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        'document_type': documentType.apiValue,
        'document': await MultipartFile.fromFile(
          filePath,
          filename: '${documentType.apiValue}_document.jpg',
        ),
      });

      await _dio.post(
        '/auth/kyc/upload',
        data: formData,
        onSendProgress: (sent, total) {
          if (total > 0 && onProgress != null) {
            onProgress(sent / total);
          }
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Document upload failed',
        statusCode: e.response?.statusCode,
      );
    }
  }

  KycVerificationStatus _parseStatus(String status) {
    switch (status) {
      case 'pending':
        return KycVerificationStatus.pending;
      case 'approved':
        return KycVerificationStatus.approved;
      case 'rejected':
        return KycVerificationStatus.rejected;
      default:
        return KycVerificationStatus.none;
    }
  }
}
