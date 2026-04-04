import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../submission/domain/entities/submission_detail.dart';

part 'editorial_queue_item.freezed.dart';
part 'editorial_queue_item.g.dart';

/// A single item in the editor review queue.
@freezed
abstract class EditorialQueueItem with _$EditorialQueueItem {
  const factory EditorialQueueItem({
    required SubmissionDetail submission,
    @JsonKey(name: 'ai_confidence') @Default(0.0) double aiConfidence,
    @JsonKey(name: 'community_confirmations') @Default(0) int communityConfirmations,
    @JsonKey(name: 'priority_rank') @Default(0) int priorityRank,
  }) = _EditorialQueueItem;

  factory EditorialQueueItem.fromJson(Map<String, dynamic> json) =>
      _$EditorialQueueItemFromJson(json);
}
