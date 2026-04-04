// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editorial_queue_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EditorialQueueItem _$EditorialQueueItemFromJson(Map<String, dynamic> json) =>
    _EditorialQueueItem(
      submission: SubmissionDetail.fromJson(
        json['submission'] as Map<String, dynamic>,
      ),
      aiConfidence: (json['ai_confidence'] as num?)?.toDouble() ?? 0.0,
      communityConfirmations:
          (json['community_confirmations'] as num?)?.toInt() ?? 0,
      priorityRank: (json['priority_rank'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$EditorialQueueItemToJson(_EditorialQueueItem instance) =>
    <String, dynamic>{
      'submission': instance.submission,
      'ai_confidence': instance.aiConfidence,
      'community_confirmations': instance.communityConfirmations,
      'priority_rank': instance.priorityRank,
    };
