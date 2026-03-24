# HabitBoost — архитектурный план приложения

## Выбор архитектуры: Clean Architecture + BLoC

### Почему не MVVM?

MVVM — хороший паттерн, но для Flutter-экосистемы **Clean Architecture с BLoC** — более зрелый и масштабируемый выбор:

| Критерий | MVVM + Provider/Riverpod | Clean Architecture + BLoC |
|----------|-------------------------|---------------------------|
| Разделение слоев | 3 слоя (View-ViewModel-Model) | 3 слоя (Presentation-Domain-Data) с четкими boundaries |
| Тестируемость | Хорошая | Отличная — каждый слой тестируется изолированно |
| Масштабируемость | Средняя — ViewModel разрастаются | Высокая — логика разбита на Use Cases |
| Flutter-экосистема | Provider/Riverpod | flutter_bloc — самый популярный пакет, 12k+ stars |
| Командная работа | Неявные зависимости | Строгие контракты между слоями |
| Онбординг новых разработчиков | Быстрый | Средний, но код предсказуемый |

**Вердикт:** Clean Architecture + BLoC дает жесткую структуру, которая окупается при росте проекта. Use Cases инкапсулируют бизнес-логику и легко переиспользуются.

---

## Слои архитектуры

```
┌─────────────────────────────────────────────┐
│              Presentation Layer              │
│  (Screens, Widgets, BLoCs, States, Events)  │
├─────────────────────────────────────────────┤
│               Domain Layer                   │
│    (Entities, Use Cases, Repositories*)      │
│         * abstract interfaces                │
├─────────────────────────────────────────────┤
│                Data Layer                    │
│  (Repositories impl, Data Sources, Models)  │
│  (Local DB, Remote API, Cache)              │
└─────────────────────────────────────────────┘
```

### Presentation Layer
- **BLoC** — управление состоянием (Events → BLoC → States)
- **Screens** — полноэкранные виджеты (1 screen = 1 BLoC)
- **Widgets** — переиспользуемые UI-компоненты
- Зависит от Domain Layer, **не знает** о Data Layer

### Domain Layer
- **Entities** — чистые бизнес-объекты (без зависимостей)
- **Use Cases** — единичные бизнес-операции (1 Use Case = 1 действие)
- **Repository interfaces** — абстракции для доступа к данным
- **Не зависит ни от чего** — ядро приложения

### Data Layer
- **Repository implementations** — реализация интерфейсов из Domain
- **Data Sources** — Remote (API) и Local (DB, SharedPreferences)
- **Models** — DTO для сериализации/десериализации
- Зависит от Domain Layer (реализует его контракты)

---

## Структура проекта

