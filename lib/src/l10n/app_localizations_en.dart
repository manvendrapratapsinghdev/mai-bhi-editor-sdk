// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mai Bhi Editor';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginError => 'Invalid email or password';

  @override
  String get loginSubtitle => 'Citizen journalism by Hindustan Times';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get signingIn => 'Signing in, please wait';

  @override
  String get termsFooter =>
      'By signing in, you agree to the HT Terms of Service.';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Log Out';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get profile => 'Profile';

  @override
  String get myProfile => 'My Profile';

  @override
  String get reputation => 'Reputation';

  @override
  String get published => 'Published';

  @override
  String get cityLabel => 'City';

  @override
  String get cityNotSet => 'Not set';

  @override
  String get level => 'Level';

  @override
  String get badges => 'Badges';

  @override
  String get noBadges => 'No badges earned yet';

  @override
  String get blockedCreators => 'Blocked Creators';

  @override
  String get upgradeToApproved => 'Upgrade to Approved Creator';

  @override
  String get unableToLoadProfile => 'Unable to load profile';

  @override
  String get submit => 'Submit';

  @override
  String get submitNews => 'Submit News';

  @override
  String get submitReport => 'Submit Report';

  @override
  String get title => 'Title';

  @override
  String get titleHint => 'What happened?';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get description => 'Description';

  @override
  String get descriptionHint => 'Describe what you witnessed in detail...';

  @override
  String get descriptionRequired => 'Description is required';

  @override
  String get city => 'City';

  @override
  String get citySearchHint => 'Search city...';

  @override
  String get cityRequired => 'City is required';

  @override
  String get tags => 'Tags';

  @override
  String get coverImage => 'Cover Image';

  @override
  String get coverImageRequired => 'Cover image is required';

  @override
  String get tapToAddCoverImage => 'Tap to add cover image';

  @override
  String get additionalImages => 'Additional Images';

  @override
  String get addMoreImages => 'Add More Images';

  @override
  String get selectCoverImage => 'Select Cover Image';

  @override
  String get addImage => 'Add Image';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get saveDraft => 'Save Draft';

  @override
  String get draftSaved => 'Draft saved';

  @override
  String get unsavedChangesTitle => 'Unsaved Changes';

  @override
  String get unsavedChangesMessage =>
      'You have unsaved content. Would you like to save it as a draft?';

  @override
  String get discard => 'Discard';

  @override
  String get submissionSuccess => 'Submission created successfully!';

  @override
  String get failedToPickImage => 'Failed to pick image';

  @override
  String get postedByYou => 'Posted by You';

  @override
  String get newsFeed => 'News By You';

  @override
  String get trending => 'Trending';

  @override
  String get searchStories => 'Search stories';

  @override
  String get searchStoriesHint => 'Search stories...';

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String get clearAll => 'Clear All';

  @override
  String get searchForStories => 'Search for stories';

  @override
  String get noStoriesYet => 'No stories yet.\nBe the first to submit!';

  @override
  String noStoriesInCity(String city) {
    return 'No stories yet from $city.\nBe the first reporter!';
  }

  @override
  String noSearchResults(String query) {
    return 'No stories found for \'$query\'';
  }

  @override
  String get submitAStory => 'Submit a Story';

  @override
  String get filterByCity => 'Filter by city';

  @override
  String get confirm => 'Confirm';

  @override
  String get like => 'Like';

  @override
  String get share => 'Share';

  @override
  String confirmations(int count) {
    return '$count confirmations';
  }

  @override
  String likes(int count) {
    return '$count likes';
  }

  @override
  String get editorialQueue => 'Editorial Queue';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get edit => 'Edit';

  @override
  String get markCorrection => 'Mark Correction';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusUnderReview => 'Under Review';

  @override
  String get statusPublished => 'Published';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get noResults => 'No results found';

  @override
  String get retry => 'Retry';

  @override
  String get networkError => 'Network error. Please try again.';

  @override
  String get serverError => 'Server error. Please try later.';

  @override
  String get unexpectedError =>
      'An unexpected error occurred. Please try again.';

  @override
  String get rateLimitError => 'Too many attempts. Please wait a moment.';

  @override
  String get accountSuspended => 'Account is suspended. Contact support.';

  @override
  String get accountNotFound => 'Account not found.';

  @override
  String get checkInput => 'Please check your input and try again.';

  @override
  String get failedToLoadProfile => 'Failed to load profile.';

  @override
  String get notifications => 'Notifications';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get noNotificationsDescription =>
      'You will see updates about your stories, milestones, and community activity here.';

  @override
  String get notificationStoryApproved => 'Story Approved';

  @override
  String get notificationStoryRejected => 'Story Rejected';

  @override
  String get notificationCorrectionNeeded => 'Correction Needed';

  @override
  String get notificationMilestone => 'Milestone Reached';

  @override
  String get notificationBadge => 'New Badge Earned';

  @override
  String get notificationTrending => 'Trending Story';

  @override
  String get notificationCommunity => 'Community Activity';

  @override
  String get settings => 'Settings';

  @override
  String get notificationPreferences => 'Notification Preferences';

  @override
  String get storyUpdates => 'Story Updates';

  @override
  String get storyUpdatesDesc =>
      'Approved, rejected, and correction notifications';

  @override
  String get milestonesBadges => 'Milestones & Badges';

  @override
  String get milestonesBadgesDesc => 'Achievement and level-up notifications';

  @override
  String get trendingStoriesInCity => 'Trending Stories in My City';

  @override
  String get trendingStoriesDesc => 'When stories in your city are trending';

  @override
  String get communityActivity => 'Community Activity';

  @override
  String get communityActivityDesc => 'Confirmations on your stories';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi';

  @override
  String get defaultLanguage => 'Default language';

  @override
  String get appVersion => 'Mai Bhi Editor v1.0.0';

  @override
  String get onboardingWelcomeTitle => 'Welcome to News By You';

  @override
  String get onboardingWelcomeDesc =>
      'Become a citizen journalist! Report local news from your city and share stories that matter to your community.';

  @override
  String get onboardingAiTitle => 'AI Assists Your Writing';

  @override
  String get onboardingAiDesc =>
      'Our AI tool helps rephrase and structure your reports for clarity and readability. Write naturally and let AI polish it.';

  @override
  String get onboardingEditorsTitle => 'Editors Verify';

  @override
  String get onboardingEditorsDesc =>
      'Every story goes through HT editorial review before publication. This ensures accuracy and builds trust in citizen journalism.';

  @override
  String get onboardingReputationTitle => 'Earn Reputation';

  @override
  String get onboardingReputationDesc =>
      'Gain points, unlock badges, and level up from Basic Creator to Trusted Reporter. Your credibility grows with every published story.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get acceptAndContinue => 'Accept & Continue';

  @override
  String get guidelinesCheckbox =>
      'I agree to the Community Guidelines and will report responsibly';

  @override
  String get pleaseAcceptGuidelines =>
      'Please accept the community guidelines to continue';

  @override
  String get basicCreator => 'Basic Creator';

  @override
  String get htApprovedCreator => 'HT Approved Creator';

  @override
  String get trustedReporter => 'Trusted Reporter';

  @override
  String get mySubmissions => 'My Submissions';

  @override
  String get aiPreview => 'AI Preview';

  @override
  String get kycUpload => 'KYC Verification';

  @override
  String get creatorProfileTitle => 'Creator Profile';

  @override
  String pageNotFound(String uri) {
    return 'Page not found: $uri';
  }
}
