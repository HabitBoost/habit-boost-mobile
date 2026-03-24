# HabitBoost — план дизайна мобильного приложения

## Технологический стек

- **Framework:** Flutter (Dart)
- **UI Kit:** Material Design 3 (Material You) — нативная поддержка во Flutter
- **Дизайн-система:** основана на Material 3 tokens с кастомными расширениями
- **Figma:** используем Material 3 Design Kit для Flutter

---

## Архитектура навигации

```
App
├── Splash Screen
├── Onboarding Flow (первый запуск)
│   ├── Welcome Screen
│   ├── Goal Selection Screen
│   └── Notification Permission Screen
├── Auth Flow
│   ├── Login Screen
│   ├── Register Screen
│   └── Forgot Password Screen
├── Main App (Bottom Navigation)
│   ├── Tab 1: Home (Сегодня)
│   ├── Tab 2: Progress (Прогресс)
│   ├── Tab 3: Journal (Дневник)
│   └── Tab 4: Profile (Профиль)
├── Modal / Push Screens
│   ├── Add/Edit Habit Screen
│   ├── Habit Detail Screen
│   ├── Achievement Detail Screen
│   ├── SOS Screen (quick action)
│   ├── Notification Settings Screen
│   └── App Settings Screen
```

---

## Экраны и их содержание

### 1. Splash Screen
- Логотип HabitBoost
- Анимация загрузки (Lottie)
- Проверка авторизации → редирект на Onboarding / Auth / Main

### 2. Onboarding Flow

#### 2.1 Welcome Screen (страница 1/3)
- Иллюстрация + заголовок + подзаголовок
- Описание ценности приложения
- Кнопка "Далее"
- PageView с индикатором (dots)

#### 2.2 Goal Selection Screen (страница 2/3)
- Заголовок: "Что для вас важно?"
- Chip-группа с категориями:
  - Здоровье
  - Продуктивность
  - Ментальное состояние
  - Спорт
  - Питание
  - Обучение
- Множественный выбор
- Кнопка "Далее"

#### 2.3 Notification Permission Screen (страница 3/3)
- Иллюстрация
- Объяснение зачем нужны уведомления
- Кнопка "Разрешить уведомления"
- Текстовая кнопка "Пропустить"

### 3. Auth Flow

#### 3.1 Login Screen
- Логотип (компактный)
- Поле Email (TextFormField)
- Поле Password (TextFormField, obscure)
- Кнопка "Войти" (FilledButton)
- Ссылка "Забыли пароль?"
- Разделитель "или"
- Кнопка "Создать аккаунт" (OutlinedButton)

#### 3.2 Register Screen
- Поле Имя
- Поле Email
- Поле Password
- Поле Confirm Password
- Checkbox согласия с условиями
- Кнопка "Зарегистрироваться"
- Ссылка "Уже есть аккаунт? Войти"

#### 3.3 Forgot Password Screen
- Поле Email
- Кнопка "Отправить ссылку для сброса"
- Состояние успеха с инструкцией

### 4. Main App — Tab 1: Home (Сегодня)

**Главный экран приложения**

- **AppBar:** дата (сегодня), аватар пользователя
- **Мотивационная карточка:** цитата дня (Card, сворачиваемая)
- **Streak-баннер:** текущая серия дней (визуальный акцент)
- **Список привычек на сегодня:**
  - Каждая привычка — карточка с:
    - Иконка + название
    - Категория (цветной badge)
    - Checkbox / кнопка отметки выполнения
    - Мини-прогресс (streak count)
  - Поддержка свайпа (редактировать / удалить)
- **FAB (Floating Action Button):** добавить новую привычку
- **Empty state:** если привычек нет — иллюстрация + CTA

### 5. Main App — Tab 2: Progress (Прогресс)

- **Переключатель периода:** Неделя / Месяц
- **Календарь-тепловая карта:** визуализация выполнения (по дням)
- **Общая статистика:**
  - Выполнено сегодня: X из Y
  - Текущий streak
  - Лучший streak
  - Процент выполнения за неделю/месяц