```
lib/
├── app/
│   ├── app.dart                    # MaterialApp, тема, роутинг
│   ├── di/
│   │   └── injection_container.dart # Dependency Injection (get_it)
│   └── router/
│       ├── app_router.dart         # GoRouter конфигурация
│       └── routes.dart             # Константы маршрутов
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_dimensions.dart
│   ├── error/
│   │   ├── failures.dart           # Failure classes для Domain
│   │   └── exceptions.dart         # Exception classes для Data
│   ├── network/
│   │   ├── api_client.dart         # Dio конфигурация
│   │   └── network_info.dart       # Проверка интернета
│   ├── theme/
│   │   ├── app_theme.dart          # Light & Dark темы (Material 3)
│   │   └── text_styles.dart
│   ├── usecases/
│   │   └── usecase.dart            # Базовый абстрактный UseCase
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── validators.dart
│   │   └── extensions.dart
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── app_card.dart
│       ├── loading_indicator.dart
│       └── error_widget.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login.dart
│   │   │       ├── register.dart
│   │   │       ├── logout.dart
│   │   │       └── get_current_user.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   ├── register_screen.dart
│   │       │   └── forgot_password_screen.dart
│   │       └── widgets/
│   │           └── auth_form.dart
│   │
│   ├── onboarding/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── onboarding_local_datasource.dart
│   │   │   └── repositories/
│   │   │       └── onboarding_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_goals.dart
│   │   │   ├── repositories/
│   │   │   │   └── onboarding_repository.dart
│   │   │   └── usecases/
│   │   │       ├── save_goals.dart
│   │   │       ├── get_onboarding_status.dart
│   │   │       └── complete_onboarding.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── onboarding_bloc.dart
│   │       │   ├── onboarding_event.dart
│   │       │   └── onboarding_state.dart
│   │       ├── screens/
│   │       │   ├── welcome_screen.dart
│   │       │   ├── goal_selection_screen.dart
│   │       │   └── notification_permission_screen.dart
│   │       └── widgets/
│   │           ├── goal_chip.dart
│   │           └── onboarding_page_indicator.dart
│   │
│   ├── habits/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── habits_remote_datasource.dart
│   │   │   │   └── habits_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── habit_model.dart
│   │   │   │   └── habit_completion_model.dart
│   │   │   └── repositories/
│   │   │       └── habits_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── habit.dart
│   │   │   │   └── habit_completion.dart
│   │   │   ├── repositories/
│   │   │   │   └── habits_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_habits.dart
│   │   │       ├── get_today_habits.dart
│   │   │       ├── create_habit.dart
│   │   │       ├── update_habit.dart
│   │   │       ├── delete_habit.dart
│   │   │       ├── toggle_habit_completion.dart
│   │   │       └── get_habit_completions.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── habits_bloc.dart
│   │       │   ├── habits_event.dart
│   │       │   ├── habits_state.dart
│   │       │   ├── habit_form_bloc.dart
│   │       │   ├── habit_form_event.dart
│   │       │   └── habit_form_state.dart
│   │       ├── screens/
│   │       │   ├── home_screen.dart
│   │       │   ├── add_habit_screen.dart
│   │       │   ├── edit_habit_screen.dart
│   │       │   └── habit_detail_screen.dart
│   │       └── widgets/
│   │           ├── habit_card.dart
│   │           ├── habit_list.dart
│   │           ├── streak_banner.dart
│   │           ├── icon_picker.dart
│   │           ├── color_picker.dart
│   │           └── day_selector.dart
│   │
│   ├── progress/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── progress_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── progress_stats_model.dart
│   │   │   └── repositories/
│   │   │       └── progress_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── progress_stats.dart
│   │   │   │   └── habit_streak.dart
│   │   │   ├── repositories/
│   │   │   │   └── progress_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_weekly_stats.dart
│   │   │       ├── get_monthly_stats.dart
│   │   │       ├── get_streak.dart
│   │   │       └── get_completion_heatmap.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── progress_bloc.dart
│   │       │   ├── progress_event.dart
│   │       │   └── progress_state.dart
│   │       ├── screens/
│   │       │   └── progress_screen.dart
│   │       └── widgets/
│   │           ├── heatmap_calendar.dart
│   │           ├── stats_card.dart
│   │           ├── period_selector.dart
│   │           └── habit_progress_bar.dart
│   │
│   ├── journal/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── journal_remote_datasource.dart
│   │   │   │   └── journal_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── journal_entry_model.dart
│   │   │   └── repositories/
│   │   │       └── journal_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── journal_entry.dart
│   │   │   ├── repositories/
│   │   │   │   └── journal_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_journal_entries.dart
│   │   │       ├── create_journal_entry.dart
│   │   │       ├── update_journal_entry.dart
│   │   │       └── delete_journal_entry.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── journal_bloc.dart
│   │       │   ├── journal_event.dart
│   │       │   └── journal_state.dart
│   │       ├── screens/
│   │       │   ├── journal_screen.dart
│   │       │   └── journal_entry_screen.dart
│   │       └── widgets/
│   │           ├── journal_card.dart
│   │           ├── mood_selector.dart
│   │           └── reflection_prompt.dart
│   │
│   ├── achievements/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── achievements_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── achievement_model.dart
│   │   │   └── repositories/
│   │   │       └── achievements_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── achievement.dart
│   │   │   ├── repositories/
│   │   │   │   └── achievements_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_achievements.dart
│   │   │       ├── check_new_achievements.dart
│   │   │       └── unlock_achievement.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── achievements_bloc.dart
│   │       │   ├── achievements_event.dart
│   │       │   └── achievements_state.dart
│   │       ├── screens/
│   │       │   └── achievements_screen.dart
│   │       └── widgets/
│   │           ├── achievement_badge.dart
│   │           └── achievement_grid.dart
│   │
│   ├── sos/
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── sos_bloc.dart
│   │       │   ├── sos_event.dart
│   │       │   └── sos_state.dart
│   │       ├── screens/
│   │       │   └── sos_screen.dart
│   │       └── widgets/
│   │           ├── breathing_exercise.dart
│   │           └── sos_action_card.dart
│   │
│   ├── profile/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── profile_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── profile_model.dart
│   │   │   └── repositories/
│   │   │       └── profile_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── profile.dart
│   │   │   ├── repositories/
│   │   │   │   └── profile_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_profile.dart
│   │   │       └── update_profile.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── profile_bloc.dart
│   │       │   ├── profile_event.dart
│   │       │   └── profile_state.dart
│   │       ├── screens/
│   │       │   ├── profile_screen.dart
│   │       │   └── settings_screen.dart
│   │       └── widgets/
│   │           ├── profile_header.dart
│   │           └── settings_tile.dart
│   │
│   └── notifications/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── notification_datasource.dart
│       │   └── repositories/
│       │       └── notification_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── notification_settings.dart
│       │   ├── repositories/
│       │   │   └── notification_repository.dart
│       │   └── usecases/
│       │       ├── schedule_notification.dart
│       │       ├── cancel_notification.dart
│       │       └── update_notification_settings.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── notification_bloc.dart
│           │   ├── notification_event.dart
│           │   └── notification_state.dart
│           └── screens/
│               └── notification_settings_screen.dart
│
├── main.dart                        # Entry point
└── bootstrap.dart                   # Инициализация DI, Firebase, etc.
```

