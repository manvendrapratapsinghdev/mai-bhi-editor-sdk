import 'auth_status.dart';

/// Abstract authentication contract that the host app must implement.
///
/// The SDK never stores tokens or manages login itself. All authentication
/// is delegated to the host app via this interface.
///
/// ## Auth header contract
///
/// On every outbound HTTP request the SDK calls [getAuthHeaders] and
/// forwards the returned map verbatim. The host app is expected to return
/// the Hindustan Times auth triple:
///
/// ```
/// Authorization: <ht_user_token>   // raw HT token, NOT "Bearer ..."
/// X-Client:      1006
/// X-Platform:    Android | iOS
/// ```
///
/// If the user is not authenticated, return an empty map.
///
/// The SDK never attempts to refresh tokens. On a 401 response it calls
/// [requestLogin] so the host can re-acquire a token from the HT app.
///
/// ## Example Implementation
///
/// ```dart
/// class MyAuthProvider implements AuthProvider {
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
///   Future<Map<String, String>> getAuthHeaders() async {
///     final token = await _readHtToken();
///     if (token == null || token.isEmpty) return const {};
///     return {
///       'Authorization': token,
///       'X-Client': '1006',
///       'X-Platform': Platform.isIOS ? 'iOS' : 'Android',
///     };
///   }
///
///   @override
///   Future<bool> requestLogin() async {
///     // Hand off to the HT app to re-acquire a token.
///     return false;
///   }
///
///   @override
///   Future<void> logout() async {
///     _authStatus = AuthStatus.unauthenticated;
///     _currentUser = null;
///     _statusController.add(AuthStatus.unauthenticated);
///   }
/// }
/// ```
abstract class AuthProvider {
  /// Auth headers to attach to every outbound SDK HTTP request.
  ///
  /// Must return a map containing `Authorization`, `X-Client`, and
  /// `X-Platform`. Return an empty map if the user is unauthenticated —
  /// the SDK will still send the request and let the backend reject it.
  ///
  /// The SDK forwards the returned map verbatim; do NOT prepend `Bearer `.
  Future<Map<String, String>> getAuthHeaders();

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
  /// Called when the SDK receives a 401, or when the user taps a
  /// login-required action. The host is expected to re-acquire a token
  /// from the HT app. Returns `true` if the user is now authenticated,
  /// `false` if the login was cancelled or failed.
  Future<bool> requestLogin();

  /// Request the host app to log the user out.
  ///
  /// Called when the user taps "logout" inside an SDK screen.
  Future<void> logout();
}
