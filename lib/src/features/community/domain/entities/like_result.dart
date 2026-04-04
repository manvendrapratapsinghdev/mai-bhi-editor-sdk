import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_result.freezed.dart';
part 'like_result.g.dart';

/// Response from POST /stories/{id}/like.
@freezed
abstract class LikeResult with _$LikeResult {
  const factory LikeResult({
    @JsonKey(name: 'story_id') required String storyId,
    @JsonKey(name: 'total_likes') @Default(0) int totalLikes,
    @Default(false) bool liked,
  }) = _LikeResult;

  factory LikeResult.fromJson(Map<String, dynamic> json) =>
      _$LikeResultFromJson(json);
}
