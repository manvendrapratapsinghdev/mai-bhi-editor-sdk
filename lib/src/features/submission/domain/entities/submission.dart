import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/entities/user.dart';

part 'submission.freezed.dart';
part 'submission.g.dart';

/// Submission status enum matching the API contract.
enum SubmissionStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('under_review')
  underReview,
  @JsonValue('published')
  published,
  @JsonValue('rejected')
  rejected,
}

/// Domain entity for a citizen news submission.
@freezed
abstract class Submission with _$Submission {
  const factory Submission({
    required String id,
    required String title,
    required String description,
    required String city,
    @Default(SubmissionStatus.inProgress) SubmissionStatus status,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    UserProfile? creator,
  }) = _Submission;

  factory Submission.fromJson(Map<String, dynamic> json) =>
      _$SubmissionFromJson(json);
}
