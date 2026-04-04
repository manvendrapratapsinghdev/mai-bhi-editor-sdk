# Mai Bhi Editor SDK

Citizen journalism SDK for Flutter apps. Drop-in package that provides news feed, story submission, community features, editorial workflow, and more.

## Features

- News feed with search, city filter, and trending stories
- Story detail with like, confirm, and report actions
- Story submission with image upload and AI processing
- Editorial queue and review workflow
- Creator profiles and community features
- KYC verification flow
- Admin dashboard
- Push notifications
- Multi-language support (English, Hindi)
- Theming via pluggable design system

## Requirements

- Flutter >= 3.0.0
- Dart SDK >= 3.11.3

---

## How to Implement

### Step 1: Add the SDK dependency

Add to your app's `pubspec.yaml`:

```yaml
dependencies:
  mai_bhi_editor_sdk:
    git:
      url: https://github.com/manvendrapratapsinghdev/mai-bhi-editor-sdk.git
      ref: v1.0.2
```

Then run:

```bash
flutter pub get
```

### Step 2: Implement AuthProvider

The SDK does **not** include login/register screens. Your app owns all auth UI.

Create a class that implements the `AuthProvider` interface. This bridges your app's auth system to the SDK:

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:mai_bhi_editor_sdk/mai_bhi_editor.dart';

class MyAuthProvider implements AuthProvider {
  final FlutterSecureStorage _storage;
  final _statusController = StreamController<AuthStatus>.broadcast();

  AuthStatus _authStatus = AuthStatus.unauthenticated;
  MbeUser? _currentUser;

  MyAuthProvider() : _storage = const FlutterSecureStorage();

  // ── Required getters ──────────────────────────────────────────────

  @override
  AuthStatus get authStatus => _authStatus;

  @override
  MbeUser? get currentUser => _currentUser;

  @override
  Stream<AuthStatus> get authStatusStream => _statusController.stream;

  // ── Token management ──────────────────────────────────────────────

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  @override
  Future<String?> refreshToken() async {
    final refresh = await _storage.read(key: 'refresh_token');
    if (refresh == null) return null;

    try {
      final dio = Dio(BaseOptions(baseUrl: MaiBhiEditor.baseUrl));
      final response = await dio.post('/auth/refresh', data: {
        'refresh_token': refresh,
      });
      if (response.statusCode == 200) {
        final newToken = response.data['access_token'] as String;
        await _storage.write(key: 'access_token', value: newToken);
        return newToken;
      }
    } catch (_) {}
    return null;
  }

  // ── Login request (SDK calls this when auth is needed) ────────────
  //
  // The SDK calls requestLogin() when a user taps a gated action
  // (like, confirm, submit, etc.) without being logged in.
  //
  // Your app should:
  //   1. Show your login screen
  //   2. Return true if login succeeded, false if user cancelled
  //   3. The SDK will then resume the interrupted action
  //

  @override
  Future<bool> requestLogin() async {
    final nav = MaiBhiEditor.navigatorKey.currentState;
    if (nav == null) return false;

    final result = await nav.push<bool>(
      MaterialPageRoute(
        builder: (_) => const YourLoginScreen(), // <-- your login screen
        fullscreenDialog: true,
      ),
    );
    return result == true;
  }

  // ── Logout ────────────────────────────────────────────────────────

  @override
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    _authStatus = AuthStatus.unauthenticated;
    _currentUser = null;
    _statusController.add(_authStatus);
  }

  // ── Helper: call this after your login screen succeeds ────────────

  Future<void> onLoginSuccess({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> userData,
  }) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
    _currentUser = MbeUser(
      id: userData['id']?.toString() ?? '',
      name: userData['name'] as String? ?? '',
      email: userData['email'] as String? ?? '',
      avatarUrl: userData['avatar_url'] as String?,
      city: userData['city'] as String?,
      creatorLevel: userData['creator_level'] as String? ?? 'basic_creator',
      reputationPoints: userData['reputation_points'] as int? ?? 0,
      storiesPublished: userData['stories_published'] as int? ?? 0,
      badges: (userData['badges'] as List<dynamic>?)
              ?.map((b) => b.toString())
              .toList() ??
          [],
    );
    _authStatus = AuthStatus.authenticated;
    _statusController.add(_authStatus);
  }

  void dispose() => _statusController.close();
}
```

### Step 3: Initialize the SDK in main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mai_bhi_editor_sdk/mai_bhi_editor.dart';

late final MyAuthProvider authProvider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Create your auth provider
  authProvider = MyAuthProvider();

  // Initialize the SDK
  await MaiBhiEditor.initialize(
    authProvider: authProvider,
    baseUrl: 'https://your-api.com/v1',
  );

  runApp(const MyApp());
}
```

### Step 4: Use the SDK in your app

You have two options:

#### Option A: Use SDK router (recommended - gets you everything)

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaiBhiEditor.wrap(
      child: MaterialApp.router(
        title: 'My News App',
        theme: AppTheme.light,          // your theme
        darkTheme: AppTheme.dark,       // your theme
        routerConfig: MaiBhiEditor.router,  // SDK handles all routes
      ),
    );
  }
}
```

This gives you all screens automatically:
- `/feed` - News feed with search, city filter, trending
- `/feed/:id` - Story detail with like, confirm, share, report
- `/submit` - Story submission with image upload
- `/my-submissions` - User's submissions list
- `/editorial` - Editorial review queue
- `/profile` - User profile
- `/notifications` - Notifications
- `/settings` - Settings with language, privacy, account deletion
- `/kyc` - KYC verification
- `/creators/:id` - Public creator profiles
- `/admin` - Admin dashboard (requires admin badge)
- And more...

#### Option B: Embed individual SDK screens in your own router

```dart
import 'package:mai_bhi_editor_sdk/mai_bhi_editor.dart';

// In your GoRouter config:
GoRoute(
  path: '/feed',
  builder: (context, state) => MbeScreens.feed(),
),
GoRoute(
  path: '/feed/:id',
  builder: (context, state) =>
      MbeScreens.storyDetail(state.pathParameters['id']!),
),
GoRoute(
  path: '/submit',
  builder: (context, state) => MbeScreens.submissionForm(),
),
GoRoute(
  path: '/profile',
  builder: (context, state) => MbeScreens.profile(),
),
// ... add as many SDK screens as you need
```

### Step 5: Wire your login screen

Your login screen should pop with `true` on success:

```dart
class YourLoginScreen extends StatelessWidget {
  const YourLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false), // cancelled
        ),
      ),
      body: // ... your login form ...
      // On successful login:
      // 1. Call authProvider.onLoginSuccess(accessToken: ..., refreshToken: ..., userData: ...)
      // 2. Then: Navigator.of(context).pop(true)
    );
  }
}
```

---

## Auth Model

The SDK treats auth as **optional**:

| Action | Auth Required? |
|--------|---------------|
| View feed, stories, creator profiles | No |
| Like a story | Yes |
| Confirm/verify a story | Yes |
| Report a story | Yes |
| Submit a story | Yes |
| View notifications | Yes |
| View profile/settings | Yes |
| Admin dashboard | Yes (admin badge) |

When an unauthenticated user taps a gated action:
1. SDK calls `authProvider.requestLogin()`
2. Your app shows its login UI
3. User logs in (or cancels)
4. Your app returns `true` (success) or `false` (cancelled)
5. SDK resumes the action automatically on success

## Auth Flow Diagram

```
User taps "Like" (not logged in)
        |
        v
SDK calls authProvider.requestLogin()
        |
        v
Your app pushes LoginScreen as modal
        |
   +---------+---------+
   |                   |
   v                   v
User logs in        User cancels
   |                   |
   v                   v
Pop with true       Pop with false
   |                   |
   v                   v
SDK resumes Like    Nothing happens
```

## Theming

Use your own theme or provide a custom `DesignSystem`:

```dart
await MaiBhiEditor.initialize(
  authProvider: myAuthProvider,
  baseUrl: 'https://your-api.com/v1',
  designSystem: MyCustomDesignSystem(), // optional
);
```

Or use SDK's built-in themes:

```dart
MaterialApp.router(
  theme: MaiBhiEditor.lightTheme,
  darkTheme: MaiBhiEditor.darkTheme,
  routerConfig: MaiBhiEditor.router,
)
```

## Available Screens (MbeScreens)

| Method | Description |
|--------|-------------|
| `MbeScreens.feed()` | News feed with search, filter, trending |
| `MbeScreens.storyDetail(id)` | Full story with interactions |
| `MbeScreens.submissionForm()` | Create/edit story submission |
| `MbeScreens.mySubmissions()` | User's submissions list |
| `MbeScreens.aiPreview(id)` | AI review preview |
| `MbeScreens.editorialQueue()` | Editorial review queue |
| `MbeScreens.editorialReview(id)` | Single editorial review |
| `MbeScreens.profile()` | User profile |
| `MbeScreens.creatorProfile(id)` | Public creator profile |
| `MbeScreens.blockedCreators()` | Blocked creators list |
| `MbeScreens.notifications()` | Notifications list |
| `MbeScreens.settings()` | Settings screen |
| `MbeScreens.kycUpload()` | KYC document upload |
| `MbeScreens.onboarding()` | Onboarding flow |
| `MbeScreens.adminDashboard()` | Admin dashboard |
| `MbeScreens.adminReports()` | Admin reports |
| `MbeScreens.adminUsers()` | Admin user management |
| `MbeScreens.editorAnalytics()` | Editor analytics |

## Route Constants (MbeRoutes)

```dart
MbeRoutes.feed             // '/feed'
MbeRoutes.storyDetail      // '/feed/:id'
MbeRoutes.submit           // '/submit'
MbeRoutes.mySubmissions    // '/my-submissions'
MbeRoutes.profile          // '/profile'
MbeRoutes.notifications    // '/notifications'
MbeRoutes.settings         // '/settings'
MbeRoutes.creatorProfile   // '/creators/:id'
MbeRoutes.kycUpload        // '/kyc'
MbeRoutes.onboarding       // '/onboarding'
MbeRoutes.adminDashboard   // '/admin'
// ... and more
```

## License

Copyright (c) 2026 Hindustan Times Digital Streams Ltd. All rights reserved.
