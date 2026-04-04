part of 'creator_profile_bloc.dart';

/// Events for the Creator Profile BLoC.
abstract class CreatorProfileEvent extends Equatable {
  const CreatorProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Load a creator's public profile.
class LoadCreatorProfile extends CreatorProfileEvent {
  final String creatorId;

  const LoadCreatorProfile(this.creatorId);

  @override
  List<Object?> get props => [creatorId];
}

/// Load the creator's published stories.
class LoadCreatorStories extends CreatorProfileEvent {
  final String creatorId;

  const LoadCreatorStories(this.creatorId);

  @override
  List<Object?> get props => [creatorId];
}

/// Block a creator.
class BlockCreator extends CreatorProfileEvent {
  final String creatorId;

  const BlockCreator(this.creatorId);

  @override
  List<Object?> get props => [creatorId];
}

/// Unblock a creator.
class UnblockCreator extends CreatorProfileEvent {
  final String creatorId;

  const UnblockCreator(this.creatorId);

  @override
  List<Object?> get props => [creatorId];
}

/// Report a creator.
class ReportCreator extends CreatorProfileEvent {
  final String creatorId;
  final String reason;
  final String? details;

  const ReportCreator({
    required this.creatorId,
    required this.reason,
    this.details,
  });

  @override
  List<Object?> get props => [creatorId, reason, details];
}
