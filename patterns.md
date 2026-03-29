# Паттерны проектирования в HabitBoost Mobile

## Архитектурные паттерны

| Паттерн | Плюсы | Минусы | Использование в проекте |
|---------|-------|--------|-------------------------|
| **Clean Architecture** (трёхслойная архитектура) | Чёткое разделение ответственности; высокая тестируемость; независимость слоёв; лёгкость замены реализаций | Много шаблонного кода; высокий порог входа; избыточность для простых фич | Используется во всех 9 фичах (`auth`, `habits`, `journal`, `progress`, `onboarding`, `profile`, `sos`, `achievements`, `notifications`). Каждая фича разделена на `domain/`, `data/`, `presentation/`. |
| **BLoC** (Business Logic Component) | Предсказуемое управление состоянием; отличная поддержка в Flutter; легко тестировать; разделение UI и логики | Много файлов (events, states, bloc); сложнее для простых случаев, где хватило бы Cubit | Используется в 8+ местах: `AuthBloc`, `HabitsBloc`, `HabitFormBloc`, `JournalBloc`, `ProgressBloc`, `OnboardingBloc`. Паттерн: `Bloc<Event, State>`, sealed-классы событий, `on<EventType>()`. |
| **Cubit** (упрощённый BLoC) | Простота, меньше кода; подходит для несложного состояния; совместим с BLoC-экосистемой | Нет явной трассировки событий; сложнее отладить переходы | Применяется для `ThemeCubit` (`lib/core/theme/`) и `LocaleCubit` (`lib/core/locale/`). Мог бы использоваться шире — для фильтров, диалогов, простых форм. |
| **Repository Pattern** | Абстракция источника данных; позволяет менять БД/API без правки бизнес-логики; упрощает тестирование (mock-репозитории) | Дополнительный слой; дублирование методов в интерфейсе и реализации | Реализован для всех фич: `AuthRepository`/`AuthRepositoryImpl`, `HabitsRepository`/`HabitsRepositoryImpl`, `JournalRepository`/`JournalRepositoryImpl`. Реп. — медиатор между data sources и use cases. |
| **Use Case** (Interactor) | Единственная ответственность; бизнес-логика не завязана на фреймворк; переиспользуемость | Большое количество файлов; overhead для тривиальных операций; сложно понять общую картину | Реализован через `UseCase<T, Params>` в `lib/core/usecases/usecase.dart`. 20+ use cases: `Login`, `Register`, `CreateHabit`, `ToggleCompletion`, `CreateJournalEntry` и др. |

---

## Паттерны управления зависимостями

| Паттерн | Плюсы | Минусы | Использование в проекте |
|---------|-------|--------|-------------------------|
| **Dependency Injection** (GetIt + Injectable) | Слабая связанность; тестируемость; централизованное управление зависимостями; поддержка LazyLoading | Скрытые зависимости (сложнее понять, что чем пользуется); генерация кода требует `build_runner` | `lib/app/di/injection_container.dart` — точка входа. `RegisterModule` регистрирует Firebase, Connectivity, SharedPreferences. Аннотации: `@injectable`, `@LazySingleton`, `@Singleton`. Сгенерированный конфиг — 900+ строк. |
| **Service Locator** (GetIt `sl<T>()`) | Прост в использовании; глобальный доступ без передачи через параметры | Антипаттерн при злоупотреблении (скрытые зависимости); сложно тестировать без настройки | `sl<T>()` используется в роутере для создания BLoC-провайдеров в `GoRoute.builder`, например `sl<HabitsBloc>()`. |
| **Singleton** | Единственный экземпляр; экономия ресурсов для тяжёлых объектов (БД, сетевые клиенты) | Глобальное состояние; сложнее тестировать; скрытые зависимости | `@LazySingleton` для 35+ классов: `AppDatabase`, `SyncService`, `NotificationService`, `ConnectivityListener`, все репозитории и data sources. |

---

## Паттерны работы с данными

| Паттерн | Плюсы | Минусы | Использование в проекте |
|---------|-------|--------|-------------------------|
| **Data Source Abstraction** (Local/Remote split) | Изолирует технологии хранения; позволяет менять БД или API; поддерживает offline-first | Удвоение абстракций; координация между источниками лежит на репозитории | Для каждой фичи — отдельные `local_datasource` (Drift) и `remote_datasource` (Firestore). Пример: `HabitsLocalDataSource` + `HabitsFirestoreDataSource`. |
| **Offline-First / Sync Queue** | Приложение работает без интернета; пользователь не теряет данные; синхронизация при восстановлении сети | Сложность реализации; конфликты данных; дублирование логики push/pull | `SyncService` (`lib/core/sync/sync_service.dart`): очередь изменений в `SyncQueueTable`, сброс при восстановлении сети через `ConnectivityListener`. Стратегия: timestamp-based conflict resolution, pull-and-merge. |
| **Factory Method** | Инкапсуляция логики создания объектов; читаемость; разделение создания и использования | Дополнительный слой абстракции; не всегда оправдан | `UserModel.fromJson()`, `UserModel.fromEntity()`, `Mood.fromString()`, `ReminderTime.parse()`. В будущем можно применить при добавлении новых типов уведомлений или источников данных. |
| **Value Object + Immutability** (Equatable + copyWith) | Безопасность по ссылкам; предсказуемость; простота сравнения | Необходимость реализовывать `copyWith` и `props` вручную | Все entity (`Habit`, `JournalEntry`, `AppUser`), все BLoC-состояния и события, все Params-объекты расширяют `Equatable`. `copyWith()` реализован вручную. |
| **ORM** (Drift) | Типобезопасные запросы; автомиграции; генерация кода | Ограниченность сложных SQL-запросов; привязка к фреймворку | `AppDatabase` (`lib/core/database/`): таблицы `HabitsTable`, `HabitCompletionsTable`, `JournalEntriesTable`, `SyncQueueTable`. Схема версии 5, инкрементальные миграции. |

