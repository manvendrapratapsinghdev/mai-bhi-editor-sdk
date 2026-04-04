import 'package:shared_preferences/shared_preferences.dart';

/// Manages onboarding-related flags in SharedPreferences.
class OnboardingPreferences {
  static const String _keyOnboardingComplete = 'onboarding_complete';
  static const String _keyGuidelinesAccepted = 'guidelines_accepted';

  /// Check if onboarding has been completed.
  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingComplete) ?? false;
  }

  /// Mark onboarding as completed.
  Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingComplete, true);
    await prefs.setBool(_keyGuidelinesAccepted, true);
  }

  /// Reset onboarding (for testing purposes).
  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyOnboardingComplete);
    await prefs.remove(_keyGuidelinesAccepted);
  }
}
