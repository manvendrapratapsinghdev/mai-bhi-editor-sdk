import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/mai_bhi_editor_initializer.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/submission_form_bloc.dart';

/// News submission form with title, description, city, images, and tags.
///
/// Implements S2-05 (form UI), S2-06 (multi-image picker), and
/// S2-08 (draft save on navigate away).
class SubmissionFormScreen extends StatefulWidget {
  /// Optional draft ID to resume editing.
  final String? draftId;

  const SubmissionFormScreen({super.key, this.draftId});

  @override
  State<SubmissionFormScreen> createState() => _SubmissionFormScreenState();
}

class _SubmissionFormScreenState extends State<SubmissionFormScreen> {
  late final SubmissionFormBloc _bloc;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      _bloc = context.read<SubmissionFormBloc>();

      if (widget.draftId != null) {
        _bloc.add(SubmissionDraftLoaded(widget.draftId!));
      }

      // Sync text controllers with BLoC state after draft load.
      _bloc.stream.listen((state) {
        if (_titleController.text != state.title) {
          _titleController.text = state.title;
        }
        if (_descriptionController.text != state.description) {
          _descriptionController.text = state.description;
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_bloc.hasUnsavedContent && !_bloc.state.isSuccess) {
      final action = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text(
            'You have unsaved content. Would you like to save it as a draft?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop('discard'),
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop('cancel'),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop('save'),
              child: const Text('Save Draft'),
            ),
          ],
        ),
      );

