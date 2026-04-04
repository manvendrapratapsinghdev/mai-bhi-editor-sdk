import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/submission.dart';

/// Local storage key prefix for drafts.
const String _draftKeyPrefix = 'submission_draft_';

/// Key for the list of all draft IDs.
const String _draftIdsKey = 'submission_draft_ids';

/// A local draft of a submission form before it has been submitted.
class DraftSubmission {
  final String id;
  final String title;
  final String description;
  final String city;
  final String? coverImagePath;
  final List<String> additionalImagePaths;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DraftSubmission({
    required this.id,
    required this.title,
    required this.description,
    required this.city,
    this.coverImagePath,
    this.additionalImagePaths = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert draft to a Submission entity for display in the dashboard.
  Submission toSubmission() {
    return Submission(
      id: id,
      title: title.isNotEmpty ? title : 'Untitled Draft',
      description: description,
      city: city,
      status: SubmissionStatus.draft,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'city': city,
        'cover_image_path': coverImagePath,
        'additional_image_paths': additionalImagePaths,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory DraftSubmission.fromJson(Map<String, dynamic> json) {
    return DraftSubmission(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      city: json['city'] as String? ?? '',
      coverImagePath: json['cover_image_path'] as String?,
      additionalImagePaths: (json['additional_image_paths'] as List<dynamic>?)
              ?.cast<String>() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  DraftSubmission copyWith({
    String? title,
    String? description,
    String? city,
    String? coverImagePath,
    bool clearCoverImage = false,
    List<String>? additionalImagePaths,
    DateTime? updatedAt,
  }) {
    return DraftSubmission(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      city: city ?? this.city,
      coverImagePath:
          clearCoverImage ? null : (coverImagePath ?? this.coverImagePath),
      additionalImagePaths:
          additionalImagePaths ?? this.additionalImagePaths,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

/// Local data source for persisting submission drafts.
abstract class DraftLocalDataSource {
  /// Save or update a draft.
  Future<void> saveDraft(DraftSubmission draft);

  /// Retrieve a specific draft by ID.
  Future<DraftSubmission?> getDraft(String id);

  /// Retrieve all saved drafts, sorted by most recently updated.
  Future<List<DraftSubmission>> getAllDrafts();

  /// Delete a draft by ID.
  Future<void> deleteDraft(String id);

  /// Check if any drafts exist.
  Future<bool> hasDrafts();
}

class DraftLocalDataSourceImpl implements DraftLocalDataSource {
  DraftLocalDataSourceImpl();

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<void> saveDraft(DraftSubmission draft) async {
    final prefs = await _prefs;
    final json = jsonEncode(draft.toJson());
    await prefs.setString('$_draftKeyPrefix${draft.id}', json);

    // Update the draft IDs list.
    final ids = prefs.getStringList(_draftIdsKey) ?? [];
    if (!ids.contains(draft.id)) {
      ids.add(draft.id);
      await prefs.setStringList(_draftIdsKey, ids);
    }
  }

  @override
  Future<DraftSubmission?> getDraft(String id) async {
    final prefs = await _prefs;
    final json = prefs.getString('$_draftKeyPrefix$id');
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return DraftSubmission.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<DraftSubmission>> getAllDrafts() async {
    final prefs = await _prefs;
    final ids = prefs.getStringList(_draftIdsKey) ?? [];
    final drafts = <DraftSubmission>[];

    for (final id in ids) {
      final json = prefs.getString('$_draftKeyPrefix$id');
      if (json != null) {
        try {
          final map = jsonDecode(json) as Map<String, dynamic>;
          drafts.add(DraftSubmission.fromJson(map));
        } catch (_) {
          // Skip corrupt entries.
        }
      }
    }

    // Sort by most recently updated first.
    drafts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return drafts;
  }

  @override
  Future<void> deleteDraft(String id) async {
    final prefs = await _prefs;
    await prefs.remove('$_draftKeyPrefix$id');

    final ids = prefs.getStringList(_draftIdsKey) ?? [];
    ids.remove(id);
    await prefs.setStringList(_draftIdsKey, ids);
  }

  @override
  Future<bool> hasDrafts() async {
    final prefs = await _prefs;
    final ids = prefs.getStringList(_draftIdsKey) ?? [];
    return ids.isNotEmpty;
  }
}
