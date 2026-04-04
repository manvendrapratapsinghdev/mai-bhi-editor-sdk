import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../../feed/domain/entities/feed_item.dart';
import '../../domain/entities/creator_profile.dart';
import '../../domain/repositories/community_repository.dart';
import '../../../feed/domain/repositories/feed_repository.dart';

part 'creator_profile_event.dart';
part 'creator_profile_state.dart';

/// BLoC managing a creator's public profile page.
///
/// Handles profile loading, creator stories, block/report actions.
class CreatorProfileBloc
    extends Bloc<CreatorProfileEvent, CreatorProfileState> {
  final CommunityRepository _communityRepository;
  final FeedRepository _feedRepository;

  CreatorProfileBloc({
    required CommunityRepository communityRepository,
    required FeedRepository feedRepository,
  })  : _communityRepository = communityRepository,
        _feedRepository = feedRepository,
        super(const CreatorProfileState()) {
    on<LoadCreatorProfile>(_onLoadProfile);
    on<LoadCreatorStories>(_onLoadStories);
    on<BlockCreator>(_onBlock);
    on<UnblockCreator>(_onUnblock);
    on<ReportCreator>(_onReport);
  }

  Future<void> _onLoadProfile(
    LoadCreatorProfile event,
    Emitter<CreatorProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final profile =
          await _communityRepository.getCreatorProfile(event.creatorId);
      emit(state.copyWith(
        profile: profile,
        isLoading: false,
      ));

      // Trigger loading the creator's stories after profile is loaded.
      add(LoadCreatorStories(event.creatorId));
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } on NetworkException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load creator profile.',
      ));
    }
  }

  Future<void> _onLoadStories(
    LoadCreatorStories event,
    Emitter<CreatorProfileState> emit,
  ) async {
    emit(state.copyWith(isLoadingStories: true));

    try {
      // Search for stories by creator name from the profile.
      // In a real app this would be a dedicated endpoint.
      // For now, we use the feed search with the creator name.
      final creatorName = state.profile?.name;
      if (creatorName != null && creatorName.isNotEmpty) {
        final response = await _feedRepository.searchStories(
          query: creatorName,
        );
        emit(state.copyWith(
          stories: response.stories,
          isLoadingStories: false,
        ));
      } else {
        emit(state.copyWith(stories: [], isLoadingStories: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoadingStories: false, stories: []));
    }
  }

  Future<void> _onBlock(
    BlockCreator event,
    Emitter<CreatorProfileState> emit,
  ) async {
    try {
      final isBlocked =
          await _communityRepository.blockCreator(event.creatorId);
      emit(state.copyWith(isBlocked: isBlocked));
    } on ServerException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to block creator.'));
    }
  }

  Future<void> _onUnblock(
    UnblockCreator event,
    Emitter<CreatorProfileState> emit,
  ) async {
    try {
      final isBlocked =
          await _communityRepository.blockCreator(event.creatorId);
      emit(state.copyWith(isBlocked: isBlocked));
    } on ServerException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to unblock creator.'));
    }
  }

  Future<void> _onReport(
    ReportCreator event,
    Emitter<CreatorProfileState> emit,
  ) async {
    try {
      await _communityRepository.report(
        targetType: 'creator',
        targetId: event.creatorId,
        reason: event.reason,
        details: event.details,
      );
      emit(state.copyWith(reportSubmitted: true));
    } on ServerException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to submit report.',
      ));
    }
  }
}