- **Список привычек с индивидуальным прогрессом:**
  - Горизонтальный бар-прогресс для каждой привычки
  - Процент выполнения за выбранный период
- **Секция достижений (бейджи):**
  - Горизонтальный скролл последних полученных бейджей
  - Кнопка "Все достижения"

### 6. Main App — Tab 3: Journal (Дневник)

- **Список записей** (по датам, новые сверху)
  - Превью: дата + первые строки текста + настроение (emoji)
- **FAB:** новая запись
- **Экран записи:**
  - Дата (авто)
  - Выбор настроения (emoji row)
  - Текстовое поле (мультилайн)
  - Вопросы для рефлексии (опциональные prompts):
    - "Что сегодня получилось?"
    - "Что было сложно?"
    - "За что благодарен?"
  - Кнопка сохранить
- **Empty state:** мотивация начать вести дневник

### 7. Main App — Tab 4: Profile (Профиль)

- **Шапка профиля:**
  - Аватар
  - Имя
  - Дата регистрации
  - Общий streak
- **Секция достижений:**
  - Сетка бейджей (полученные + заблокированные)
  - Прогресс до следующего достижения
- **Настройки (список):**
  - Уведомления
  - Выбранные цели (редактирование)
  - Тема (светлая / темная / системная)
  - Язык
  - О приложении
  - Выйти из аккаунта

### 8. Add/Edit Habit Screen (Modal Bottom Sheet или Push)

- Поле "Название привычки"
- Выбор иконки (IconPicker grid)
- Выбор цвета (ColorPicker)
- Выбор категории (dropdown / chips)
- Расписание:
  - Каждый день / Определенные дни недели (toggle chips: Пн-Вс)
- Напоминание:
  - Toggle вкл/выкл
  - Выбор времени (TimePicker)
- Кнопка "Сохранить"
- Кнопка "Удалить" (только при редактировании, с подтверждением)

### 9. Habit Detail Screen

- Название + иконка + цвет
- Календарь выполнения (месячный вид)
- Статистика:
  - Текущий streak
  - Лучший streak
  - Всего выполнений
  - Процент выполнения
- График выполнения по неделям (bar chart)
- Кнопка редактирования
- Кнопка удаления

### 10. SOS Screen (экстренная поддержка)

- **Доступ:** кнопка на Home Screen (иконка в AppBar) или shake gesture
- Дыхательное упражнение (анимация)
- Мотивационное сообщение
- Список быстрых действий:
  - "Сделай глубокий вдох" (таймер дыхания)
  - "Запиши мысли" (→ дневник)
  - "Посмотри свой прогресс" (→ прогресс)
  - "Позвони близкому" (→ контакты)
- Минималистичный, спокойный дизайн

### 11. Achievements Screen

- Сетка всех бейджей (GridView)
- Полученные — полноцветные
- Заблокированные — серые + условие разблокировки
- Категории достижений:
  - Streak-бейджи (7 дней, 30 дней, 100 дней...)
  - Количественные (10 привычек, 50 отметок...)
  - Специальные (первая запись в дневнике, SOS использован...)

---

## Дизайн-система

### Цветовая палитра (Material 3 Dynamic Color)

| Токен | Назначение |
|-------|-----------|
| Primary | Основной акцент (кнопки, FAB, активные элементы) |
| Secondary | Вторичный акцент (chips, badges) |
| Tertiary | Акцент для streak/достижений |
| Surface | Фон карточек |
| Background | Фон экранов |
| Error | Ошибки и удаление |

