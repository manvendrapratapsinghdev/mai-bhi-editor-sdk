import 'auth_status.dart';

/// Abstract authentication contract that the host app must implement.
///
/// The SDK never stores tokens or manages login itself. All authentication
/// is delegated to the host app via this interface.
///
/// ## Example Implementation
///
/// ```dart
/// class MyAuthProvider implements AuthProvider {
///   final FlutterSecureStorage _storage;
///   final _statusController = StreamController<AuthStatus>.broadcast();
///   AuthStatus _authStatus = AuthStatus.unknown;
///   MbeUser? _currentUser;
///
///   @override
///   AuthStatus get authStatus => _authStatus;
///
///   @override
///   MbeUser? get currentUser => _currentUser;
///
///   @override
///   Stream<AuthStatus> get authStatusStream => _statusController.stream;
///
///   @override
///   Future<String?> getAccessToken() async {
///     return await _storage.read(key: 'access_token');
///   }
///
///   @override
///   Future<String?> refreshToken() async {
///     // Call your refresh endpoint, return new access token or null
///   }
///
///   @override
///   Future<bool> requestLogin() async {
///     // Show your login UI, return true if user logged in successfully
///     return false;
///   }
///
///   @override
///   Future<void> logout() async {
///     await _storage.deleteAll();
///     _authStatus = AuthStatus.unauthenticated;
///     _currentUser = null;
///     _statusController.add(AuthStatus.unauthenticated);
///   }
/// }
/// ```
abstract class AuthProvider {
  /// Current access token, or null if unauthenticated.
  ///
  /// Called by the SDK's Dio interceptor before every API request.
  Future<String?> getAccessToken();

  /// Attempt to refresh the access token.
  ///
  /// Called when the SDK receives a 401 response. Return the new access
  /// token on success, or null to trigger [requestLogin].
  Future<String?> refreshToken();

  /// Current authentication status (synchronous).
  ///
  /// Must be synchronous because GoRouter's redirect callback is synchronous.
  /// The host app should keep a cached auth state in memory.
  AuthStatus get authStatus;

  /// Current user profile, or null if not authenticated.
  MbeUser? get currentUser;

  /// Stream that emits when auth status changes.
  ///
  /// The SDK listens to this to update navigation guards and UI state.
  Stream<AuthStatus> get authStatusStream;

  /// Request the host app to present its login UI.
  ///
  /// Called when the SDK encounters a 401 that cannot be resolved by
  /// token refresh, or when the user taps a login-required action.
  /// Returns `true` if the user successfully logged in, `false` if
  /// the login was cancelled or failed. The SDK uses this to resume
  /// the interrupted action on success.
  Future<bool> requestLogin();

  /// Request the host app to log the user out.
  ///
  /// Called when the user taps "logout" inside an SDK screen.
  Future<void> logout();
}
