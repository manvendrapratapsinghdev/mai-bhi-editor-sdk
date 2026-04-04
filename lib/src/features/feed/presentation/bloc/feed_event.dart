part of 'feed_bloc.dart';

/// Events for the Feed BLoC.
abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load of the feed.
class LoadFeed extends FeedEvent {
  const LoadFeed();
}

/// Load more stories for infinite scroll.
class LoadMoreFeed extends FeedEvent {
  const LoadMoreFeed();
}

/// Filter the feed by city. Pass null for "All Cities".
class FilterFeedByCity extends FeedEvent {
  final String? city;

  const FilterFeedByCity(this.city);

  @override
  List<Object?> get props => [city];
}

/// Pull-to-refresh.
class RefreshFeed extends FeedEvent {
  const RefreshFeed();
}

/// Search stories by query.
class SearchStories extends FeedEvent {
  final String query;

  const SearchStories(this.query);

  @override
  List<Object?> get props => [query];
}

/// Clear search and return to feed.
class ClearSearch extends FeedEvent {
  const ClearSearch();
}

/// Toggle trending filter on/off.
class ToggleTrending extends FeedEvent {
  const ToggleTrending();
}
