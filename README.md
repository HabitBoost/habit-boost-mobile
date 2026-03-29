# HabitBoost

Мобильное приложение для трекинга привычек. Помогает формировать полезные привычки, отслеживать прогресс и вести личный дневник.

**Платформы:** iOS, Android

**Стек:** Flutter · Firebase (Auth, Firestore) · Drift (SQLite) · BLoC

---

## Начало работы

### 1. Зависимости

```bash
flutter pub get
```

### 2. Firebase

Для получения конфигурационных файлов (`google-services.json`, `GoogleService-Info.plist`, `lib/firebase_options.dart`) нужен доступ к Firebase проекту:

```bash
flutterfire configure --project=habit-boost-fe69a
```

### 3. Кодогенерация

После изменения Freezed-моделей, injectable-аннотаций или Drift-таблиц:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Команды разработки

### Запуск и сборка

```bash
# Запустить приложение
flutter run

# Собрать для iOS
flutter build ios

# Собрать для Android
flutter build apk
```

### Локализация

Шаблонный файл: `lib/l10n/app_ru.arb`. После изменения ARB-файлов:

```bash
flutter gen-l10n
```

Поддерживаемые локали: `ru` (основная), `en`.

### Анализ и тесты

```bash
# Статический анализ
flutter analyze --fatal-infos

# Запустить все тесты
flutter test --coverage

# Запустить один тест
flutter test test/path/to/test_file.dart
```

---

## Структура проекта

```
lib/
├── app/          # DI, роутер, тема
├── core/         # Базовые классы, утилиты, расширения
├── features/     # Фичи: auth, habits, journal, progress,
│                 #        profile, achievements, sos, notifications
└── l10n/         # ARB-файлы локализации
```

Каждая фича следует Clean Architecture: `domain` → `data` → `presentation`.
