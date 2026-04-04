import 'package:equatable/equatable.dart';

/// Category of a notification, determining its icon and colour.
enum NotificationCategory {
  storyApproved,
  storyRejected,
  correctionNeeded,
  milestone,
  badge,
  trending,
  communityConfirmation,
  general,
}

/// Domain entity representing a single push notification.
class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final NotificationCategory category;
  final bool isRead;
  final DateTime createdAt;

  /// Optional deep-link target (e.g. story ID).
  final String? targetId;

  /// Optional target type for routing (e.g. 'story', 'profile').
  final String? targetType;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.isRead,
    required this.createdAt,
    this.targetId,
    this.targetType,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    NotificationCategory? category,
    bool? isRead,
    DateTime? createdAt,
    String? targetId,
    String? targetType,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
    );
  }

  /// Parse a notification category from a server string.
  static NotificationCategory parseCategory(String? value) {
    switch (value) {
      case 'story_approved':
        return NotificationCategory.storyApproved;
      case 'story_rejected':
        return NotificationCategory.storyRejected;
      case 'correction_needed':
        return NotificationCategory.correctionNeeded;
      case 'milestone':
        return NotificationCategory.milestone;
      case 'badge':
        return NotificationCategory.badge;
      case 'trending':
        return NotificationCategory.trending;
      case 'community_confirmation':
        return NotificationCategory.communityConfirmation;
      default:
        return NotificationCategory.general;
    }
  }

  /// Convert category to server string.
  static String categoryToString(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.storyApproved:
        return 'story_approved';
      case NotificationCategory.storyRejected:
        return 'story_rejected';
      case NotificationCategory.correctionNeeded:
        return 'correction_needed';
      case NotificationCategory.milestone:
        return 'milestone';
      case NotificationCategory.badge:
        return 'badge';
      case NotificationCategory.trending:
        return 'trending';
      case NotificationCategory.communityConfirmation:
        return 'community_confirmation';
      case NotificationCategory.general:
        return 'general';
    }
  }

  /// Create entity from JSON map.
  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      category: parseCategory(json['category'] as String?),
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      targetId: json['target_id'] as String?,
      targetType: json['target_type'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        category,
        isRead,
        createdAt,
        targetId,
        targetType,
      ];
}

/// Preferences for which notification categories are enabled.
class NotificationPreferences extends Equatable {
  final bool storyUpdates;
  final bool milestonesBadges;
  final bool trendingStories;
  final bool communityActivity;

  const NotificationPreferences({
    this.storyUpdates = true,
    this.milestonesBadges = true,
    this.trendingStories = true,
    this.communityActivity = true,
  });

  NotificationPreferences copyWith({
    bool? storyUpdates,
    bool? milestonesBadges,
    bool? trendingStories,
    bool? communityActivity,
  }) {
    return NotificationPreferences(
      storyUpdates: storyUpdates ?? this.storyUpdates,
      milestonesBadges: milestonesBadges ?? this.milestonesBadges,
      trendingStories: trendingStories ?? this.trendingStories,
      communityActivity: communityActivity ?? this.communityActivity,
    );
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      storyUpdates: json['story_updates'] as bool? ?? true,
      milestonesBadges: json['milestones_badges'] as bool? ?? true,
      trendingStories: json['trending_stories'] as bool? ?? true,
      communityActivity: json['community_activity'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'story_updates': storyUpdates,
      'milestones_badges': milestonesBadges,
      'trending_stories': trendingStories,
      'community_activity': communityActivity,
    };
  }

  @override
  List<Object?> get props => [
        storyUpdates,
        milestonesBadges,
        trendingStories,
        communityActivity,
      ];
}
