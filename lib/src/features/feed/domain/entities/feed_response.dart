import 'package:freezed_annotation/freezed_annotation.dart';

import 'feed_item.dart';

part 'feed_response.freezed.dart';
part 'feed_response.g.dart';

/// Paginated response for GET /feed.
@freezed
abstract class FeedResponse with _$FeedResponse {
  const factory FeedResponse({
    @Default([]) List<FeedItem> stories,
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _FeedResponse;

  factory FeedResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedResponseFromJson(json);
}
