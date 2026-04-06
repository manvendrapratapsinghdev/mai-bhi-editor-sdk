# Mai Bhi Editor SDK — Integration Guide

> **SDK Repository:** https://github.com/manvendrapratapsinghdev/mai-bhi-editor-sdk  
> **Host App Repository:** https://github.com/manvendrapratapsinghdev/Mai_bhi_Editor  
> **Latest stable tag:** `v1.0.3`

---

## Table of Contents

1. [Overview](#1-overview)
2. [Add the SDK dependency](#2-add-the-sdk-dependency)
3. [Implement AuthProvider](#3-implement-authprovider)
4. [Initialize the SDK in main.dart](#4-initialize-the-sdk-in-maindart)
5. [Wire the router in app.dart](#5-wire-the-router-in-appdart)
6. [Dependency injection setup](#6-dependency-injection-setup)
7. [Custom theming (optional)](#7-custom-theming-optional)
8. [Localization](#8-localization)
9. [Navigate to SDK screens](#9-navigate-to-sdk-screens)
10. [Dev token bypass](#10-dev-token-bypass)
11. [Environment / API URL config](#11-environment--api-url-config)
12. [Troubleshooting](#12-troubleshooting)

---

## 1. Overview

The `mai_bhi_editor_sdk` is a self-contained Flutter package that delivers the
full citizen-journalism feature set (feed, submissions, editorial queue, admin,
notifications, KYC, etc.) as a **plug-in router**. The host app owns:

- Authentication (token from HT SSO)
- Top-level `MaterialApp` theme
- Any screens outside the SDK (splash, onboarding shell, etc.)

The SDK owns:
- All routes under `/feed`, `/submit`, `/profile`, `/editorial`, `/admin`, …
- Its own isolated GetIt container (does **not** pollute the host's `sl`)
- HTTP client with an auth interceptor that calls back into the host

```
Host App
├── main.dart          ← SDK.initialize() + AuthProvider setup
├── app.dart           ← MaterialApp.router( routerConfig: MaiBhiEditor.router )
├── my_auth_provider.dart  ← implements AuthProvider (you write this)
└── injection.dart     ← host-only DI (Dio, SecureStorage)

SDK (imported package)
├── Feed, Submissions, Editorial, Admin, Profile, KYC, Notifications …
├── Isolated GetIt DI
├── GoRouter with auth guards
└── Dio with MbeAuthInterceptor → calls AuthProvider.getAuthHeaders()
```

---

## 2. Add the SDK dependency

### Production (git tag)

```yaml
# pubspec.yaml
dependencies:
  mai_bhi_editor_sdk:
    git:
      url: https://github.com/manvendrapratapsinghdev/mai-bhi-editor-sdk.git
      ref: v1.0.3          # pin to a stable tag
```

### Local development (path)

```yaml
dependencies:
  mai_bhi_editor_sdk:
    path: ../mai-bhi-editor-sdk   # relative path to the cloned SDK repo
```

Then run:

```bash
flutter pub get
```

---

## 3. Implement AuthProvider

The SDK never handles login itself. You must implement the `AuthProvider`
interface so the SDK can attach HT auth headers to every request and
react to 401 responses.

### 3a. Interface contract

```dart
abstract class AuthProvider {
  // ── Synchronous (used by GoRouter redirect guard) ─────────────
  AuthStatus get authStatus;   // authenticated | unauthenticated | unknown
  MbeUser?   get currentUser;  // null when unauthenticated

  // ── Async ─────────────────────────────────────────────────────
  /// Return headers to attach to EVERY SDK HTTP request.
  /// Must include Authorization, X-Client, X-Platform.
  /// Return {} when unauthenticated.
  Future<Map<String, String>> getAuthHeaders();

  /// SDK calls this when it gets a 401. Show login UI or trigger
  /// parent-app token refresh. Return true if re-authenticated.
  Future<bool> requestLogin();

  /// Called when user taps "Logout" inside SDK screens.
  Future<void> logout();

  /// Stream that fires whenever auth status changes (for nav guards).
  Stream<AuthStatus> get authStatusStream;
}
```

### 3b. Concrete implementation — `my_auth_provider.dart`

```dart
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mai_bhi_editor_sdk/mai_bhi_editor.dart';

class MyAuthProvider implements AuthProvider {
  final Dio _dio;
  final String _xClient;           // Your HT app client ID, e.g. "1006"
  final FlutterSecureStorage _store;
  final _statusCtrl = StreamController<AuthStatus>.broadcast();

  static const _tokenKey = 'ht_user_token';

  AuthStatus _status = AuthStatus.unknown;
  MbeUser?   _user;
  String?    _token;

  MyAuthProvider({
    required Dio dio,
    required String xClient,
    FlutterSecureStorage? secureStorage,
  })  : _dio = dio,
        _xClient = xClient,
        _store = secureStorage ?? const FlutterSecureStorage();

  // ── AuthProvider interface ──────────────────────────────────────

  @override AuthStatus         get authStatus       => _status;
  @override MbeUser?           get currentUser      => _user;
  @override Stream<AuthStatus> get authStatusStream => _statusCtrl.stream;

  @override
  Future<Map<String, String>> getAuthHeaders() async {
    if (_token == null) return const {};
    return {
      'Authorization': _token!,                          // raw token, NOT "Bearer …"
      'X-Client':      _xClient,
      'X-Platform':    Platform.isIOS ? 'iOS' : 'Android',
    };
  }

  @override
  Future<bool> requestLogin() async {
    // This app has no in-app login — parent HT app owns auth.
    // If you have a login screen, push it here and return the result.
    debugPrint('[MyAuthProvider] token required — waiting for HT handoff');
    _setStatus(AuthStatus.unauthenticated);
    return false;
  }

  @override
  Future<void> logout() => setHtToken(null);

  // ── Lifecycle ──────────────────────────────────────────────────

  /// Call once in main() before SDK.initialize().
  /// Reads any persisted token and re-hydrates the user profile.
  Future<void> init() async {
    final saved = await _store.read(key: _tokenKey);
    if (saved == null || saved.isEmpty) {
      _setStatus(AuthStatus.unauthenticated);
      return;
    }
    _token = saved;
    final ok = await _hydrateProfile();
    if (!ok) {
      await _store.delete(key: _tokenKey);
      _token = null;
      _setStatus(AuthStatus.unauthenticated);
    }
  }

  // ── Token handoff (called by parent HT app or dev bypass) ─────

  /// Inject the HT user token.
  /// Pass null to clear (= logout).
  Future<void> setHtToken(String? token) async {
    if (token == null || token.isEmpty) {
      await _store.delete(key: _tokenKey);
      _token = null;
      _user  = null;
      _setStatus(AuthStatus.unauthenticated);
      return;
    }
    await _store.write(key: _tokenKey, value: token);
    _token = token;
    final ok = await _hydrateProfile();
    if (!ok) {
      await _store.delete(key: _tokenKey);
      _token = null;
      _setStatus(AuthStatus.unauthenticated);
    }
  }

  // ── Private helpers ────────────────────────────────────────────

  Future<bool> _hydrateProfile() async {
    try {
      final res = await _dio.get(
        '/auth/profile',
        options: Options(headers: await getAuthHeaders()),
      );
      if (res.statusCode == 200 && res.data is Map) {
        _user = _parseUser(res.data as Map<String, dynamic>);
        _setStatus(AuthStatus.authenticated);
        return true;
      }
    } catch (e) {
      debugPrint('[MyAuthProvider] profile fetch failed: $e');
    }
    return false;
  }

  void _setStatus(AuthStatus s) {
    _status = s;
    _statusCtrl.add(s);
  }

  MbeUser _parseUser(Map<String, dynamic> d) => MbeUser(
    id:               d['id']?.toString() ?? '',
    name:             d['name']            as String? ?? '',
    email:            d['email']           as String? ?? '',
    avatarUrl:        d['avatar_url']      as String?,
    city:             d['city']            as String?,
    creatorLevel:     d['creator_level']   as String? ?? 'basic_creator',
    reputationPoints: d['reputation_points'] as int? ?? 0,
    storiesPublished: d['stories_published'] as int? ?? 0,
    badges: (d['badges'] as List<dynamic>?)
        ?.map((b) => b.toString())
        .toList() ?? const [],
  );

  void dispose() => _statusCtrl.close();
}
```

---

## 4. Initialize the SDK in main.dart

```dart
// lib/main.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mai_bhi_editor_sdk/mai_bhi_editor.dart';

import 'app.dart';
import 'core/constants/api_constants.dart';
import 'injection.dart';           // host-app DI (see §6)
import 'my_auth_provider.dart';

// ── Globals ──────────────────────────────────────────────────────
late final MyAuthProvider authProvider;

/// Dev-only: inject via `flutter run --dart-define=HT_USER_TOKEN=dev:ht-seed-alice`
/// Empty in production builds.
const _devToken = String.fromEnvironment('HT_USER_TOKEN');

/// HT client ID for this host app.
const _xClient = '1006';

// ── Bootstrap ────────────────────────────────────────────────────
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 1. Host-app DI (registers Dio + FlutterSecureStorage)
  await configureHostDependencies();

  // 2. Create + warm-up auth provider
  authProvider = MyAuthProvider(
    dio:           sl<Dio>(),
    xClient:       _xClient,
    secureStorage: sl<FlutterSecureStorage>(),
  );
  await authProvider.init();   // reads persisted token

  // 3. Initialize SDK
  await MaiBhiEditor.initialize(
    authProvider: authProvider,
    baseUrl:      ApiConstants.baseUrl,
    // Optional overrides:
    // designSystem:    MyDesignSystem(),
    // connectTimeout:  Duration(seconds: 10),
    // enableAnalytics: true,
    // cities:          ['Mumbai', 'Delhi', 'Bangalore'],
  );

  // 4. Dev bypass: inject seed token so you can test without real HT SSO
  if (!kReleaseMode && _devToken.isNotEmpty) {
    await authProvider.setHtToken(_devToken);
  }

  runApp(const MaiBhiEditorApp());
}
```

---

## 5. Wire the router in app.dart

```dart
// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mai_bhi_editor_sdk/mai_bhi_editor.dart';

import 'core/theme/app_theme.dart';

class MaiBhiEditorApp extends StatelessWidget {
  const MaiBhiEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaiBhiEditor.wrap() injects DesignSystemScope — required for SDK widgets.
    return MaiBhiEditor.wrap(
      child: MaterialApp.router(
        title: 'Mai Bhi Editor',
        debugShowCheckedModeBanner: false,

        // ── Theme (host app owns it) ────────────────────────────────
        theme:     AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,

        // ── All routing delegated to SDK ────────────────────────────
        routerConfig: MaiBhiEditor.router,

        // ── Localization ────────────────────────────────────────────
        supportedLocales: const [Locale('en'), Locale('hi')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
```

> ⚠️ **Do NOT** provide your own `GoRouter`. Calling `MaiBhiEditor.router`
> returns the SDK's router which already has auth guards and all routes wired up.

---

## 6. Dependency injection setup

The host app needs its own minimal DI for Dio and FlutterSecureStorage.
Keep this **separate** from the SDK's internal container.

```dart
// lib/injection.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/constants/api_constants.dart';

final GetIt sl = GetIt.instance;   // host-app container only

Future<void> configureHostDependencies() async {
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<Dio>(() => Dio(
    BaseOptions(
      baseUrl:        ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  ));
}
```

---

## 7. Custom theming (optional)

The SDK ships with an HT-branded default design system. Override any token:

```dart
import 'package:mai_bhi_editor_sdk/mai_bhi_editor.dart';

await MaiBhiEditor.initialize(
  authProvider: authProvider,
  baseUrl:      ApiConstants.baseUrl,
  designSystem: const DefaultDesignSystem().copyWith(
    primaryColor:     Color(0xFF0A3D91),  // your brand blue
    headingFontFamily: 'Neue Haas Grotesk',
    bodyFontFamily:   'Source Serif Pro',
    radiusMd:         12.0,
  ),
);
```

You can also use the SDK's generated `ThemeData` in your host `MaterialApp`:

```dart
theme:     MaiBhiEditor.lightTheme,
darkTheme: MaiBhiEditor.darkTheme,
```

---

## 8. Localization

The SDK includes English and Hindi strings. The host app only needs to
provide the standard Material/Cupertino delegates (already shown in §5).
The SDK manages its own `AppLocalizations` internally — you do **not** need
to add the SDK's l10n delegates manually.

```dart
supportedLocales: const [Locale('en'), Locale('hi')],
localizationsDelegates: const [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
],
```

---

## 9. Navigate to SDK screens

All navigation uses standard `go_router` context extensions — no special
SDK method is needed.

```dart
import 'package:go_router/go_router.dart';
import 'package:mai_bhi_editor_sdk/mai_bhi_editor.dart';  // MbeRoutes

// Go to the news feed
context.go(MbeRoutes.feed);

// Go to a specific story
context.go(MbeRoutes.storyDetail('story-id-here'));

// Open the submission form (auth-gated — SDK redirects to login if needed)
context.go(MbeRoutes.submit);

// Open user profile
context.go(MbeRoutes.profile);

// Editorial queue (editor role required)
context.go(MbeRoutes.editorialQueue);

// Admin dashboard (admin role required)
context.go(MbeRoutes.adminDashboard);
```

### Full route reference

| Screen | Route constant | Auth |
|---|---|---|
| News Feed | `MbeRoutes.feed` | — |
| Story Detail | `MbeRoutes.storyDetail(id)` | — |
| Submit Story | `MbeRoutes.submit` | ✅ |
| My Submissions | `MbeRoutes.mySubmissions` | ✅ |
| AI Preview | `MbeRoutes.aiPreview(submissionId)` | ✅ |
| Editorial Queue | `MbeRoutes.editorialQueue` | ✅ editor |
| Editorial Review | `MbeRoutes.editorialReview(id)` | ✅ editor |
| Editor Analytics | `MbeRoutes.editorAnalytics` | ✅ editor |
| User Profile | `MbeRoutes.profile` | ✅ |
| Creator Profile | `MbeRoutes.creatorProfile(id)` | — |
| Notifications | `MbeRoutes.notifications` | ✅ |
| Settings | `MbeRoutes.settings` | ✅ |
| KYC Upload | `MbeRoutes.kycUpload` | ✅ |
| Onboarding | `MbeRoutes.onboarding` | — |
| Admin Dashboard | `MbeRoutes.adminDashboard` | ✅ admin |
| Admin Reports | `MbeRoutes.adminReports` | ✅ admin |
| Admin Users | `MbeRoutes.adminUsers` | ✅ admin |

---

## 10. Dev token bypass

During local development, skip real HT SSO by injecting a seed user token.

```bash
# Basic creator
flutter run --dart-define=HT_USER_TOKEN=dev:ht-seed-alice

# HT-approved creator
flutter run --dart-define=HT_USER_TOKEN=dev:ht-seed-carol

# Trusted reporter
flutter run --dart-define=HT_USER_TOKEN=dev:ht-seed-david

# Editor role
flutter run --dart-define=HT_USER_TOKEN=dev:ht-seed-editor

# Admin role
flutter run --dart-define=HT_USER_TOKEN=dev:ht-seed-admin
```

> The `dev:` prefix is only honoured when `APP_ENV != "production"`.
> In production builds the token is forwarded to HT SSO as-is (which
> will 401), so the bypass cannot be abused outside dev.

---

## 11. Environment / API URL config

```dart
// lib/core/constants/api_constants.dart
class ApiConstants {
  static const String devBaseUrl  = 'http://localhost:8000/api/v1';
  static const String ngrokBaseUrl = 'https://schedular-lennox-nonpermissible.ngrok-free.dev/api/v1';
  static const String prodBaseUrl = 'https://api.maibhieditor.ht.com/v1';

  // Toggle via --dart-define=API_ENV=prod or a flavor config
  static const String _env = String.fromEnvironment('API_ENV', defaultValue: 'dev');
  static String get baseUrl => _env == 'prod' ? prodBaseUrl : ngrokBaseUrl;
}
```

When using ngrok for local testing, replace `devBaseUrl` with the ngrok URL:

```dart
static const String devBaseUrl = 'https://xxxx.ngrok-free.app/api/v1';
```

Or pass it at build time:

```bash
flutter run --dart-define=API_ENV=dev --dart-define=DEV_BASE_URL=https://xxxx.ngrok-free.app/api/v1
```

---

## 12. Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `MaiBhiEditor not initialized` | SDK used before `initialize()` | Ensure `await MaiBhiEditor.initialize(…)` completes in `main()` before `runApp()` |
| All API calls return 401 | `getAuthHeaders()` returns `{}` | Check `authProvider.init()` runs and reads a valid persisted token |
| GoRouter redirect loops | `authStatus == unknown` at startup | Call `authProvider.init()` and wait for it before `runApp()` |
| `DesignSystemScope not found` | Forgot `MaiBhiEditor.wrap()` | Wrap `MaterialApp.router(…)` with `MaiBhiEditor.wrap(child: …)` |
| Dependency conflict on `get_it` | Host and SDK using different versions | Both pin `get_it: ^8.0.3`; SDK uses an isolated instance so versions must be compatible |
| Images not loading (MinIO) | CORS or SSL config | In dev, set `MINIO_USE_SSL=false`; in production configure a proper CDN |
| Flutter `sdk` version mismatch | pubspec constraint too tight | Both packages require `flutter: ">=3.35.3"` and Dart `^3.11.3` |

---

## Required HTTP headers (reference)

Every request the SDK makes must carry these headers — supplied by your
`AuthProvider.getAuthHeaders()` implementation:

```
Authorization: <raw HT user token>    ← NOT "Bearer …", just the token
X-Client:      1006                   ← your HT host client ID
X-Platform:    iOS | Android
```
