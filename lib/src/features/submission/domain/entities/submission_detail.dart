import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/entities/user.dart';
import 'ai_review_result.dart';
import 'submission.dart';

part 'submission_detail.freezed.dart';
part 'submission_detail.g.dart';

/// Extended submission with AI review data and editor notes.
/// Maps to the SubmissionDetail schema (allOf Submission + extra fields).
@freezed
abstract class SubmissionDetail with _$SubmissionDetail {
  const factory SubmissionDetail({
    required String id,
    required String title,
    required String description,
    required String city,
    @Default(SubmissionStatus.inProgress) SubmissionStatus status,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    UserProfile? creator,
    @JsonKey(name: 'original_text') String? originalText,
    @JsonKey(name: 'ai_rewritten_text') String? aiRewrittenText,
    @JsonKey(name: 'ai_review') AIReviewResult? aiReview,
    @JsonKey(name: 'additional_images') @Default([]) List<String> additionalImages,
    @JsonKey(name: 'editor_notes') String? editorNotes,
  }) = _SubmissionDetail;

  factory SubmissionDetail.fromJson(Map<String, dynamic> json) =>
      _$SubmissionDetailFromJson(json);
}
