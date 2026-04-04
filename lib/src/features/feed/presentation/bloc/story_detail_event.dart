part of 'story_detail_bloc.dart';

/// Events for the Story Detail BLoC.
abstract class StoryDetailEvent extends Equatable {
  const StoryDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load full story detail by ID.
class LoadStoryDetail extends StoryDetailEvent {
  final String id;

  const LoadStoryDetail(this.id);

  @override
  List<Object?> get props => [id];
}

/// Toggle the like state for the current story.
class ToggleLike extends StoryDetailEvent {
  const ToggleLike();
}

/// Toggle the confirmation state for the current story.
class ToggleConfirm extends StoryDetailEvent {
  const ToggleConfirm();
}

/// Share the current story via native share sheet.
class ShareStory extends StoryDetailEvent {
  const ShareStory();
}
