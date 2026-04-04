import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for city preference storage.
///
/// Stores the user's preferred city and whether the initial city
/// selection prompt has been shown.
abstract class CityPreferenceDataSource {
  /// Get the stored preferred city, or null if none set.
  Future<String?> getPreferredCity();

  /// Save the user's preferred city.
  Future<void> setPreferredCity(String city);

  /// Clear the preferred city (revert to "All Cities").
  Future<void> clearPreferredCity();

  /// Whether the first-time city selection prompt has been shown.
  Future<bool> hasCityPromptBeenShown();

  /// Mark the first-time city selection prompt as shown.
  Future<void> markCityPromptShown();

  /// Get recently searched queries (last 5).
  Future<List<String>> getRecentSearches();

  /// Add a search query to recent searches.
  Future<void> addRecentSearch(String query);

  /// Clear all recent searches.
  Future<void> clearRecentSearches();
}

class CityPreferenceDataSourceImpl implements CityPreferenceDataSource {
  static const String _preferredCityKey = 'preferred_city';
  static const String _cityPromptShownKey = 'city_prompt_shown';
  static const String _recentSearchesKey = 'recent_searches';
  static const int _maxRecentSearches = 5;

  @override
  Future<String?> getPreferredCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_preferredCityKey);
  }

  @override
  Future<void> setPreferredCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_preferredCityKey, city);
  }

  @override
  Future<void> clearPreferredCity() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_preferredCityKey);
  }

  @override
  Future<bool> hasCityPromptBeenShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_cityPromptShownKey) ?? false;
  }

  @override
  Future<void> markCityPromptShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_cityPromptShownKey, true);
  }

  @override
  Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentSearchesKey) ?? [];
  }

  @override
  Future<void> addRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList(_recentSearchesKey) ?? [];

    // Remove duplicates and prepend new query.
    searches.remove(trimmed);
    searches.insert(0, trimmed);

    // Keep only the last N searches.
    if (searches.length > _maxRecentSearches) {
      searches.removeRange(_maxRecentSearches, searches.length);
    }

    await prefs.setStringList(_recentSearchesKey, searches);
  }

  @override
  Future<void> clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchesKey);
  }
}
