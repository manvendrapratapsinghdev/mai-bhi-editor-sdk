part of 'editorial_queue_bloc.dart';

/// Events for the Editorial Queue BLoC.
abstract class EditorialQueueEvent extends Equatable {
  const EditorialQueueEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load of the queue.
class LoadQueue extends EditorialQueueEvent {
  const LoadQueue();
}

/// Filter the queue by city. Pass null for "All Cities".
class FilterByCity extends EditorialQueueEvent {
  final String? city;

  const FilterByCity(this.city);

  @override
  List<Object?> get props => [city];
}

/// Change the sort order of the queue.
class ChangeSortOrder extends EditorialQueueEvent {
  final QueueSortOrder sortOrder;

  const ChangeSortOrder(this.sortOrder);

  @override
  List<Object?> get props => [sortOrder];
}

/// Load more items for infinite scroll.
class LoadMore extends EditorialQueueEvent {
  const LoadMore();
}

/// Pull-to-refresh.
class RefreshQueue extends EditorialQueueEvent {
  const RefreshQueue();
}

/// Auto-refresh (silent, no loading indicator).
class AutoRefreshQueue extends EditorialQueueEvent {
  const AutoRefreshQueue();
}
