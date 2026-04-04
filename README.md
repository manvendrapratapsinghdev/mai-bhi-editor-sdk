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

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  mai_bhi_editor_sdk:
    git:
      url: https://github.com/AskHT/mai-bhi-editor-sdk.git
      ref: v1.0.0
```

## Quick Start

### 1. Implement AuthProvider

The SDK does **not** include login/register screens. Your app owns all auth UI. Implement the `AuthProvider` interface to bridge your auth system:

```dart
import 'package:mai_bhi_editor_sdk/mai_bhi_editor.dart';

class MyAuthProvider implements AuthProvider {
  @override
  AuthStatus get authStatus => _authStatus;

  @override
  MbeUser? get currentUser => _currentUser;

  @override
  Stream<AuthStatus> get authStatusStream => _statusController.stream;

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  @override
  Future<String?> refreshToken() async {
    // Call your refresh endpoint, return new access token or null
  }

  @override
  Future<bool> requestLogin() async {
    // Show your login UI. Return true if login succeeded, false if cancelled.
    // The SDK calls this when the user taps a gated action (like, submit, etc.)
    final result = await navigator.push(MyLoginScreen.route());
    return result == true;
  }

  @override
  Future<void> logout() async {
    await _storage.deleteAll();
    _authStatus = AuthStatus.unauthenticated;
    _statusController.add(_authStatus);
  }
}
```

### 2. Initialize the SDK

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = MyAuthProvider();
  await authProvider.init();

  await MaiBhiEditor.initialize(
    authProvider: authProvider,
    baseUrl: 'https://api.yourapp.com/v1',
  );

  runApp(MyApp());
}
```

### 3. Use the SDK

**Mode A** - Use SDK router as your app router:

```dart
MaterialApp.router(
  routerConfig: MaiBhiEditor.router,
)
```

**Mode B** - Embed SDK screens in your own router:

```dart
GoRoute(
  path: '/feed',
  builder: (context, state) => MbeScreens.feed(),
),
GoRoute(
  path: '/feed/:id',
  builder: (context, state) => MbeScreens.storyDetail(state.pathParameters['id']!),
),
```

## Auth Model

The SDK treats auth as **optional**:

- **Viewing** (feed, stories, creator profiles) works without auth
- **Actions** (like, confirm, report, submit) require auth
- When an unauthenticated user taps a gated action, the SDK calls `authProvider.requestLogin()`
- Your app shows its login UI, and returns `true` on success
- The SDK resumes the action automatically

## Theming

Provide a custom `DesignSystem` to match your brand:

```dart
await MaiBhiEditor.initialize(
  authProvider: myAuthProvider,
  baseUrl: 'https://api.yourapp.com/v1',
  designSystem: MyDesignSystem(),
);
```

## Requirements

- Flutter >= 3.0.0
- Dart SDK >= 3.11.3
