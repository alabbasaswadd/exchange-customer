# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                              # Install dependencies
flutter pub run build_runner build          # Generate code (Freezed, Retrofit, JSON)
flutter pub run build_runner build --delete-conflicting-outputs  # Regenerate clean
flutter pub run build_runner watch          # Watch mode for code generation
flutter analyze                             # Run linter
flutter test                               # Run all tests
flutter test test/widget_test.dart         # Run a single test file
flutter run                                # Run on connected device/emulator
flutter build apk                          # Build Android APK
```

After adding or modifying any model with `@freezed`, `@JsonSerializable`, or any Retrofit `@RestApi` service, always run `build_runner build` to regenerate the `.g.dart` and `.freezed.dart` files.

## Architecture

**State management:** BLoC via `flutter_bloc` Cubits. States use Freezed sealed unions (`.initial()`, `.loading()`, `.success(T)`, `.error(String)`). See `signin_state.dart` for the pattern.

**Navigation:** GoRouter with a redirect guard that checks `UserSession` for a stored auth token. Public routes: `/`, `/onboarding`, `/signin`. All others require authentication. Route definitions live in `lib/routes.dart`.

**Networking stack:**
- Dio configured in `core/networking/dio_factory.dart` (30s timeout, pretty logging)
- Retrofit-generated clients per feature (e.g., `signin_api_service.dart`) — annotate with `@RestApi` and run build_runner
- `BaseApi` in `core/constants/base_api.dart` wraps calls into `ApiResult<T>` (Freezed sealed union: `success`/`failure`)
- `ApiErrorHandler` maps `DioException` types to localized `ErrorModel` messages

**Dependency injection:** GetIt service locator. All registrations are in `core/di/dependency_injection.dart`. Dio is a lazy singleton; Cubits are factories.

**Caching:** `CacheHelper` wraps SharedPreferences. `UserSession` (in `core/constants/cached/`) is the typed interface for reading/writing the auth token.

**Base classes to extend:**
- `BaseCubit<TState>` — includes form controller disposal and an `executeApi()` helper that handles loading/success/error state transitions
- `BaseApi` — use `executeApiCall()` to wrap any Retrofit call with error handling

## Feature module structure

Each feature under `lib/pages/<feature>/` follows this layout:
```
<feature>/
  api/          # Retrofit service interface + SigninApi wrapper
  cubit/        # XxxCubit extends BaseCubit, XxxState (Freezed)
  model/        # Request/response models with @JsonSerializable
  screen/       # UI widgets
```

## API configuration

Base URL and tenant ID are in `core/networking/api_constans.dart`. The tenant header is injected in `DioFactory`. Defined endpoint groups: SignIn, Complaint, ConnectedDevices, DhcpLeases.

## Localization

ARB files are in `lib/l10n/` (English + Arabic). Generated `AppLocalizations` is auto-imported via `flutter_localizations`. The app uses the Cairo font family to support Arabic.

## Theme

Defined in `lib/theme.dart`. Primary color is blue (`#1565C0` light / `#0D47A1` dark). Reusable UI components (buttons, text fields, dialogs, snackbars, shimmer) live in `lib/core/components/` — use these instead of raw Material widgets.
