// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirmation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConfirmationResult _$ConfirmationResultFromJson(Map<String, dynamic> json) =>
    _ConfirmationResult(
      storyId: json['story_id'] as String,
      totalConfirmations: (json['total_confirmations'] as num?)?.toInt() ?? 0,
      confirmed: json['confirmed'] as bool? ?? false,
    );

Map<String, dynamic> _$ConfirmationResultToJson(_ConfirmationResult instance) =>
    <String, dynamic>{
      'story_id': instance.storyId,
      'total_confirmations': instance.totalConfirmations,
      'confirmed': instance.confirmed,
    };
