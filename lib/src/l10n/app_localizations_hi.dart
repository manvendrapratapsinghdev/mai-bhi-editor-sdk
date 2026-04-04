// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'मैं भी एडिटर';

  @override
  String get login => 'लॉगिन';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get loginButton => 'साइन इन';

  @override
  String get loginError => 'अमान्य ईमेल या पासवर्ड';

  @override
  String get loginSubtitle => 'हिंदुस्तान टाइम्स द्वारा नागरिक पत्रकारिता';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get emailRequired => 'ईमेल आवश्यक है';

  @override
  String get emailInvalid => 'एक वैध ईमेल पता दर्ज करें';

  @override
  String get passwordRequired => 'पासवर्ड आवश्यक है';

  @override
  String get passwordTooShort => 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए';

  @override
  String get signingIn => 'साइन इन हो रहा है, कृपया प्रतीक्षा करें';

  @override
  String get termsFooter =>
      'साइन इन करके, आप HT सेवा की शर्तों से सहमत होते हैं।';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get logoutConfirmTitle => 'लॉग आउट';

  @override
  String get logoutConfirmMessage => 'क्या आप वाकई लॉग आउट करना चाहते हैं?';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get myProfile => 'मेरी प्रोफ़ाइल';

  @override
  String get reputation => 'प्रतिष्ठा';

  @override
  String get published => 'प्रकाशित';

  @override
  String get cityLabel => 'शहर';

  @override
  String get cityNotSet => 'सेट नहीं है';

  @override
  String get level => 'स्तर';

  @override
  String get badges => 'बैज';

  @override
  String get noBadges => 'अभी तक कोई बैज अर्जित नहीं किया';

  @override
  String get blockedCreators => 'अवरुद्ध निर्माता';

  @override
  String get upgradeToApproved => 'स्वीकृत निर्माता में अपग्रेड करें';

  @override
  String get unableToLoadProfile => 'प्रोफ़ाइल लोड करने में असमर्थ';

  @override
  String get submit => 'जमा करें';

  @override
  String get submitNews => 'समाचार जमा करें';

  @override
  String get submitReport => 'रिपोर्ट जमा करें';

  @override
  String get title => 'शीर्षक';

  @override
  String get titleHint => 'क्या हुआ?';

  @override
  String get titleRequired => 'शीर्षक आवश्यक है';

  @override
  String get description => 'विवरण';

  @override
  String get descriptionHint => 'जो आपने देखा उसका विस्तार से वर्णन करें...';

  @override
  String get descriptionRequired => 'विवरण आवश्यक है';

  @override
  String get city => 'शहर';

  @override
  String get citySearchHint => 'शहर खोजें...';

  @override
  String get cityRequired => 'शहर आवश्यक है';

  @override
  String get tags => 'टैग';

  @override
  String get coverImage => 'कवर छवि';

  @override
  String get coverImageRequired => 'कवर छवि आवश्यक है';

  @override
  String get tapToAddCoverImage => 'कवर छवि जोड़ने के लिए टैप करें';

  @override
  String get additionalImages => 'अतिरिक्त छवियाँ';

  @override
  String get addMoreImages => 'और छवियाँ जोड़ें';

  @override
  String get selectCoverImage => 'कवर छवि चुनें';

  @override
  String get addImage => 'छवि जोड़ें';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String get saveDraft => 'ड्राफ़्ट सहेजें';

  @override
  String get draftSaved => 'ड्राफ़्ट सहेजा गया';

  @override
  String get unsavedChangesTitle => 'सहेजे नहीं गए परिवर्तन';

  @override
  String get unsavedChangesMessage =>
      'आपके पास सहेजी नहीं गई सामग्री है। क्या आप इसे ड्राफ़्ट के रूप में सहेजना चाहेंगे?';

  @override
  String get discard => 'छोड़ें';

  @override
  String get submissionSuccess => 'सबमिशन सफलतापूर्वक बनाया गया!';

  @override
  String get failedToPickImage => 'छवि चुनने में विफल';

  @override
  String get postedByYou => 'आपकी पोस्ट';

  @override
  String get newsFeed => 'आपकी ख़बरें';

  @override
  String get trending => 'ट्रेंडिंग';

  @override
  String get searchStories => 'कहानियाँ खोजें';

  @override
  String get searchStoriesHint => 'कहानियाँ खोजें...';

  @override
  String get recentSearches => 'हाल की खोजें';

  @override
  String get clearAll => 'सभी साफ़ करें';

  @override
  String get searchForStories => 'कहानियाँ खोजें';

  @override
  String get noStoriesYet =>
      'अभी तक कोई कहानियाँ नहीं।\nपहले सबमिट करने वाले बनें!';

  @override
  String noStoriesInCity(String city) {
    return '$city से अभी तक कोई कहानियाँ नहीं।\nपहले रिपोर्टर बनें!';
  }

  @override
  String noSearchResults(String query) {
    return '\'$query\' के लिए कोई कहानियाँ नहीं मिलीं';
  }

  @override
  String get submitAStory => 'एक कहानी सबमिट करें';

  @override
  String get filterByCity => 'शहर के अनुसार फ़िल्टर';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get like => 'पसंद';

  @override
  String get share => 'शेयर';

  @override
  String confirmations(int count) {
    return '$count पुष्टियाँ';
  }

  @override
  String likes(int count) {
    return '$count पसंद';
  }

  @override
  String get editorialQueue => 'संपादकीय कतार';

  @override
  String get approve => 'स्वीकृत';

  @override
  String get reject => 'अस्वीकृत';

  @override
  String get edit => 'संपादित करें';

  @override
  String get markCorrection => 'सुधार चिह्नित करें';

  @override
  String get statusDraft => 'ड्राफ़्ट';

  @override
  String get statusInProgress => 'प्रगति में';

  @override
  String get statusUnderReview => 'समीक्षा में';

  @override
  String get statusPublished => 'प्रकाशित';

  @override
  String get statusRejected => 'अस्वीकृत';

  @override
  String get noResults => 'कोई परिणाम नहीं मिला';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get networkError => 'नेटवर्क त्रुटि। कृपया पुनः प्रयास करें।';

  @override
  String get serverError => 'सर्वर त्रुटि। कृपया बाद में प्रयास करें।';

  @override
  String get unexpectedError =>
      'एक अप्रत्याशित त्रुटि हुई। कृपया पुनः प्रयास करें।';

  @override
  String get rateLimitError =>
      'बहुत अधिक प्रयास। कृपया कुछ देर प्रतीक्षा करें।';

  @override
  String get accountSuspended => 'खाता निलंबित है। सहायता से संपर्क करें।';

  @override
  String get accountNotFound => 'खाता नहीं मिला।';

  @override
  String get checkInput => 'कृपया अपना इनपुट जाँचें और पुनः प्रयास करें।';

  @override
  String get failedToLoadProfile => 'प्रोफ़ाइल लोड करने में विफल।';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String get markAllRead => 'सभी पढ़ी गईं';

  @override
  String get noNotificationsYet => 'अभी तक कोई सूचनाएँ नहीं';

  @override
  String get noNotificationsDescription =>
      'आपकी कहानियों, उपलब्धियों और सामुदायिक गतिविधि के बारे में अपडेट यहाँ दिखाई देंगे।';

  @override
  String get notificationStoryApproved => 'कहानी स्वीकृत';

  @override
  String get notificationStoryRejected => 'कहानी अस्वीकृत';

  @override
  String get notificationCorrectionNeeded => 'सुधार आवश्यक';

  @override
  String get notificationMilestone => 'मील का पत्थर पहुँचा';

  @override
  String get notificationBadge => 'नया बैज अर्जित';

  @override
  String get notificationTrending => 'ट्रेंडिंग कहानी';

  @override
  String get notificationCommunity => 'सामुदायिक गतिविधि';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get notificationPreferences => 'सूचना प्राथमिकताएँ';

  @override
  String get storyUpdates => 'कहानी अपडेट';

  @override
  String get storyUpdatesDesc => 'स्वीकृत, अस्वीकृत और सुधार सूचनाएँ';

  @override
  String get milestonesBadges => 'उपलब्धियाँ और बैज';

  @override
  String get milestonesBadgesDesc => 'उपलब्धि और लेवल-अप सूचनाएँ';

  @override
  String get trendingStoriesInCity => 'मेरे शहर की ट्रेंडिंग कहानियाँ';

  @override
  String get trendingStoriesDesc => 'जब आपके शहर की कहानियाँ ट्रेंड कर रही हों';

  @override
  String get communityActivity => 'सामुदायिक गतिविधि';

  @override
  String get communityActivityDesc => 'आपकी कहानियों पर पुष्टियाँ';

  @override
  String get language => 'भाषा';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get defaultLanguage => 'डिफ़ॉल्ट भाषा';

  @override
  String get appVersion => 'मैं भी एडिटर v1.0.0';

  @override
  String get onboardingWelcomeTitle => 'न्यूज़ बाय यू में आपका स्वागत है';

  @override
  String get onboardingWelcomeDesc =>
      'नागरिक पत्रकार बनें! अपने शहर से स्थानीय समाचार रिपोर्ट करें और ऐसी कहानियाँ साझा करें जो आपके समुदाय के लिए महत्वपूर्ण हैं।';

  @override
  String get onboardingAiTitle => 'AI आपके लेखन में मदद करता है';

  @override
  String get onboardingAiDesc =>
      'हमारा AI टूल आपकी रिपोर्ट को स्पष्टता और पठनीयता के लिए पुनर्गठित करने में मदद करता है। स्वाभाविक रूप से लिखें और AI को इसे बेहतर बनाने दें।';

  @override
  String get onboardingEditorsTitle => 'संपादक सत्यापित करते हैं';

  @override
  String get onboardingEditorsDesc =>
      'प्रकाशन से पहले हर कहानी HT संपादकीय समीक्षा से गुज़रती है। यह सटीकता सुनिश्चित करता है और नागरिक पत्रकारिता में विश्वास बनाता है।';

  @override
  String get onboardingReputationTitle => 'प्रतिष्ठा अर्जित करें';

  @override
  String get onboardingReputationDesc =>
      'अंक प्राप्त करें, बैज अनलॉक करें, और बेसिक क्रिएटर से ट्रस्टेड रिपोर्टर तक लेवल अप करें। हर प्रकाशित कहानी से आपकी विश्वसनीयता बढ़ती है।';

  @override
  String get skip => 'छोड़ें';

  @override
  String get next => 'अगला';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get acceptAndContinue => 'स्वीकार करें और जारी रखें';

  @override
  String get guidelinesCheckbox =>
      'मैं सामुदायिक दिशानिर्देशों से सहमत हूँ और ज़िम्मेदारी से रिपोर्ट करूँगा';

  @override
  String get pleaseAcceptGuidelines =>
      'जारी रखने के लिए कृपया सामुदायिक दिशानिर्देश स्वीकार करें';

  @override
  String get basicCreator => 'बेसिक क्रिएटर';

  @override
  String get htApprovedCreator => 'HT अप्रूव्ड क्रिएटर';

  @override
  String get trustedReporter => 'ट्रस्टेड रिपोर्टर';

  @override
  String get mySubmissions => 'मेरी सबमिशन';

  @override
  String get aiPreview => 'AI प्रीव्यू';

  @override
  String get kycUpload => 'KYC सत्यापन';

  @override
  String get creatorProfileTitle => 'निर्माता प्रोफ़ाइल';

  @override
  String pageNotFound(String uri) {
    return 'पेज नहीं मिला: $uri';
  }
}