      if (action == 'save') {
        _bloc.add(const SubmissionDraftSaveRequested());
        return true;
      }
      if (action == 'discard') {
        return true;
      }
      return false; // 'cancel' or dismissed
    }
    return true;
  }

  void _showImageSourceSheet({required bool isCover}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isCover ? 'Select Cover Image' : 'Add Image',
              style: Theme.of(ctx).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera, isCover: isCover);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery, isCover: isCover);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, {required bool isCover}) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );
      if (pickedFile == null) return;

      if (isCover) {
        _bloc.add(SubmissionCoverImagePicked(pickedFile.path));
      } else {
        _bloc.add(SubmissionAdditionalImageAdded(pickedFile.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to pick image')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _bloc,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          final canPop = await _onWillPop();
          if (canPop && context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Submit News'),
            actions: [
              // Draft save button.
              BlocBuilder<SubmissionFormBloc, SubmissionFormState>(
                builder: (context, state) {
                  if (!state.hasContent || state.isSubmitting) {
                    return const SizedBox.shrink();
                  }
                  return TextButton(
                    onPressed: () {
                      _bloc.add(const SubmissionDraftSaveRequested());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Draft saved'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      'Save Draft',
                      style: TextStyle(color: theme.colorScheme.onPrimary),
                    ),
                  );
                },
              ),
            ],
          ),
          body: BlocConsumer<SubmissionFormBloc, SubmissionFormState>(
            listener: (context, state) {
              if (state.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Submission created successfully!'),
                    backgroundColor: AppColors.statusPublished,
                  ),
                );
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.mySubmissions);
                }
              }
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: AppColors.white),
                          const SizedBox(width: 8),
                          Expanded(child: Text(state.errorMessage!)),
                        ],
                      ),
                      backgroundColor: AppColors.statusRejected,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Title field ─────────────────────────────────────
                    _buildTitleField(context, state, theme),
                    const SizedBox(height: 16),

                    // ── Description field ───────────────────────────────
                    _buildDescriptionField(context, state, theme),
                    const SizedBox(height: 16),

                    // ── City dropdown ───────────────────────────────────
                    _buildCityDropdown(context, state, theme),
                    const SizedBox(height: 24),

                    // ── Cover image picker ──────────────────────────────
                    _buildCoverImageSection(context, state, theme),
                    const SizedBox(height: 24),

                    // ── Additional images grid ──────────────────────────
                    _buildAdditionalImagesSection(context, state, theme),
                    const SizedBox(height: 32),

                    // ── Submit button ───────────────────────────────────
                    _buildSubmitButton(context, state),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField(
    BuildContext context,
    SubmissionFormState state,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: 'Title input',
          textField: true,
          child: TextFormField(
            controller: _titleController,
            focusNode: _titleFocusNode,
            maxLength: 200,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _descriptionFocusNode.requestFocus(),
            onChanged: (value) =>
                _bloc.add(SubmissionTitleChanged(value)),
            decoration: InputDecoration(
              labelText: 'Title *',
              hintText: 'What happened?',
              prefixIcon: const Icon(Icons.title),
              counterText: '${state.title.length}/200',
              errorText: state.titleError,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(
    BuildContext context,
    SubmissionFormState state,
    ThemeData theme,
  ) {
    return Semantics(
      label: 'Description input',
      textField: true,
      child: TextFormField(
        controller: _descriptionController,
        focusNode: _descriptionFocusNode,
        maxLength: 5000,
        maxLines: 8,
        minLines: 4,
        textInputAction: TextInputAction.newline,
        onChanged: (value) =>
            _bloc.add(SubmissionDescriptionChanged(value)),
        decoration: InputDecoration(
          labelText: 'Description *',
          hintText: 'Describe what you witnessed in detail...',
          alignLabelWithHint: true,
          prefixIcon: const Padding(
            padding: EdgeInsets.only(bottom: 96),
            child: Icon(Icons.description_outlined),
          ),
          counterText: '${state.description.length}/5000',
          errorText: state.descriptionError,
        ),
      ),
    );
  }

  Widget _buildCityDropdown(
    BuildContext context,
    SubmissionFormState state,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return MaiBhiEditor.config.cities;
            }
            return MaiBhiEditor.config.cities.where((city) => city
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
          },
          initialValue: state.city.isNotEmpty
              ? TextEditingValue(text: state.city)
              : null,
          onSelected: (String selection) {
            _bloc.add(SubmissionCityChanged(selection));
          },
          fieldViewBuilder:
              (context, textController, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: textController,
              focusNode: focusNode,
              onFieldSubmitted: (_) => onFieldSubmitted(),
              onChanged: (value) {
                // Allow free text entry as well.
                _bloc.add(SubmissionCityChanged(value));
              },
              decoration: InputDecoration(
                labelText: 'City *',
                hintText: 'Search city...',
                prefixIcon: const Icon(Icons.location_city),
                errorText: state.cityError,
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        dense: true,
                        title: Text(option),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCoverImageSection(
    BuildContext context,
    SubmissionFormState state,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cover Image *',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        if (state.coverImagePath != null) ...[
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(state.coverImagePath!),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 200,
                    color: AppColors.extraLightGrey,
                    child: const Icon(Icons.broken_image, size: 48),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: AppColors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () =>
                        _bloc.add(const SubmissionCoverImageRemoved()),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Material(
                  color: AppColors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _showImageSourceSheet(isCover: true),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.edit,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ] else ...[
          GestureDetector(
            onTap: () => _showImageSourceSheet(isCover: true),
            child: Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.extraLightGrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: state.coverImageError != null
                      ? AppColors.statusRejected
                      : AppColors.lightGrey,
                  width: state.coverImageError != null ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 48,
                    color: state.coverImageError != null
                        ? AppColors.statusRejected
                        : AppColors.mediumGrey,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to add cover image',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (state.coverImageError != null) ...[
          const SizedBox(height: 4),
          Text(
            state.coverImageError!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.statusRejected,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAdditionalImagesSection(
    BuildContext context,
    SubmissionFormState state,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Additional Images',
              style: theme.textTheme.titleSmall,
            ),
            Text(
              '${state.additionalImagePaths.length}/9',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (state.additionalImagePaths.isNotEmpty) ...[
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.additionalImagePaths.length,
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex--;
              _bloc.add(SubmissionImagesReordered(
                oldIndex: oldIndex,
                newIndex: newIndex,
              ));
            },
            itemBuilder: (context, index) {
              final path = state.additionalImagePaths[index];
              return _AdditionalImageTile(
                key: ValueKey('img_${index}_$path'),
                imagePath: path,
                index: index,
                onDelete: () => _bloc
                    .add(SubmissionAdditionalImageRemoved(index)),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
        if (state.additionalImagePaths.length < 9) ...[
          OutlinedButton.icon(
            onPressed: () => _showImageSourceSheet(isCover: false),
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Text('Add More Images'),
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    SubmissionFormState state,
  ) {
    return Semantics(
      button: true,
      label: state.isSubmitting
          ? 'Submitting, please wait'
          : 'Submit news report button',
      child: ElevatedButton(
        onPressed: state.isSubmitting
            ? null
            : () => _bloc.add(const SubmissionFormSubmitted()),
        child: state.isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : const Text('Submit Report'),
      ),
    );
  }
}

/// A single additional image thumbnail tile with delete button and
/// drag handle for reordering.
class _AdditionalImageTile extends StatelessWidget {
  final String imagePath;
  final int index;
  final VoidCallback onDelete;

  const _AdditionalImageTile({
    super.key,
    required this.imagePath,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Drag handle.
          ReorderableDragStartListener(
            index: index,
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.drag_handle, color: AppColors.mediumGrey),
            ),
          ),
          // Thumbnail.
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(imagePath),
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, error, stackTrace) => Container(
                width: 64,
                height: 64,
                color: AppColors.extraLightGrey,
                child: const Icon(Icons.broken_image, size: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // File name.
          Expanded(
            child: Text(
              imagePath.split('/').last,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Delete button.
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.statusRejected),
            tooltip: 'Remove image',
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
