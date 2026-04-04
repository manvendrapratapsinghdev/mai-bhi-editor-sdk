import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../../community/domain/repositories/community_repository.dart';
import '../../domain/entities/story_detail.dart';
import '../../domain/usecases/get_shareable_link_usecase.dart';
import '../../domain/usecases/get_story_detail_usecase.dart';

part 'story_detail_event.dart';
part 'story_detail_state.dart';

/// BLoC managing story detail, like/confirm toggles, and sharing.
class StoryDetailBloc extends Bloc<StoryDetailEvent, StoryDetailState> {
  final GetStoryDetailUseCase _getStoryDetailUseCase;
  final GetShareableLinkUseCase _getShareableLinkUseCase;
  final CommunityRepository _communityRepository;

  StoryDetailBloc({
    required GetStoryDetailUseCase getStoryDetailUseCase,
    required GetShareableLinkUseCase getShareableLinkUseCase,
    required CommunityRepository communityRepository,
  })  : _getStoryDetailUseCase = getStoryDetailUseCase,
        _getShareableLinkUseCase = getShareableLinkUseCase,
        _communityRepository = communityRepository,
        super(const StoryDetailState()) {
    on<LoadStoryDetail>(_onLoadStoryDetail);
    on<ToggleLike>(_onToggleLike);
    on<ToggleConfirm>(_onToggleConfirm);
    on<ShareStory>(_onShareStory);
  }

  Future<void> _onLoadStoryDetail(
    LoadStoryDetail event,
    Emitter<StoryDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final story = await _getStoryDetailUseCase(event.id);

      emit(state.copyWith(
        story: story,
        isLoading: false,
        isLiked: story.userHasLiked,
        isConfirmed: story.userHasConfirmed,
        likesCount: story.likes,
        confirmationsCount: story.confirmations,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } on NetworkException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load story.',
      ));
    }
  }

  Future<void> _onToggleLike(
    ToggleLike event,
    Emitter<StoryDetailState> emit,
  ) async {
    if (state.story == null) return;

    // Optimistic update.
    final wasLiked = state.isLiked;
    final newLiked = !wasLiked;
    final newCount = state.likesCount + (newLiked ? 1 : -1);

    emit(state.copyWith(isLiked: newLiked, likesCount: newCount));

    try {
      final result = await _communityRepository.likeStory(state.story!.id);
      emit(state.copyWith(
        isLiked: result.liked,
        likesCount: result.totalLikes,
      ));
    } catch (e) {
      // Revert on failure.
      emit(state.copyWith(isLiked: wasLiked, likesCount: state.likesCount));
    }
  }

  Future<void> _onToggleConfirm(
    ToggleConfirm event,
    Emitter<StoryDetailState> emit,
  ) async {
    if (state.story == null) return;

    // Optimistic update.
    final wasConfirmed = state.isConfirmed;
    final newConfirmed = !wasConfirmed;
    final newCount = state.confirmationsCount + (newConfirmed ? 1 : -1);

    emit(state.copyWith(
      isConfirmed: newConfirmed,
      confirmationsCount: newCount,
    ));

    try {
      final result =
          await _communityRepository.confirmStory(state.story!.id);
      emit(state.copyWith(
        isConfirmed: result.confirmed,
        confirmationsCount: result.totalConfirmations,
      ));
    } catch (e) {
      // Revert on failure.
      emit(state.copyWith(
        isConfirmed: wasConfirmed,
        confirmationsCount: state.confirmationsCount,
      ));
    }
  }

  Future<void> _onShareStory(
    ShareStory event,
    Emitter<StoryDetailState> emit,
  ) async {
    if (state.story == null) return;

    emit(state.copyWith(isSharing: true, clearShareUrl: true));

    try {
      final shareUrl =
          await _getShareableLinkUseCase(state.story!.id);
      emit(state.copyWith(isSharing: false, shareUrl: shareUrl));
    } catch (e) {
      emit(state.copyWith(isSharing: false));
    }
  }
}
