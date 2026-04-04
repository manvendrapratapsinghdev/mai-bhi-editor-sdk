import 'package:freezed_annotation/freezed_annotation.dart';

part 'editor_action_model.freezed.dart';
part 'editor_action_model.g.dart';

/// Editor action type enum matching the API contract.
enum EditorActionType {
  @JsonValue('approve')
  approve,
  @JsonValue('edit')
  edit,
  @JsonValue('reject')
  reject,
  @JsonValue('mark_correction')
  markCorrection,
}

/// Request body for POST /editorial/{id}/action.
@freezed
abstract class EditorAction with _$EditorAction {
  const factory EditorAction({
    required EditorActionType action,
    @JsonKey(name: 'edited_title') String? editedTitle,
    @JsonKey(name: 'edited_description') String? editedDescription,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
    @JsonKey(name: 'correction_notes') String? correctionNotes,
  }) = _EditorAction;

  factory EditorAction.fromJson(Map<String, dynamic> json) =>
      _$EditorActionFromJson(json);
}
