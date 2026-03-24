# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

HabitBoost is a Flutter mobile app for habit tracking. The UI language is Russian. It uses an offline-first architecture with Firebase sync.

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run code generation (injectable, freezed, json_serializable, drift)
dart run build_runner build --delete-conflicting-outputs

# Static analysis (uses very_good_analysis)
flutter analyze --fatal-infos

# Run tests
flutter test --coverage

# Run a single test file
flutter test test/path/to/test_file.dart
```

## Architecture

**Clean Architecture + BLoC** with three layers per feature:
- **Domain:** Entities, repository interfaces, use cases (extend `UseCase<T, Params>` returning `Either<Failure, T>`)
- **Data:** Models (Freezed/JSON serializable), data sources (remote/local), repository implementations
- **Presentation:** Screens, widgets, BLoC (event/state pattern)

**Feature modules** in `lib/features/`: auth, habits, journal, progress, onboarding, profile, sos, achievements, notifications.

### Key Patterns

- **Error handling:** `dartz` Either type — `Left(Failure)` for errors, `Right(T)` for success. Failures: `ServerFailure`, `CacheFailure`, `NetworkFailure`, `AuthFailure`.
- **DI:** GetIt + Injectable. Service locator accessed via `sl<T>()`. Register external deps in `lib/app/di/register_module.dart`. Run build_runner after adding `@injectable`/`@lazySingleton` annotations.
- **Navigation:** GoRouter. Routes defined in `lib/app/router/routes.dart`. Shell route wraps the 4-tab bottom nav (Home, Progress, Journal, Profile).
- **State management:** Global BLoCs (AuthBloc, OnboardingBloc) provided at app root. Tab-specific BLoCs created in GoRoute builders via `sl<BlocType>()`.
- **Database:** Drift (SQLite) with tables: HabitsTable, JournalEntriesTable, SyncQueueTable. Schema version 3.
- **Sync:** Offline-first. ConnectivityListener monitors network. SyncService queues changes in SyncQueueTable and syncs to Firestore when online.
- **Theme:** ThemeCubit manages light/dark mode. Colors defined in `AppColorsTheme` extension.

### Initialization Flow

`main.dart` → `bootstrap()`: Firebase init → locale init (`ru`) → DI setup → ConnectivityListener start → `runApp(App())`

## Code Generation

Generated files are excluded from analysis: `*.g.dart`, `*.freezed.dart`, `*.config.dart`. Always run build_runner after modifying:
- Freezed models (`@freezed`)
- JSON serializable models (`@JsonSerializable`)
- Injectable registrations (`@injectable`, `@lazySingleton`, `@module`)
- Drift database tables/DAOs

## Testing

- Unit tests use `mocktail` for mocking and `bloc_test` for BLoC testing
- Test files mirror the `lib/` structure under `test/`
