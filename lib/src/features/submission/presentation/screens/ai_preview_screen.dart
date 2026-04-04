import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/ai_review_result.dart';
import '../bloc/ai_preview_bloc.dart';

/// Available categories for the category dropdown.
const List<String> _availableCategories = [
  'News',
  'Politics',
  'Sports',
  'Entertainment',
  'Technology',
  'Health',
  'Business',
  'Education',
  'Environment',
  'Crime',
  'Human Interest',
  'Opinion',
  'Local',
  'National',
  'International',
];

/// "Your post corrected by AI" preview screen.
///
/// Implements S3-10: Shows original vs AI-corrected text, safety score,
/// detected language, safety flags, and proceed button.
/// Implements S3-11: AI tag suggestion chips and category dropdown.
class AiPreviewScreen extends StatefulWidget {
  final String submissionId;

  const AiPreviewScreen({super.key, required this.submissionId});

  @override
  State<AiPreviewScreen> createState() => _AiPreviewScreenState();
}

class _AiPreviewScreenState extends State<AiPreviewScreen>
    with SingleTickerProviderStateMixin {
  late AiPreviewBloc _bloc;
  late final AnimationController _pulseController;
  bool _didInit = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      _bloc = context.read<AiPreviewBloc>();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiPreviewBloc, AiPreviewState>(
        listener: (context, state) {
          if (state is AiPreviewLoaded) {
            // Stop pulse animation when loaded.
            _pulseController.stop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Semantics(
                header: true,
                child: const Text('Your post \u2014 corrected by AI'),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back',
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/my-submissions');
                  }
                },
              ),
            ),
            body: _buildBody(context, state),
          );
        },
    );
  }

  Widget _buildBody(BuildContext context, AiPreviewState state) {
    if (state is AiPreviewInitial || state is AiPreviewLoading) {
      return _buildLoadingState(context);
    }

    if (state is AiPreviewProcessing) {
      return _buildProcessingState(context, state);
    }

    if (state is AiPreviewLoaded) {
      return _buildLoadedState(context, state);
    }

    if (state is AiPreviewError) {
      return _buildErrorState(context, state);
    }

    return const SizedBox.shrink();
  }

  // ── Loading State ──────────────────────────────────────────────────────

  Widget _buildLoadingState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading submission...'),
        ],
      ),
    );
  }

  // ── Processing State ───────────────────────────────────────────────────

  Widget _buildProcessingState(
    BuildContext context,
    AiPreviewProcessing state,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _pulseController.drive(
                Tween<double>(begin: 0.3, end: 1.0),
              ),
              child: const Icon(
                Icons.auto_fix_high,
                size: 80,
                color: AppColors.statusUnderReview,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'AI is reviewing your post...',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'This may take a few moments. We are checking grammar, '
              'safety, and generating tag suggestions.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.mediumGrey,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 200,
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Loaded State ───────────────────────────────────────────────────────

  Widget _buildLoadedState(BuildContext context, AiPreviewLoaded state) {
    final theme = Theme.of(context);
    final detail = state.submissionDetail;
    final aiReview = state.aiReview;
    final originalText = detail.originalText ?? detail.description;
    final correctedText =
        aiReview.rewrittenText ?? detail.aiRewrittenText ?? originalText;
    final textsIdentical = originalText.trim() == correctedText.trim();

    return Column(
      children: [
        // Scrollable content.
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Safety flags warning banner ────────────────────────
                if (_hasSafetyFlags(aiReview))
                  _SafetyFlagsBanner(aiReview: aiReview),

                // ── Safety score + language badge row ──────────────────
                _MetadataRow(aiReview: aiReview),
                const SizedBox(height: 16),

                // ── No changes message ─────────────────────────────────
                if (textsIdentical) ...[
                  Semantics(
                    liveRegion: true,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.statusPublishedBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.statusPublished),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.statusPublished,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'No changes needed! Your text looks great.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppColors.statusPublished,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Original Text Panel ────────────────────────────────
                _TextComparisonPanel(
                  label: 'Original',
                  text: originalText,
                  backgroundColor: AppColors.extraLightGrey,
                  labelColor: AppColors.darkGrey,
                  borderColor: AppColors.lightGrey,
                  semanticsLabel: 'Original text',
                ),
                const SizedBox(height: 16),

                // ── AI Corrected Text Panel ────────────────────────────
                _TextComparisonPanel(
                  label: 'AI Corrected',
                  text: correctedText,
                  backgroundColor: AppColors.statusPublishedBg,
                  labelColor: AppColors.statusPublished,
                  borderColor: AppColors.statusPublished,
                  semanticsLabel: 'AI corrected text',
                  diffHighlights: textsIdentical
                      ? null
                      : _computeDiffHighlights(originalText, correctedText),
                ),

                const SizedBox(height: 24),

                // ── S3-11: Tag suggestions ─────────────────────────────
                if (aiReview.suggestedTags.isNotEmpty) ...[
                  _TagSuggestionSection(
                    suggestedTags: aiReview.suggestedTags,
                    selectedTags: state.selectedTags,
                    onToggle: (tag) => _bloc.add(ToggleTag(tag)),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── S3-11: Category dropdown ───────────────────────────
                _CategorySection(
                  selectedCategory: state.selectedCategory,
                  suggestedCategory: aiReview.suggestedCategory,
                  onChanged: (cat) => _bloc.add(UpdateCategory(cat)),
                ),
                const SizedBox(height: 16),

                // ── S3-11: City (read-only) ────────────────────────────
                _CityReadOnly(city: detail.city),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // ── Bottom action bar ────────────────────────────────────────────
        _BottomActionBar(
          onProceed: () {
            _bloc.add(const AcceptAndProceed());
            // Navigate back.
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/my-submissions');
            }
          },
        ),
      ],
    );
  }

  // ── Error State ────────────────────────────────────────────────────────

  Widget _buildErrorState(BuildContext context, AiPreviewError state) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.statusRejected,
            ),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (state.submissionId != null) ...[
              OutlinedButton.icon(
                onPressed: () =>
                    _bloc.add(LoadAiPreview(state.submissionId!)),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
              const SizedBox(height: 12),
            ],
            TextButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/my-submissions');
                }
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  bool _hasSafetyFlags(AIReviewResult aiReview) {
    return aiReview.hateSpeechDetected ||
        aiReview.toxicityDetected ||
        aiReview.spamDetected;
  }

  /// Computes simple word-level diff highlights for the corrected text.
  ///
  /// Returns a list of [_DiffSegment] where each segment indicates whether
  /// that piece of text was added (new in corrected) or unchanged.
  List<_DiffSegment> _computeDiffHighlights(
    String original,
    String corrected,
  ) {
    final origWords = original.split(RegExp(r'\s+'));
    final corrWords = corrected.split(RegExp(r'\s+'));

    // Build a set of original words for quick lookup.
    // We use a simple approach: track which words from original appear at
    // roughly the same positions. For a more sophisticated diff, an LCS
    // algorithm would be used; here we use a practical heuristic.
    final origSet = origWords.toSet();
    final segments = <_DiffSegment>[];

    for (final word in corrWords) {
      if (origSet.contains(word)) {
        segments.add(_DiffSegment(word, isNew: false));
      } else {
        segments.add(_DiffSegment(word, isNew: true));
      }
    }

    return segments;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PRIVATE WIDGETS
// ═══════════════════════════════════════════════════════════════════════════

/// Simple diff segment — a word and whether it is new (added by AI).
class _DiffSegment {
  final String text;
  final bool isNew;

  const _DiffSegment(this.text, {required this.isNew});
}

// ── Safety Flags Banner ──────────────────────────────────────────────────

class _SafetyFlagsBanner extends StatelessWidget {
  final AIReviewResult aiReview;

  const _SafetyFlagsBanner({required this.aiReview});

  @override
  Widget build(BuildContext context) {
    final flags = <String>[];
    if (aiReview.hateSpeechDetected) flags.add('Hate Speech');
    if (aiReview.toxicityDetected) flags.add('Toxicity');
    if (aiReview.spamDetected) flags.add('Spam');

    return Semantics(
      liveRegion: true,
      label: 'Safety warning: ${flags.join(", ")} detected',
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.statusRejectedBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.statusRejected),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.statusRejected,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Safety Concerns Detected',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.statusRejected,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: flags.map((flag) {
                      return Chip(
                        label: Text(
                          flag,
                          style: const TextStyle(
                            color: AppColors.statusRejected,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: AppColors.statusRejectedBg,
                        side: const BorderSide(color: AppColors.statusRejected),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'The AI has flagged content that may violate community '
                    'guidelines. Please review before proceeding.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.statusRejected,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Metadata Row (Safety Score + Language Badge) ─────────────────────────

class _MetadataRow extends StatelessWidget {
  final AIReviewResult aiReview;

  const _MetadataRow({required this.aiReview});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Safety score indicator.
        _SafetyScoreIndicator(score: aiReview.safetyScore),

        // Confidence score.
        if (aiReview.confidenceScore > 0)
          Semantics(
            label:
                'AI confidence: ${(aiReview.confidenceScore * 100).round()} percent',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.statusUnderReviewBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.statusUnderReview),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.psychology,
                    size: 16,
                    color: AppColors.statusUnderReview,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Confidence: ${(aiReview.confidenceScore * 100).round()}%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.statusUnderReview,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Detected language badge.
        if (aiReview.languageDetected != null &&
            aiReview.languageDetected!.isNotEmpty)
          Semantics(
            label: 'Detected language: ${aiReview.languageDetected}',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.statusInProgressBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.statusInProgress),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.translate,
                    size: 16,
                    color: AppColors.statusInProgress,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    aiReview.languageDetected!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.statusInProgress,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ── Safety Score Indicator ───────────────────────────────────────────────

class _SafetyScoreIndicator extends StatelessWidget {
  final double score;

  const _SafetyScoreIndicator({required this.score});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Green check (> 0.7), yellow warning (0.4-0.7), red alert (< 0.4)
    final Color color;
    final IconData icon;
    final String label;

    if (score > 0.7) {
      color = AppColors.statusPublished;
      icon = Icons.check_circle;
      label = 'Safe';
    } else if (score >= 0.4) {
      color = AppColors.statusInProgress;
      icon = Icons.warning_amber_rounded;
      label = 'Caution';
    } else {
      color = AppColors.statusRejected;
      icon = Icons.dangerous;
      label = 'Unsafe';
    }

    final percentage = (score * 100).round();

    return Semantics(
      label: 'Safety score: $percentage percent, $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              'Safety: $percentage%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Text Comparison Panel ────────────────────────────────────────────────

class _TextComparisonPanel extends StatelessWidget {
  final String label;
  final String text;
  final Color backgroundColor;
  final Color labelColor;
  final Color borderColor;
  final String semanticsLabel;
  final List<_DiffSegment>? diffHighlights;

  const _TextComparisonPanel({
    required this.label,
    required this.text,
    required this.backgroundColor,
    required this.labelColor,
    required this.borderColor,
    required this.semanticsLabel,
    this.diffHighlights,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: '$semanticsLabel: $text',
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor.withAlpha(120)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label header.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: borderColor.withAlpha(30),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // Text content.
            Padding(
              padding: const EdgeInsets.all(16),
              child: diffHighlights != null
                  ? _buildHighlightedText(theme)
                  : SelectableText(
                      text,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedText(ThemeData theme) {
    final spans = <TextSpan>[];
    for (var i = 0; i < diffHighlights!.length; i++) {
      final segment = diffHighlights![i];
      final isLast = i == diffHighlights!.length - 1;

      spans.add(TextSpan(
        text: segment.text + (isLast ? '' : ' '),
        style: theme.textTheme.bodyMedium?.copyWith(
          height: 1.6,
          backgroundColor: segment.isNew
              ? AppColors.diffHighlight // Green highlight for new words
              : null,
          fontWeight: segment.isNew ? FontWeight.w600 : null,
        ),
      ));
    }

    return SelectableText.rich(
      TextSpan(children: spans),
    );
  }
}

// ── Tag Suggestion Section (S3-11) ───────────────────────────────────────

class _TagSuggestionSection extends StatelessWidget {
  final List<String> suggestedTags;
  final Set<String> selectedTags;
  final ValueChanged<String> onToggle;

  const _TagSuggestionSection({
    required this.suggestedTags,
    required this.selectedTags,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.label_outline, size: 20, color: AppColors.darkGrey),
            const SizedBox(width: 8),
            Text(
              'Suggested Tags',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Tap to deselect tags you disagree with.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.mediumGrey,
          ),
        ),
        const SizedBox(height: 10),
        Semantics(
          label: 'Suggested tags: ${suggestedTags.join(", ")}. '
              '${selectedTags.length} of ${suggestedTags.length} selected.',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestedTags.map((tag) {
              final isSelected = selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (_) => onToggle(tag),
                selectedColor: AppColors.statusUnderReviewBg,
                checkmarkColor: AppColors.statusUnderReview,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.statusUnderReview
                      : AppColors.darkGrey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.statusUnderReview
                      : AppColors.lightGrey,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                tooltip: isSelected
                    ? 'Deselect tag: $tag'
                    : 'Select tag: $tag',
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Category Section (S3-11) ─────────────────────────────────────────────

class _CategorySection extends StatelessWidget {
  final String? selectedCategory;
  final String? suggestedCategory;
  final ValueChanged<String> onChanged;

  const _CategorySection({
    required this.selectedCategory,
    required this.suggestedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine the effective value shown in the dropdown.
    final effectiveCategory = selectedCategory ?? suggestedCategory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.category_outlined,
                size: 20, color: AppColors.darkGrey),
            const SizedBox(width: 8),
            Text(
              'Category',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (suggestedCategory != null) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.statusUnderReviewBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'AI suggested',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.statusUnderReview,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'You can override the AI-suggested category.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.mediumGrey,
          ),
        ),
        const SizedBox(height: 10),
        Semantics(
          label: 'Category selector. '
              '${suggestedCategory != null ? "AI suggested: $suggestedCategory. " : ""}'
              'Currently: ${effectiveCategory ?? "none selected"}',
          child: DropdownButtonFormField<String>(
            key: ValueKey('category_$effectiveCategory'),
            initialValue: effectiveCategory != null &&
                    _availableCategories.contains(effectiveCategory)
                ? effectiveCategory
                : null,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            hint: const Text('Select a category'),
            items: _availableCategories.map((cat) {
              final isSuggested = cat == suggestedCategory;
              return DropdownMenuItem<String>(
                value: cat,
                child: Row(
                  children: [
                    Text(cat),
                    if (isSuggested) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.statusUnderReviewBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'AI',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.statusUnderReview,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ),
      ],
    );
  }
}

// ── City Read-Only (S3-11) ───────────────────────────────────────────────

class _CityReadOnly extends StatelessWidget {
  final String city;

  const _CityReadOnly({required this.city});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 20, color: AppColors.darkGrey),
            const SizedBox(width: 8),
            Text(
              'City',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.extraLightGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Read-only',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.mediumGrey,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Semantics(
          label: 'City: $city. This field cannot be edited.',
          child: TextFormField(
            initialValue: city,
            readOnly: true,
            enabled: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppColors.extraLightGrey,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              prefixIcon: const Icon(Icons.location_city),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Bottom Action Bar ────────────────────────────────────────────────────

class _BottomActionBar extends StatelessWidget {
  final VoidCallback onProceed;

  const _BottomActionBar({required this.onProceed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: Semantics(
            button: true,
            label: 'Proceed to editorial review',
            child: ElevatedButton.icon(
              onPressed: onProceed,
              icon: const Icon(Icons.send),
              label: const Text('Proceed to Review'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
