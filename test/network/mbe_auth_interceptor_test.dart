import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_bhi_editor_sdk/mai_bhi_editor.dart';
import 'package:mai_bhi_editor_sdk/src/network/mbe_auth_interceptor.dart';

class _FakeAuthProvider implements AuthProvider {
  _FakeAuthProvider({
    this.headers = const {},
  });

  final Map<String, String> headers;
  int requestLoginCallCount = 0;

  @override
  AuthStatus get authStatus => AuthStatus.authenticated;

  @override
  MbeUser? get currentUser => null;

  @override
  Stream<AuthStatus> get authStatusStream => const Stream.empty();

  @override
  Future<Map<String, String>> getAuthHeaders() async => headers;

  @override
  Future<bool> requestLogin() async {
    requestLoginCallCount += 1;
    return false;
  }

  @override
  Future<void> logout() async {}
}

class _CapturingHandler extends RequestInterceptorHandler {
  RequestOptions? captured;

  @override
  void next(RequestOptions options) {
    captured = options;
  }
}

class _CapturingErrorHandler extends ErrorInterceptorHandler {
  DioException? captured;
  bool resolved = false;

  @override
  void next(DioException err) {
    captured = err;
  }

  @override
  void resolve(Response response, [bool callFollowingResponseInterceptor = false]) {
    resolved = true;
  }
}

void main() {
  group('MbeAuthInterceptor.onRequest', () {
    test('attaches host-provided auth headers verbatim', () async {
      final provider = _FakeAuthProvider(headers: const {
        'Authorization': 'ht-token-abc',
        'X-Client': '1006',
        'X-Platform': 'Android',
      });
      final interceptor = MbeAuthInterceptor(authProvider: provider);

      final options = RequestOptions(path: '/feed');
      final handler = _CapturingHandler();
      await interceptor.onRequest(options, handler);

      expect(handler.captured, isNotNull);
      expect(handler.captured!.headers['Authorization'], 'ht-token-abc');
      expect(handler.captured!.headers['X-Client'], '1006');
      expect(handler.captured!.headers['X-Platform'], 'Android');
    });

    test('does not prepend Bearer to Authorization header', () async {
      final provider = _FakeAuthProvider(headers: const {
        'Authorization': 'raw-token',
        'X-Client': '1006',
        'X-Platform': 'iOS',
      });
      final interceptor = MbeAuthInterceptor(authProvider: provider);

      final options = RequestOptions(path: '/feed');
      final handler = _CapturingHandler();
      await interceptor.onRequest(options, handler);

      expect(
        handler.captured!.headers['Authorization'],
        isNot(startsWith('Bearer ')),
      );
    });

    test('overwrites any pre-existing auth headers on the request', () async {
      final provider = _FakeAuthProvider(headers: const {
        'Authorization': 'new-token',
        'X-Client': '1006',
        'X-Platform': 'Android',
      });
      final interceptor = MbeAuthInterceptor(authProvider: provider);

      final options = RequestOptions(
        path: '/feed',
        headers: {'Authorization': 'stale', 'X-Platform': 'Web'},
      );
      final handler = _CapturingHandler();
      await interceptor.onRequest(options, handler);

      expect(handler.captured!.headers['Authorization'], 'new-token');
      expect(handler.captured!.headers['X-Platform'], 'Android');
    });

    test('empty headers map leaves request untouched', () async {
      final provider = _FakeAuthProvider(headers: const {});
      final interceptor = MbeAuthInterceptor(authProvider: provider);

      final options = RequestOptions(path: '/feed');
      final handler = _CapturingHandler();
      await interceptor.onRequest(options, handler);

      expect(handler.captured!.headers.containsKey('Authorization'), isFalse);
    });
  });

  group('MbeAuthInterceptor.onError', () {
    test('on 401 notifies host via requestLogin and forwards error', () async {
      final provider = _FakeAuthProvider();
      final interceptor = MbeAuthInterceptor(authProvider: provider);

      final options = RequestOptions(path: '/feed');
      final err = DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: 401),
      );
      final handler = _CapturingErrorHandler();
      await interceptor.onError(err, handler);

      expect(provider.requestLoginCallCount, 1);
      expect(handler.resolved, isFalse);
      expect(handler.captured, same(err));
    });

    test('non-401 errors do not trigger requestLogin', () async {
      final provider = _FakeAuthProvider();
      final interceptor = MbeAuthInterceptor(authProvider: provider);

      final options = RequestOptions(path: '/feed');
      final err = DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: 500),
      );
      final handler = _CapturingErrorHandler();
      await interceptor.onError(err, handler);

      expect(provider.requestLoginCallCount, 0);
      expect(handler.captured, same(err));
    });
  });
}
