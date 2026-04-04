import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirmation_result.freezed.dart';
part 'confirmation_result.g.dart';

/// Response from POST /stories/{id}/confirm.
@freezed
abstract class ConfirmationResult with _$ConfirmationResult {
  const factory ConfirmationResult({
    @JsonKey(name: 'story_id') required String storyId,
    @JsonKey(name: 'total_confirmations') @Default(0) int totalConfirmations,
    @Default(false) bool confirmed,
  }) = _ConfirmationResult;

  factory ConfirmationResult.fromJson(Map<String, dynamic> json) =>
      _$ConfirmationResultFromJson(json);
}
