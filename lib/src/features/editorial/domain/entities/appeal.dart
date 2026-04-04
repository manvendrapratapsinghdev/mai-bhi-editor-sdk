import 'package:equatable/equatable.dart';

/// Appeal status matching the API contract.
enum AppealStatus {
  pending,
  approved,
  rejected,
}

/// Domain entity for a submission appeal.
class Appeal extends Equatable {
  final String id;
  final String submissionId;
  final String justification;
  final AppealStatus status;
  final String? reviewNotes;
  final DateTime? createdAt;
  final DateTime? reviewedAt;

  const Appeal({
    required this.id,
    required this.submissionId,
    required this.justification,
    this.status = AppealStatus.pending,
    this.reviewNotes,
    this.createdAt,
    this.reviewedAt,
  });

  factory Appeal.fromJson(Map<String, dynamic> json) {
    return Appeal(
      id: json['id'] as String,
      submissionId: json['submission_id'] as String,
      justification: json['justification'] as String,
      status: _parseStatus(json['status'] as String?),
      reviewNotes: json['review_notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.tryParse(json['reviewed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'submission_id': submissionId,
        'justification': justification,
        'status': status.name,
        'review_notes': reviewNotes,
        'created_at': createdAt?.toIso8601String(),
        'reviewed_at': reviewedAt?.toIso8601String(),
      };

  static AppealStatus _parseStatus(String? status) {
    switch (status) {
      case 'approved':
        return AppealStatus.approved;
      case 'rejected':
        return AppealStatus.rejected;
      case 'pending':
      default:
        return AppealStatus.pending;
    }
  }

  @override
  List<Object?> get props => [
        id,
        submissionId,
        justification,
        status,
        reviewNotes,
        createdAt,
        reviewedAt,
      ];
}
