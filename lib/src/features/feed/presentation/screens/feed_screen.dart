import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../auth/auth_status.dart';
import '../../../../config/mai_bhi_editor_initializer.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../notifications/presentation/widgets/notification_bell_widget.dart';
import '../../data/datasources/city_preference_datasource.dart';
import '../bloc/feed_bloc.dart';
import '../widgets/city_filter_sheet.dart';
import '../widgets/city_prompt_sheet.dart';
import '../widgets/story_card.dart';
import '../../../../injection.dart';

/// Main news feed screen ("News By You").
///
/// Features:
/// - App bar with search, city filter, and trending toggle
/// - Story cards in a ListView with pull-to-refresh and infinite scroll
/// - City filter via bottom sheet
/// - Search mode with debounce
/// - Trending stories tab/toggle with fire badge
/// - Empty and error states
/// - FAB to create new submission
/// - Scroll depth analytics tracking
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _showSearchBar = false;
  double _maxScrollDepth = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _checkFirstTimeCityPrompt();
  }

  @override
  void dispose() {
    // Track final scroll depth.
    if (_maxScrollDepth > 0) {
      sl<AnalyticsService>().track(
        AnalyticsService.feedScrolled,
        properties: {'max_depth_percent': _maxScrollDepth.round()},
      );
    }
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Infinite scroll trigger.
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final bloc = context.read<FeedBloc>();
      if (!bloc.state.isLoadingMore &&
          bloc.state.hasMore &&
          !bloc.state.isSearching) {
        bloc.add(const LoadMoreFeed());
      }
    }

    // Track scroll depth for analytics.
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent > 0) {
      final depth = (_scrollController.offset /
              _scrollController.position.maxScrollExtent) *
          100;
      if (depth > _maxScrollDepth) {
        _maxScrollDepth = depth;
      }
    }
  }

  Future<void> _checkFirstTimeCityPrompt() async {
    final cityPref = sl<CityPreferenceDataSource>();
    final shown = await cityPref.hasCityPromptBeenShown();
    if (!shown && mounted) {
      await cityPref.markCityPromptShown();
      if (!mounted) return;
      final selectedCity = await CityPromptSheet.show(context);
      if (selectedCity != null && mounted) {
        await cityPref.setPreferredCity(selectedCity);
        if (mounted) {
          context.read<FeedBloc>().add(FilterFeedByCity(selectedCity));
        }
      }
    }
  }

  Future<void> _onRefresh() async {
    context.read<FeedBloc>().add(const RefreshFeed());
    // Allow the refresh indicator to show briefly.
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _openCityFilter() async {
    final bloc = context.read<FeedBloc>();
    final result = await CityFilterSheet.show(
      context,
      currentCity: bloc.state.cityFilter,
    );
    if (mounted && result != bloc.state.cityFilter) {
      bloc.add(FilterFeedByCity(result));
      // Also save preference.
      final cityPref = sl<CityPreferenceDataSource>();
      if (result != null) {
        await cityPref.setPreferredCity(result);
      } else {
        await cityPref.clearPreferredCity();
      }
    }
  }

  void _toggleSearch() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      if (!_showSearchBar) {
        _searchController.clear();
        context.read<FeedBloc>().add(const ClearSearch());
      } else {
        _searchFocusNode.requestFocus();
      }
    });
  }

  void _onSearchChanged(String query) async {
    context.read<FeedBloc>().add(SearchStories(query));
    if (query.trim().isNotEmpty) {
      sl<AnalyticsService>().track(
        AnalyticsService.searchPerformed,
        properties: {'query': query.trim()},
      );
      final cityPref = sl<CityPreferenceDataSource>();
      await cityPref.addRecentSearch(query.trim());
    }
  }

  void _toggleTrending() {
    sl<AnalyticsService>().track(AnalyticsService.trendingToggled);
    context.read<FeedBloc>().add(const ToggleTrending());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state.isSearching) {
            return _buildSearchResults(context, state);
          }
          return _buildFeedBody(context, state);
        },
      ),
      floatingActionButton: Semantics(
        button: true,
        label: 'Submit a new story',
        child: FloatingActionButton(
          onPressed: () async {
            final isLoggedIn =
                MaiBhiEditor.authProvider.authStatus == AuthStatus.authenticated;
            if (!isLoggedIn) {
              final loggedIn = await MaiBhiEditor.authProvider.requestLogin();
              if (!loggedIn || !mounted) return;
            }
            sl<AnalyticsService>().track(AnalyticsService.submissionStarted);
            if (mounted) context.push('/submit');
          },
          tooltip: 'Submit news',
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    if (_showSearchBar) {
      return AppBar(
        leading: Semantics(
          button: true,
          label: 'Close search',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _toggleSearch,
          ),
        ),
        title: Semantics(
          label: 'Search stories',
          hint: 'Type to search for stories',
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: _onSearchChanged,
            style: const TextStyle(color: AppColors.white),
            cursorColor: AppColors.white,
            decoration: const InputDecoration(
              hintText: 'Search stories...',
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
              filled: false,
            ),
          ),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            Semantics(
              button: true,
              label: 'Clear search',
              child: IconButton(
                icon: const Icon(Icons.clear),
                tooltip: 'Clear search',
                onPressed: () {
                  _searchController.clear();
                  context.read<FeedBloc>().add(const ClearSearch());
                },
              ),
            ),
        ],
      );
    }

    return AppBar(
      title: BlocBuilder<FeedBloc, FeedState>(
        buildWhen: (p, c) =>
            p.cityFilter != c.cityFilter ||
            p.isTrending != c.isTrending,
        builder: (context, state) {
          final subtitle = <String>[];
          if (state.cityFilter != null) subtitle.add(state.cityFilter!);
          if (state.isTrending) subtitle.add('Trending');

          if (subtitle.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('News By You'),
                Text(
                  subtitle.join(' - '),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            );
          }
          return const Text('News By You');
        },
      ),
      actions: [
        NotificationBellWidget(
          onTap: () async {
            final isLoggedIn =
                MaiBhiEditor.authProvider.authStatus == AuthStatus.authenticated;
            if (!isLoggedIn) {
              final loggedIn = await MaiBhiEditor.authProvider.requestLogin();
              if (!loggedIn || !mounted) return;
            }
            if (mounted) context.push(AppRoutes.notifications);
          },
        ),
        Semantics(
          button: true,
          label: 'Search stories',
          child: IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search stories',
            onPressed: _toggleSearch,
          ),
        ),

        // Trending toggle
        BlocBuilder<FeedBloc, FeedState>(
          buildWhen: (p, c) => p.isTrending != c.isTrending,
          builder: (context, state) {
            return Semantics(
              button: true,
              label: state.isTrending
                  ? 'Trending filter active, tap to disable'
                  : 'Trending filter inactive, tap to enable',
              child: IconButton(
                icon: Icon(
                  Icons.local_fire_department,
                  color: state.isTrending
                      ? Colors.orange
                      : null,
                ),
                tooltip: state.isTrending
                    ? 'Show all stories'
                    : 'Show trending stories',
                onPressed: _toggleTrending,
              ),
            );
          },
        ),

        // City filter
        BlocBuilder<FeedBloc, FeedState>(
          buildWhen: (p, c) => p.cityFilter != c.cityFilter,
          builder: (context, state) {
            return Semantics(
              button: true,
              label: state.cityFilter != null
                  ? 'City filter active: ${state.cityFilter}'
                  : 'Filter by city',
              child: IconButton(
                icon: Badge(
                  isLabelVisible: state.cityFilter != null,
                  smallSize: 8,
                  child: const Icon(Icons.location_city),
                ),
                tooltip: 'Filter by city',
                onPressed: _openCityFilter,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeedBody(BuildContext context, FeedState state) {
    // Error state.
    if (state.errorMessage != null && state.stories.isEmpty) {
      return _ErrorView(
        message: state.errorMessage!,
        onRetry: () => context.read<FeedBloc>().add(const LoadFeed()),
      );
    }

    // Loading state.
    if (state.isLoading && state.stories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Trending empty state.
    if (state.isTrending && state.isEmpty) {
      return _EmptyTrendingView(onShowAll: _toggleTrending);
    }

    // Empty state.
    if (state.isEmpty) {
      return _EmptyFeedView(city: state.cityFilter);
    }

    // Feed list.
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primaryRed,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: state.stories.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.stories.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }
          return StoryCard(
            story: state.stories[index],
            showTrendingBadge: state.isTrending,
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, FeedState state) {
    if (state.isSearchLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.searchQuery.isNotEmpty && state.searchResults.isEmpty) {
      return _EmptySearchView(query: state.searchQuery);
    }

    if (state.searchResults.isEmpty) {
      return _buildRecentSearches(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: state.searchResults.length,
      itemBuilder: (context, index) {
        return StoryCard(story: state.searchResults[index]);
      },
    );
  }

  Widget _buildRecentSearches(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: sl<CityPreferenceDataSource>().getRecentSearches(),
      builder: (context, snapshot) {
        final searches = snapshot.data ?? [];
        if (searches.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ExcludeSemantics(
                  child: Icon(
                    Icons.search,
                    size: 64,
                    color: AppColors.lightGrey,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Search for stories',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.mediumGrey,
                      ),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                TextButton(
                  onPressed: () async {
                    await sl<CityPreferenceDataSource>()
                        .clearRecentSearches();
                    setState(() {});
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            ...searches.map(
              (query) => Semantics(
                label: 'Recent search: $query',
                child: ListTile(
                  leading: const Icon(
                    Icons.history,
                    color: AppColors.mediumGrey,
                  ),
                  title: Text(query),
                  onTap: () {
                    _searchController.text = query;
                    _onSearchChanged(query);
                  },
                  dense: true,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Empty trending view ──────────────────────────────────────────────────

class _EmptyTrendingView extends StatelessWidget {
  final VoidCallback onShowAll;

  const _EmptyTrendingView({required this.onShowAll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ExcludeSemantics(
              child: Icon(
                Icons.local_fire_department,
                size: 80,
                color: AppColors.lightGrey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Nothing trending right now',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.mediumGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later or browse all stories.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.lightGrey,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onShowAll,
              icon: const Icon(Icons.list),
              label: const Text('Show All Stories'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty feed view ──────────────────────────────────────────────────────

class _EmptyFeedView extends StatelessWidget {
  final String? city;

  const _EmptyFeedView({this.city});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = city != null
        ? 'No stories yet from $city.\nBe the first reporter!'
        : 'No stories yet.\nBe the first to submit!';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ExcludeSemantics(
              child: Icon(
                Icons.article_outlined,
                size: 80,
                color: AppColors.lightGrey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.mediumGrey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/submit'),
              icon: const Icon(Icons.add),
              label: const Text('Submit a Story'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty search view ────────────────────────────────────────────────────

class _EmptySearchView extends StatelessWidget {
  final String query;

  const _EmptySearchView({required this.query});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ExcludeSemantics(
              child: Icon(
                Icons.search_off,
                size: 64,
                color: AppColors.lightGrey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No stories found for '$query'",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.mediumGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error view ───────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              label: 'Error occurred',
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.statusRejected,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.mediumGrey,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
