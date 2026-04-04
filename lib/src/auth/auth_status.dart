/// Authentication status for the SDK.
enum AuthStatus {
  /// User is authenticated with valid credentials.
  authenticated,

  /// User is not authenticated.
  unauthenticated,

  /// Auth state is not yet determined (e.g., loading cached tokens).
  unknown,
}

/// Minimal user model required by the SDK.
///
/// The host app maps its own user model to this. The SDK uses it for
/// displaying profile information, checking admin access, and personalizing UI.
class MbeUser {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? city;
  final String creatorLevel;
  final int reputationPoints;
  final int storiesPublished;
  final List<String> badges;

  const MbeUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.city,
    this.creatorLevel = 'basic_creator',
    this.reputationPoints = 0,
    this.storiesPublished = 0,
    this.badges = const [],
  });

  bool get isAdmin => badges.contains('admin');
}
