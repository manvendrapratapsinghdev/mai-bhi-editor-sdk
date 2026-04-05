import 'package:dio/dio.dart';

import '../auth/auth_provider.dart';
import 'error_mapping_interceptor.dart';
import 'mbe_auth_interceptor.dart';

/// Factory that produces a configured [Dio] instance for the SDK.
///
/// Uses the host-provided [baseUrl] and [AuthProvider] for authentication.
class MbeApiClient {
  MbeApiClient._();

  static Dio? _dio;
  static MbeAuthInterceptor? _authInterceptor;

  /// Initialise the API client. Call once during SDK bootstrap.
  static Dio init({
    required String baseUrl,
    required AuthProvider authProvider,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 15),
    Duration sendTimeout = const Duration(seconds: 30),
  }) {
    if (_dio != null) return _dio!;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        sendTimeout: sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _authInterceptor = MbeAuthInterceptor(
      authProvider: authProvider,
    );

    _dio!.interceptors.addAll([
      _authInterceptor!,
      ErrorMappingInterceptor(),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) {
          assert(() {
            // ignore: avoid_print
            print(obj);
            return true;
          }());
        },
      ),
    ]);

    return _dio!;
  }

  /// Return the existing instance (must call [init] first).
  static Dio get instance {
    if (_dio == null) {
      throw StateError('MbeApiClient.init() has not been called. '
          'Call MaiBhiEditor.initialize() first.');
    }
    return _dio!;
  }

  /// Reset for testing.
  static void reset() {
    _dio = null;
    _authInterceptor = null;
  }
}
