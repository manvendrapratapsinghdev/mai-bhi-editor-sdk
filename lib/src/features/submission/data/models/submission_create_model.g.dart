// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_create_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubmissionCreate _$SubmissionCreateFromJson(Map<String, dynamic> json) =>
    _SubmissionCreate(
      title: json['title'] as String,
      description: json['description'] as String,
      city: json['city'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
    );

Map<String, dynamic> _$SubmissionCreateToJson(_SubmissionCreate instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'city': instance.city,
      'tags': instance.tags,
    };