---

## Паттерны обработки ошибок и функционального программирования

| Паттерн | Плюсы | Минусы | Использование в проекте |
|---------|-------|--------|-------------------------|
| **Either** (dartz) | Явная обработка ошибок без исключений; тип кодирует возможность ошибки; `.fold()` принуждает обрабатывать оба случая | Непривычно для разработчиков без опыта в ФП; зависимость от внешней библиотеки | Возвращаемый тип всех use cases и репозиториев: `Either<Failure, T>`. Обработка: `result.fold((failure) => emit(AuthError(...)), (user) => emit(Authenticated(...)))`. |
| **Sealed Classes** (для событий) | Исчерпывающие проверки компилятором; читаемость; безопасность типов | Доступно с Dart 3.0+; требует migrate для старых проектов | События BLoC определены как sealed: `sealed class AuthEvent extends Equatable`. Паттерн-матчинг в switch-выражениях. |

---

## Навигация и UI-паттерны

| Паттерн | Плюсы | Минусы | Использование в проекте |
|---------|-------|--------|-------------------------|
| **Declarative Navigation** (GoRouter) | Декларативные маршруты; deep linking; независимость от виджет-дерева; поддержка ShellRoute | Сложнее передавать сложные объекты (нужен `state.extra`); отладка вложенных маршрутов | `AppRouter` (`lib/app/router/app_router.dart`): `ShellRoute` для нижней навигации (4 вкладки), отдельные `GoRoute` для модальных экранов. Константы маршрутов в `Routes`. |
| **Observer** (Stream-based) | Реактивность; слабая связанность; автоматическая реакция на изменения состояния | Управление подписками (утечки памяти); сложность отладки | `ConnectivityListener` подписывается на `connectivity.onConnectivityChanged`. При восстановлении сети вызывает `syncService.flushQueue()`. GoRouter-редиректы реагируют на `AuthBloc`. |

---

## Паттерны уведомлений и внешних сервисов

| Паттерн | Плюсы | Минусы | Использование в проекте |
|---------|-------|--------|-------------------------|
| **Scheduling Pattern** | Надёжные повторяющиеся напоминания; работает офлайн; поддержка timezone | Платформозависимость (разные разрешения iOS/Android); ограничения ОС на фоновые задачи | `NotificationService` (`lib/features/notifications/data/datasources/`): еженедельные напоминания по привычкам, timezone-aware, детерминированные ID уведомлений. Управляется через `ScheduleHabitReminder`/`CancelHabitReminder`. |

---

## Итоговая сводка

| Паттерн | Категория | Статус в проекте |
|---------|-----------|------------------|
| Clean Architecture | Архитектурный | Полностью реализован |
| BLoC | Управление состоянием | Основной паттерн, 8+ BLoC |
| Cubit | Управление состоянием | Для простых случаев (тема, локаль) |
| Repository | Данные | Полностью реализован во всех фичах |
| Use Case | Бизнес-логика | 20+ use cases |
| Dependency Injection | Архитектурный | GetIt + Injectable, 35+ зависимостей |
| Service Locator | Архитектурный | `sl<T>()` в роутере и BLoC |
| Singleton | Порождающий | @LazySingleton для сервисов/репозиториев |
| Data Source Abstraction | Данные | Local (Drift) + Remote (Firebase) |
| Offline-First + Sync Queue | Данные | SyncService + ConnectivityListener |
| Factory Method | Порождающий | fromJson, fromEntity, fromString |
| Value Object + Immutability | Структурный | Equatable + copyWith везде |
| ORM (Drift) | Данные | AppDatabase, версия схемы 5 |
| Either (dartz) | Функциональный | Все use cases и репозитории |
| Sealed Classes | Структурный | События BLoC |
| Declarative Navigation | UI | GoRouter, ShellRoute |
| Observer (Stream) | Поведенческий | ConnectivityListener, GoRouter-редиректы |
| Scheduling | Интеграционный | FlutterLocalNotifications |
