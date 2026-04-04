import 'package:dio/dio.dart';

import '../core/error/exceptions.dart';

/// Maps Dio errors into domain-level exceptions so callers don't need
/// to depend on Dio types.
class ErrorMappingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        throw const NetworkException(
          message: 'Connection timed out. Check your internet.',
        );

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final data = err.response?.data;

        if (statusCode == 429) {
          final retryAfter = int.tryParse(
            err.response?.headers.value('retry-after') ?? '',
          );
          throw RateLimitException(retryAfterSeconds: retryAfter);
        }

        final message =
            _extractMessage(data) ?? 'Unexpected error (HTTP $statusCode)';

        throw ServerException(
          message: message,
          statusCode: statusCode,
        );

      default:
        handler.next(err);
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail is String) return detail;
      if (detail is List) {
        return detail
            .map((e) => e is Map ? e['msg'] ?? e.toString() : e.toString())
            .join('; ');
      }
      final message = data['message'];
      if (message is String) return message;
      final error = data['error'];
      if (error is String) return error;
    }
    return null;
  }
}
