import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Mai Bhi Editor'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginButton;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get loginError;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Citizen journalism by Hindustan Times'**
  String get loginSubtitle;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in, please wait'**
  String get signingIn;

  /// No description provided for @termsFooter.
  ///
  /// In en, this message translates to:
  /// **'By signing in, you agree to the HT Terms of Service.'**
  String get termsFooter;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @reputation.
  ///
  /// In en, this message translates to:
  /// **'Reputation'**
  String get reputation;

  /// No description provided for @published.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get published;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @cityNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get cityNotSet;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @noBadges.
  ///
  /// In en, this message translates to:
  /// **'No badges earned yet'**
  String get noBadges;

  /// No description provided for @blockedCreators.
  ///
  /// In en, this message translates to:
  /// **'Blocked Creators'**
  String get blockedCreators;

  /// No description provided for @upgradeToApproved.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Approved Creator'**
  String get upgradeToApproved;

  /// No description provided for @unableToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Unable to load profile'**
  String get unableToLoadProfile;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @submitNews.
  ///
  /// In en, this message translates to:
  /// **'Submit News'**
  String get submitNews;

  /// No description provided for @submitReport.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submitReport;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @titleHint.
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get titleHint;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleRequired;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe what you witnessed in detail...'**
  String get descriptionHint;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @citySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search city...'**
  String get citySearchHint;

  /// No description provided for @cityRequired.
  ///
  /// In en, this message translates to:
  /// **'City is required'**
  String get cityRequired;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @coverImage.
  ///
  /// In en, this message translates to:
  /// **'Cover Image'**
  String get coverImage;

  /// No description provided for @coverImageRequired.
  ///
  /// In en, this message translates to:
  /// **'Cover image is required'**
  String get coverImageRequired;

  /// No description provided for @tapToAddCoverImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to add cover image'**
  String get tapToAddCoverImage;

  /// No description provided for @additionalImages.
  ///
  /// In en, this message translates to:
  /// **'Additional Images'**
  String get additionalImages;

  /// No description provided for @addMoreImages.
  ///
  /// In en, this message translates to:
  /// **'Add More Images'**
  String get addMoreImages;

  /// No description provided for @selectCoverImage.
  ///
  /// In en, this message translates to:
  /// **'Select Cover Image'**
  String get selectCoverImage;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get saveDraft;

  /// No description provided for @draftSaved.
  ///
  /// In en, this message translates to:
  /// **'Draft saved'**
  String get draftSaved;

  /// No description provided for @unsavedChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChangesTitle;

  /// No description provided for @unsavedChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved content. Would you like to save it as a draft?'**
  String get unsavedChangesMessage;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @submissionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Submission created successfully!'**
  String get submissionSuccess;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failedToPickImage;

  /// No description provided for @postedByYou.
  ///
  /// In en, this message translates to:
  /// **'Posted by You'**
  String get postedByYou;

  /// No description provided for @newsFeed.
  ///
  /// In en, this message translates to:
  /// **'News By You'**
  String get newsFeed;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @searchStories.
  ///
  /// In en, this message translates to:
  /// **'Search stories'**
  String get searchStories;

  /// No description provided for @searchStoriesHint.
  ///
  /// In en, this message translates to:
  /// **'Search stories...'**
  String get searchStoriesHint;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearches;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @searchForStories.
  ///
  /// In en, this message translates to:
  /// **'Search for stories'**
  String get searchForStories;

  /// No description provided for @noStoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No stories yet.\nBe the first to submit!'**
  String get noStoriesYet;

  /// No description provided for @noStoriesInCity.
  ///
  /// In en, this message translates to:
  /// **'No stories yet from {city}.\nBe the first reporter!'**
  String noStoriesInCity(String city);

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No stories found for \'{query}\''**
  String noSearchResults(String query);

  /// No description provided for @submitAStory.
  ///
  /// In en, this message translates to:
  /// **'Submit a Story'**
  String get submitAStory;

  /// No description provided for @filterByCity.
  ///
  /// In en, this message translates to:
  /// **'Filter by city'**
  String get filterByCity;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @confirmations.
  ///
  /// In en, this message translates to:
  /// **'{count} confirmations'**
  String confirmations(int count);

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'{count} likes'**
  String likes(int count);

  /// No description provided for @editorialQueue.
  ///
  /// In en, this message translates to:
  /// **'Editorial Queue'**
  String get editorialQueue;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @markCorrection.
  ///
  /// In en, this message translates to:
  /// **'Mark Correction'**
  String get markCorrection;

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get statusUnderReview;

  /// No description provided for @statusPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get statusPublished;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please try again.'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try later.'**
  String get serverError;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get unexpectedError;

  /// No description provided for @rateLimitError.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment.'**
  String get rateLimitError;

  /// No description provided for @accountSuspended.
  ///
  /// In en, this message translates to:
  /// **'Account is suspended. Contact support.'**
  String get accountSuspended;

  /// No description provided for @accountNotFound.
  ///
  /// In en, this message translates to:
  /// **'Account not found.'**
  String get accountNotFound;

  /// No description provided for @checkInput.
  ///
  /// In en, this message translates to:
  /// **'Please check your input and try again.'**
  String get checkInput;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile.'**
  String get failedToLoadProfile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @noNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'You will see updates about your stories, milestones, and community activity here.'**
  String get noNotificationsDescription;

  /// No description provided for @notificationStoryApproved.
  ///
  /// In en, this message translates to:
  /// **'Story Approved'**
  String get notificationStoryApproved;

  /// No description provided for @notificationStoryRejected.
  ///
  /// In en, this message translates to:
  /// **'Story Rejected'**
  String get notificationStoryRejected;

  /// No description provided for @notificationCorrectionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Correction Needed'**
  String get notificationCorrectionNeeded;

  /// No description provided for @notificationMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone Reached'**
  String get notificationMilestone;

  /// No description provided for @notificationBadge.
  ///
  /// In en, this message translates to:
  /// **'New Badge Earned'**
  String get notificationBadge;

  /// No description provided for @notificationTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending Story'**
  String get notificationTrending;

  /// No description provided for @notificationCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community Activity'**
  String get notificationCommunity;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPreferences;

  /// No description provided for @storyUpdates.
  ///
  /// In en, this message translates to:
  /// **'Story Updates'**
  String get storyUpdates;

  /// No description provided for @storyUpdatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Approved, rejected, and correction notifications'**
  String get storyUpdatesDesc;

  /// No description provided for @milestonesBadges.
  ///
  /// In en, this message translates to:
  /// **'Milestones & Badges'**
  String get milestonesBadges;

  /// No description provided for @milestonesBadgesDesc.
  ///
  /// In en, this message translates to:
  /// **'Achievement and level-up notifications'**
  String get milestonesBadgesDesc;

  /// No description provided for @trendingStoriesInCity.
  ///
  /// In en, this message translates to:
  /// **'Trending Stories in My City'**
  String get trendingStoriesInCity;

  /// No description provided for @trendingStoriesDesc.
  ///
  /// In en, this message translates to:
  /// **'When stories in your city are trending'**
  String get trendingStoriesDesc;

  /// No description provided for @communityActivity.
  ///
  /// In en, this message translates to:
  /// **'Community Activity'**
  String get communityActivity;

  /// No description provided for @communityActivityDesc.
  ///
  /// In en, this message translates to:
  /// **'Confirmations on your stories'**
  String get communityActivityDesc;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @defaultLanguage.
  ///
  /// In en, this message translates to:
  /// **'Default language'**
  String get defaultLanguage;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Mai Bhi Editor v1.0.0'**
  String get appVersion;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to News By You'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Become a citizen journalist! Report local news from your city and share stories that matter to your community.'**
  String get onboardingWelcomeDesc;

  /// No description provided for @onboardingAiTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Assists Your Writing'**
  String get onboardingAiTitle;

  /// No description provided for @onboardingAiDesc.
  ///
  /// In en, this message translates to:
  /// **'Our AI tool helps rephrase and structure your reports for clarity and readability. Write naturally and let AI polish it.'**
  String get onboardingAiDesc;

  /// No description provided for @onboardingEditorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Editors Verify'**
  String get onboardingEditorsTitle;

  /// No description provided for @onboardingEditorsDesc.
  ///
  /// In en, this message translates to:
  /// **'Every story goes through HT editorial review before publication. This ensures accuracy and builds trust in citizen journalism.'**
  String get onboardingEditorsDesc;

  /// No description provided for @onboardingReputationTitle.
  ///
  /// In en, this message translates to:
  /// **'Earn Reputation'**
  String get onboardingReputationTitle;

  /// No description provided for @onboardingReputationDesc.
  ///
  /// In en, this message translates to:
  /// **'Gain points, unlock badges, and level up from Basic Creator to Trusted Reporter. Your credibility grows with every published story.'**
  String get onboardingReputationDesc;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @acceptAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Accept & Continue'**
  String get acceptAndContinue;

  /// No description provided for @guidelinesCheckbox.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Community Guidelines and will report responsibly'**
  String get guidelinesCheckbox;

  /// No description provided for @pleaseAcceptGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Please accept the community guidelines to continue'**
  String get pleaseAcceptGuidelines;

  /// No description provided for @basicCreator.
  ///
  /// In en, this message translates to:
  /// **'Basic Creator'**
  String get basicCreator;

  /// No description provided for @htApprovedCreator.
  ///
  /// In en, this message translates to:
  /// **'HT Approved Creator'**
  String get htApprovedCreator;

  /// No description provided for @trustedReporter.
  ///
  /// In en, this message translates to:
  /// **'Trusted Reporter'**
  String get trustedReporter;

  /// No description provided for @mySubmissions.
  ///
  /// In en, this message translates to:
  /// **'My Submissions'**
  String get mySubmissions;

  /// No description provided for @aiPreview.
  ///
  /// In en, this message translates to:
  /// **'AI Preview'**
  String get aiPreview;

  /// No description provided for @kycUpload.
  ///
  /// In en, this message translates to:
  /// **'KYC Verification'**
  String get kycUpload;

  /// No description provided for @creatorProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Creator Profile'**
  String get creatorProfileTitle;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found: {uri}'**
  String pageNotFound(String uri);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
