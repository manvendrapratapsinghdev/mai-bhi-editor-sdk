import 'package:dio/dio.dart';

import '../auth/auth_provider.dart';

/// Dio interceptor that attaches host-provided auth headers to every
/// outbound request and notifies the host on 401 responses.
///
/// The SDK does not store tokens or attempt refresh — on 401 it calls
/// [AuthProvider.requestLogin] so the host can re-acquire a token from
/// the HT app, then forwards the error.
class MbeAuthInterceptor extends Interceptor {
  final AuthProvider _authProvider;

  MbeAuthInterceptor({
    required AuthProvider authProvider,
  }) : _authProvider = authProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final headers = await _authProvider.getAuthHeaders();
    headers.forEach((key, value) {
      options.headers[key] = value;
    });
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Notify the host that login is needed. Fire-and-forget — the SDK
      // cannot retry inline because HT re-auth is handled outside the SDK.
      // Swallow any errors from the host's implementation.
      try {
        await _authProvider.requestLogin();
      } catch (_) {
        // Ignore: we still want to surface the original 401 to the caller.
      }
    }
    handler.next(err);
  }
}
