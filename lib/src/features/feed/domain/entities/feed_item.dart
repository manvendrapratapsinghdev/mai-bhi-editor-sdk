import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_item.freezed.dart';
part 'feed_item.g.dart';

/// A single story card in the news feed.
@freezed
abstract class FeedItem with _$FeedItem {
  const factory FeedItem({
    required String id,
    required String title,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
    @JsonKey(name: 'creator_name') String? creatorName,
    @JsonKey(name: 'creator_level') String? creatorLevel,
    @Default(0) int likes,
    @Default(0) int confirmations,
    String? city,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
  }) = _FeedItem;

  factory FeedItem.fromJson(Map<String, dynamic> json) =>
      _$FeedItemFromJson(json);
}
