/// Backwards-compatible shim for [AuthInterceptor].
///
/// The auth feature's repository implementation references this class.
/// In the SDK, authentication is delegated to the host app's [AuthProvider],
/// so these operations are no-ops — the host manages token persistence.
class AuthInterceptor {
  /// No-op in SDK context. Host app manages token storage.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {}

  /// No-op in SDK context. Host app manages token storage.
  Future<void> clearTokens() async {}

  /// Always returns null in SDK context. Use AuthProvider.getAccessToken().
  Future<String?> getAccessToken() async => null;
}
