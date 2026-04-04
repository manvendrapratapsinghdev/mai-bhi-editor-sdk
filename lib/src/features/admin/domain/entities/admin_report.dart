import 'package:equatable/equatable.dart';

/// A content report pending admin review.
class AdminReport extends Equatable {
  final String id;
  final String storyId;
  final String storyTitle;
  final String reporterName;
  final String reason;
  final DateTime reportedAt;
  final String status; // 'pending', 'dismissed', 'actioned'
  final String? storyContent;

  const AdminReport({
    required this.id,
    required this.storyId,
    required this.storyTitle,
    required this.reporterName,
    required this.reason,
    required this.reportedAt,
    this.status = 'pending',
    this.storyContent,
  });

  factory AdminReport.fromJson(Map<String, dynamic> json) {
    return AdminReport(
      id: json['id'] as String,
      storyId: json['story_id'] as String,
      storyTitle: json['story_title'] as String? ?? 'Untitled',
      reporterName: json['reporter_name'] as String? ?? 'Unknown',
      reason: json['reason'] as String? ?? 'No reason provided',
      reportedAt: DateTime.parse(json['reported_at'] as String),
      status: json['status'] as String? ?? 'pending',
      storyContent: json['story_content'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        storyId,
        storyTitle,
        reporterName,
        reason,
        reportedAt,
        status,
        storyContent,
      ];
}
