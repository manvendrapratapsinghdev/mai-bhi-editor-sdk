import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../community/domain/entities/creator_profile.dart';

part 'story_detail.freezed.dart';
part 'story_detail.g.dart';

/// Full story detail returned from GET /feed/{id}.
@freezed
abstract class StoryDetail with _$StoryDetail {
  const factory StoryDetail({
    required String id,
    required String title,
    required String description,
    @Default([]) List<String> images,
    CreatorProfile? creator,
    @JsonKey(name: 'editor_verified') @Default(false) bool editorVerified,
    @JsonKey(name: 'ai_verified') @Default(false) bool aiVerified,
    @JsonKey(name: 'editor_name') String? editorName,
    @Default(0) int likes,
    @Default(0) int confirmations,
    String? city,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
    @JsonKey(name: 'user_has_confirmed') @Default(false) bool userHasConfirmed,
    @JsonKey(name: 'user_has_liked') @Default(false) bool userHasLiked,
  }) = _StoryDetail;

  factory StoryDetail.fromJson(Map<String, dynamic> json) =>
      _$StoryDetailFromJson(json);
}
