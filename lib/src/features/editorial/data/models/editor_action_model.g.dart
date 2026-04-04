// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editor_action_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EditorAction _$EditorActionFromJson(Map<String, dynamic> json) =>
    _EditorAction(
      action: $enumDecode(_$EditorActionTypeEnumMap, json['action']),
      editedTitle: json['edited_title'] as String?,
      editedDescription: json['edited_description'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      correctionNotes: json['correction_notes'] as String?,
    );

Map<String, dynamic> _$EditorActionToJson(_EditorAction instance) =>
    <String, dynamic>{
      'action': _$EditorActionTypeEnumMap[instance.action]!,
      'edited_title': instance.editedTitle,
      'edited_description': instance.editedDescription,
      'rejection_reason': instance.rejectionReason,
      'correction_notes': instance.correctionNotes,
    };

const _$EditorActionTypeEnumMap = {
  EditorActionType.approve: 'approve',
  EditorActionType.edit: 'edit',
  EditorActionType.reject: 'reject',
  EditorActionType.markCorrection: 'mark_correction',
};