---

## Стек зависимостей (packages)

### State Management & Architecture
| Пакет | Назначение |
|-------|-----------|
| `flutter_bloc` | BLoC pattern — state management |
| `equatable` | Упрощение сравнения объектов (States, Events, Entities) |
| `get_it` | Service Locator для Dependency Injection |
| `injectable` + `injectable_generator` | Кодогенерация для DI |
| `dartz` | Functional programming (Either<Failure, Success>) |

### Navigation
| Пакет | Назначение |
|-------|-----------|
| `go_router` | Декларативная навигация, deep links, guards |

### Network
| Пакет | Назначение |
|-------|-----------|
| `dio` | HTTP-клиент |
| `retrofit` + `retrofit_generator` | Типобезопасные API вызовы (кодогенерация) |
| `connectivity_plus` | Проверка состояния сети |

### Local Storage
| Пакет | Назначение |
|-------|-----------|
| `drift` + `drift_dev` | Локальная SQL БД (offline-first) |
| `shared_preferences` | Key-value хранилище (настройки, токены) |
| `flutter_secure_storage` | Безопасное хранение токенов/паролей |

### Firebase
| Пакет | Назначение |
|-------|-----------|
| `firebase_core` | Инициализация Firebase |
| `firebase_auth` | Аутентификация |
| `cloud_firestore` | Удаленная база данных |
| `firebase_messaging` | Push-уведомления |
| `firebase_analytics` | Аналитика |
| `firebase_crashlytics` | Crash reporting |

### UI & UX
| Пакет | Назначение |
|-------|-----------|
| `flutter_animate` | Декларативные анимации |
| `lottie` | Lottie-анимации (splash, onboarding, SOS) |
| `cached_network_image` | Кэширование изображений |
| `flutter_svg` | SVG-иконки |
| `shimmer` | Skeleton loading |
| `fl_chart` | Графики (прогресс, статистика) |
| `table_calendar` | Календарь (heatmap выполнения) |

### Notifications
| Пакет | Назначение |
|-------|-----------|
| `flutter_local_notifications` | Локальные уведомления |
| `timezone` | Корректная работа с часовыми поясами |

### Utils
| Пакет | Назначение |
|-------|-----------|
| `freezed` + `freezed_annotation` | Immutable data classes + union types |
| `json_serializable` + `json_annotation` | JSON сериализация |
| `build_runner` | Запуск кодогенераторов |
| `intl` | Локализация и форматирование дат |
| `logger` | Логирование |

### Testing
| Пакет | Назначение |
|-------|-----------|
| `bloc_test` | Тестирование BLoC |
| `mocktail` | Мокирование зависимостей |
| `integration_test` | Интеграционные тесты |

---

## Ключевые паттерны

### 1. Either<Failure, T> — обработка ошибок

Никаких try/catch в Presentation Layer. Все ошибки обернуты в `Either`:

```dart
// Domain Layer — Repository interface
abstract class HabitsRepository {
  Future<Either<Failure, List<Habit>>> getHabits();
  Future<Either<Failure, Habit>> createHabit(Habit habit);
}

// Domain Layer — Use Case
class GetHabits implements UseCase<List<Habit>, NoParams> {
  final HabitsRepository repository;

  GetHabits(this.repository);

  @override
  Future<Either<Failure, List<Habit>>> call(NoParams params) {
    return repository.getHabits();
  }
}
```

### 2. BLoC — поток состояний

```dart
// Events
sealed class HabitsEvent {}
class LoadHabits extends HabitsEvent {}
class ToggleHabitCompletion extends HabitsEvent {
  final String habitId;
  ToggleHabitCompletion(this.habitId);
}

// States
sealed class HabitsState {}
class HabitsInitial extends HabitsState {}
class HabitsLoading extends HabitsState {}
class HabitsLoaded extends HabitsState {
  final List<Habit> habits;
  HabitsLoaded(this.habits);
}
class HabitsError extends HabitsState {
  final String message;
  HabitsError(this.message);
}
```

### 3. Offline-First — стратегия синхронизации

