import 'dart:async';

import 'package:dio/dio.dart';

import '../auth/auth_provider.dart';

/// Dio interceptor that attaches the auth token from [AuthProvider]
/// and handles 401 responses with token refresh.
///
/// Uses a [Completer]-based queue so that concurrent 401 responses share
/// a single refresh attempt instead of racing, while keeping [onRequest]
/// non-blocking so parallel API calls aren't serialized.
class MbeAuthInterceptor extends Interceptor {
  final AuthProvider _authProvider;
  final Dio _dio;

  /// Completer that is non-null while a token refresh is in flight.
  /// Concurrent 401 handlers await this instead of starting their own refresh.
  Completer<String?>? _refreshCompleter;

  MbeAuthInterceptor({
    required AuthProvider authProvider,
    required Dio dio,
  })  : _authProvider = authProvider,
        _dio = dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _authProvider.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    try {
      final newToken = await _refreshOrWait();
      if (newToken != null) {
        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] = 'Bearer $newToken';
        final response = await _dio.fetch(retryOptions);
        handler.resolve(response);
        return;
      } else {
        // Notify host app that login is needed; ignore result here
        // since we can't retry inline after a full login flow.
        _authProvider.requestLogin();
      }
    } catch (_) {
      // Refresh failed — fall through to the error handler.
    }
    handler.next(err);
  }

  /// If a refresh is already in flight, await it. Otherwise start one.
  Future<String?> _refreshOrWait() {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String?>();

    _authProvider.refreshToken().then((token) {
      _refreshCompleter?.complete(token);
    }).catchError((Object error) {
      _refreshCompleter?.completeError(error);
    }).whenComplete(() {
      _refreshCompleter = null;
    });

    return _refreshCompleter!.future;
  }
}
