import 'package:freezed_annotation/freezed_annotation.dart';

part 'submission_create_model.freezed.dart';
part 'submission_create_model.g.dart';

/// Request body for POST /submissions (JSON fields only;
/// images are sent as multipart separately).
@freezed
abstract class SubmissionCreate with _$SubmissionCreate {
  const factory SubmissionCreate({
    required String title,
    required String description,
    required String city,
    @Default([]) List<String> tags,
  }) = _SubmissionCreate;

  factory SubmissionCreate.fromJson(Map<String, dynamic> json) =>
      _$SubmissionCreateFromJson(json);
}