Рекомендуемый основной цвет: оттенок зеленого (#4CAF50 / #2E7D32) — ассоциация с ростом и привычками.

### Типографика (Material 3 Type Scale)

| Стиль | Использование |
|-------|--------------|
| Display Large | Splash screen |
| Headline Large | Заголовки экранов |
| Headline Medium | Секции |
| Title Large | Названия привычек в деталях |
| Title Medium | Названия карточек |
| Body Large | Основной текст |
| Body Medium | Вторичный текст |
| Label Large | Кнопки |
| Label Medium | Badges, chips |

Шрифт: **Inter** или **Roboto** (нативный для Material)

### Иконки
- Material Symbols (Outlined, weight 400)
- Кастомные иконки для категорий привычек

### Скругления (Shape)
- Карточки: 16dp
- Кнопки: 12dp
- Chips: 8dp
- Аватар: круг

### Отступы
- Базовый grid: 8dp
- Padding экрана: 16dp
- Между секциями: 24dp
- Между элементами списка: 8dp

---

## Структура в Figma

```
Figma Project: HabitBoost
│
├── 📄 Page: Cover
│
├── 📄 Page: Design System
│   ├── Frame: Colors & Tokens
│   ├── Frame: Typography
│   ├── Frame: Icons
│   ├── Frame: Components (buttons, cards, inputs, chips, badges)
│   └── Frame: Patterns (lists, forms, navigation)
│
├── 📄 Page: Onboarding & Auth
│   ├── Frame: Splash
│   ├── Frame: Onboarding (3 screens)
│   ├── Frame: Login
│   ├── Frame: Register
│   └── Frame: Forgot Password
│
├── 📄 Page: Main — Home
│   ├── Frame: Home (с привычками)
│   ├── Frame: Home (empty state)
│   └── Frame: Home (все выполнено)
│
├── 📄 Page: Main — Progress
│   ├── Frame: Progress (неделя)
│   └── Frame: Progress (месяц)
│
├── 📄 Page: Main — Journal
│   ├── Frame: Journal (список)
│   ├── Frame: Journal (новая запись)
│   └── Frame: Journal (empty state)
│
├── 📄 Page: Main — Profile
│   ├── Frame: Profile
│   └── Frame: Settings
│
├── 📄 Page: Habits
│   ├── Frame: Add Habit
│   ├── Frame: Edit Habit
│   └── Frame: Habit Detail
│
├── 📄 Page: SOS & Achievements
│   ├── Frame: SOS Screen
│   └── Frame: Achievements Grid
│
├── 📄 Page: States & Edge Cases
│   ├── Frame: Loading states
│   ├── Frame: Error states
│   ├── Frame: No internet
│   └── Frame: Notifications (push preview)
│
└── 📄 Page: Prototype Flow
    └── Interactive prototype connections
```

---

## Порядок разработки экранов (приоритет)

### Phase 1 — MVP Core
1. Splash Screen
2. Login / Register
3. Home (список привычек + отметка)
4. Add/Edit Habit
5. Bottom Navigation (shell)

### Phase 2 — Engagement
6. Onboarding Flow
7. Progress Screen (календарь + статистика)
8. Habit Detail Screen
9. Push-уведомления (настройка)

### Phase 3 — Retention
10. Journal (дневник)
11. Achievements (бейджи)
12. SOS Screen
13. Profile + Settings

### Phase 4 — Polish
14. Dark theme
15. Анимации и переходы
16. Micro-interactions (confetti при выполнении, streak анимация)
17. Empty states & edge cases

---

## Масштабируемость

Дизайн подготовлен для будущих расширений:

| Будущая функция | Как вписывается |
|----------------|----------------|
| Носимые устройства | Companion app — отдельная Page в Figma, reuse компонентов |
| Расширенная аналитика | Новые виджеты на странице Progress |
| Социальные функции | Новый Tab "Community" в Bottom Navigation (5-й таб) |
| Персональные рекомендации | Секция "Рекомендации" на Home Screen |
| Челленджи | Отдельный экран, доступ из Community таба |
| Мультиязычность | Все тексты через Figma text styles + локализация во Flutter через ARB |

---

## Рекомендации по Figma

1. **Использовать Auto Layout** для всех фреймов — гарантирует адаптивность
2. **Компоненты с вариантами** (variants) для кнопок, карточек, состояний привычек
3. **Design tokens** через Variables — для быстрого переключения тем
4. **Material 3 Design Kit** как основа — экономит время и совместим с Flutter
5. **Прототипирование** — связать экраны для демонстрации flow
6. **Responsiveness** — тестировать на iPhone SE (375px) и iPhone 15 Pro Max (430px)