```
Пользователь отмечает привычку
  → Запись в локальную БД (Drift) — мгновенно
  → UI обновляется
  → Фоновая синхронизация с Firestore
  → При отсутствии сети — добавление в очередь синхронизации
  → При появлении сети — отправка очереди
```

### 4. Dependency Injection — граф зависимостей

```
get_it + injectable:

DataSource → Repository impl → Use Case → BLoC → Screen

Каждый слой получает зависимости через конструктор.
Регистрация — в injection_container.dart.
```

### 5. GoRouter — навигация с guards

```dart
GoRouter(
  routes: [...],
  redirect: (context, state) {
    final isLoggedIn = authBloc.state is Authenticated;
    final isOnboarded = onboardingBloc.state is OnboardingComplete;

    if (!isLoggedIn) return '/login';
    if (!isOnboarded) return '/onboarding';
    return null; // no redirect
  },
);
```

---

## Модель данных (основные Entity)

### User
```dart
class User {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;
  final List<String> goals;
  final bool onboardingCompleted;
}
```

### Habit
```dart
class Habit {
  final String id;
  final String userId;
  final String title;
  final String icon;
  final String color;
  final String category;
  final List<int> scheduleDays; // 1=Пн ... 7=Вс
  final TimeOfDay? reminderTime;
  final bool reminderEnabled;
  final DateTime createdAt;
  final int currentStreak;
  final int bestStreak;
}
```

### HabitCompletion
```dart
class HabitCompletion {
  final String id;
  final String habitId;
  final DateTime date;
  final bool completed;
}
```

### JournalEntry
```dart
class JournalEntry {
  final String id;
  final String userId;
  final DateTime date;
  final String mood; // emoji
  final String content;
  final List<String> reflections;
  final DateTime createdAt;
}
```

### Achievement
```dart
class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final AchievementType type;
  final int threshold;
  final bool unlocked;
  final DateTime? unlockedAt;
}
```

---

## Тестирование

### Пирамида тестов

```
        ╱╲
       ╱  ╲        E2E (integration_test)
      ╱    ╲       — Критические user flows
     ╱──────╲
    ╱        ╲     Widget Tests
   ╱          ╲    — Screens & key widgets
  ╱────────────╲
 ╱              ╲  Unit Tests
╱                ╲ — BLoCs, Use Cases, Repositories, Models
```

| Уровень | Что тестируем | Инструменты |
|---------|--------------|-------------|
| Unit | BLoC (events→states), Use Cases, Repository impl, Models (serialization) | `bloc_test`, `mocktail` |
| Widget | Отдельные экраны, формы, ключевые виджеты | `flutter_test`, `mocktail` |
| Integration | Auth flow, создание + выполнение привычки, streak counting | `integration_test` |

### Структура тестов
```
test/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl_test.dart
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       └── login_test.dart
│   │   └── presentation/
│   │       └── bloc/
│   │           └── auth_bloc_test.dart
│   ├── habits/
│   │   └── ...
│   └── ...
├── core/
│   └── ...
└── helpers/
    ├── test_helpers.dart
    └── mock_classes.dart

integration_test/
├── auth_flow_test.dart
├── habit_flow_test.dart
└── app_test.dart
```

---

## CI/CD

```
GitHub Actions Pipeline:

push/PR → Analyze → Test → Build → Deploy

1. analyze:   flutter analyze + dart format --set-exit-if-changed
2. test:      flutter test --coverage
3. build:     flutter build apk / ipa
4. deploy:    Firebase App Distribution (dev) / Play Store + App Store (prod)
```

---

## Порядок реализации

### Sprint 1 — Фундамент (1-2 недели)
- Настройка проекта: структура папок, DI, роутинг
- Core: тема, ошибки, базовые виджеты
- Firebase: подключение core, auth, firestore
- Drift: настройка локальной БД

### Sprint 2 — Auth + Onboarding (1 неделя)
- Auth feature: login, register, forgot password
- Onboarding feature: welcome, goals, permissions
- Route guards

### Sprint 3 — Habits MVP (2 недели)
- Habits feature: CRUD, отметка выполнения
- Home Screen с полным функционалом
- Offline-first: локальная запись + синхронизация
- Push-уведомления (напоминания)

### Sprint 4 — Progress + Journal (1-2 недели)
- Progress feature: календарь, streak, статистика
- Journal feature: CRUD записей, настроение, рефлексия
- Habit Detail Screen

### Sprint 5 — Engagement (1 неделя)
- Achievements feature: бейджи, разблокировка
- SOS feature: дыхание, мотивация
- Мотивационные цитаты на Home

### Sprint 6 — Polish (1 неделя)
- Dark theme
- Анимации (flutter_animate, Lottie)
- Empty states, error states
- Performance: lazy loading, кэширование
- Тестирование: unit + widget + integration
