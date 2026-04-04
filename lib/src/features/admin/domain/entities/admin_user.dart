import 'package:equatable/equatable.dart';

/// A user record as seen in the admin panel.
class AdminUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String creatorLevel;
  final int reputationPoints;
  final int storiesCount;
  final String status; // 'active', 'flagged', 'suspended', 'pending_deletion'
  final DateTime? suspendedUntil;

  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    this.creatorLevel = 'basic_creator',
    this.reputationPoints = 0,
    this.storiesCount = 0,
    this.status = 'active',
    this.suspendedUntil,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown',
      email: json['email'] as String? ?? '',
      creatorLevel: json['creator_level'] as String? ?? 'basic_creator',
      reputationPoints: json['reputation_points'] as int? ?? 0,
      storiesCount: json['stories_count'] as int? ?? 0,
      status: json['status'] as String? ?? 'active',
      suspendedUntil: json['suspended_until'] != null
          ? DateTime.tryParse(json['suspended_until'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        creatorLevel,
        reputationPoints,
        storiesCount,
        status,
        suspendedUntil,
      ];
}
