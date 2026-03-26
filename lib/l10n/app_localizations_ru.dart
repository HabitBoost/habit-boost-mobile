// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'HabitBoost';

  @override
  String get appSlogan => 'Маленькие шаги к большим переменам';

  @override
  String get navHome => 'Сегодня';

  @override
  String get navProgress => 'Прогресс';

  @override
  String get navJournal => 'Дневник';

  @override
  String get navProfile => 'Профиль';

  @override
  String get authLoginTitle => 'Вход в аккаунт';

  @override
  String get authLogin => 'Войти';

  @override
  String get authRegisterTitle => 'Создать аккаунт';

  @override
  String get authRegister => 'Зарегистрироваться';

  @override
  String get authForgotPassword => 'Забыли пароль?';

  @override
  String get authEmail => 'Email';

  @override
  String get authEmailHint => 'example@email.com';

  @override
  String get authPassword => 'Пароль';

  @override
  String get authConfirmPassword => 'Подтвердите пароль';

  @override
  String get authName => 'Имя';

  @override
  String get authNameHint => 'Ваше имя';

  @override
  String get authHaveAccount => 'Уже есть аккаунт? ';

  @override
  String get authNoAccount => 'Нет аккаунта?';

  @override
  String get authOr => 'или';

  @override
  String get authAcceptTerms => 'Примите условия использования';

  @override
  String get authAgreeTerms => 'Согласен с условиями использования';

  @override
  String get authResetPasswordTitle => 'Сброс пароля';

  @override
  String get authResetPasswordDesc =>
      'Введите email, привязанный к вашему аккаунту. Мы отправим ссылку для сброса пароля.';

  @override
  String get authResetLinkSent => 'Ссылка для сброса отправлена на email';

  @override
  String get authSendLink => 'Отправить ссылку';

  @override
  String get habitAdd => 'Добавить привычку';

  @override
  String get habitEdit => 'Редактировать';

  @override
  String get habitDelete => 'Удалить';

  @override
  String get habitTitle => 'Название привычки';

  @override
  String get habitTitleHint => 'Например: Утренняя пробежка';

  @override
  String get habitIcon => 'Иконка';

  @override
  String get habitColor => 'Цвет';

  @override
  String get habitCategory => 'Категория';

  @override
  String get habitDaysOfWeek => 'Дни недели';

  @override
  String get habitReminder => 'Напоминание';

  @override
  String get habitAddReminder => 'Добавить напоминание';

  @override
  String get habitDeleteConfirm =>
      'Вы уверены, что хотите удалить эту привычку?';

  @override
  String get habitDetail => 'Детали привычки';

  @override
  String get habitSchedule => 'Расписание';

  @override
  String get habitNotifDisabled =>
      'Уведомления отключены в настройках. Включите их в профиле, чтобы получать напоминания.';

  @override
  String get habitTodayTitle => 'Привычки на сегодня';

  @override
  String get habitEnterTitle => 'Введите название привычки';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get next => 'Далее';

  @override
  String get skip => 'Пропустить';

  @override
  String get categorySport => 'Спорт';

  @override
  String get categoryHealth => 'Здоровье';

  @override
  String get categoryProductivity => 'Продуктивность';

  @override
  String get categoryMentalHealth => 'Ментальное здоровье';

  @override
  String get categoryNutrition => 'Питание';

  @override
  String get categoryLearning => 'Обучение';

  @override
  String get dayMon => 'Пн';

  @override
  String get dayTue => 'Вт';

  @override
  String get dayWed => 'Ср';

  @override
  String get dayThu => 'Чт';

  @override
  String get dayFri => 'Пт';

  @override
  String get daySat => 'Сб';

  @override
  String get daySun => 'Вс';

  @override
  String get dayMonShort => 'ПН';

  @override
  String get dayTueShort => 'ВТ';

  @override
  String get dayWedShort => 'СР';

  @override
  String get dayThuShort => 'ЧТ';

  @override
  String get dayFriShort => 'ПТ';

  @override
  String get daySatShort => 'СБ';

  @override
  String get daySunShort => 'ВС';

  @override
  String get streakAllDone => 'Все привычки выполнены!';

  @override
  String streakProgress(int completed, int total) {
    return 'Выполнено $completed из $total';
  }

  @override
  String get currentStreak => 'Текущая серия';

  @override
  String get bestStreak => 'Лучшая серия';

  @override
  String get completionRate => 'Процент выполнения';

  @override
  String get progressTitle => 'Прогресс';

  @override
  String get progressWeek => 'Неделя';

  @override
  String get progressMonth => 'Месяц';

  @override
  String get progressToday => 'Сегодня';

  @override
  String get progressCurrentStreak => 'Текущий стрик';

  @override
  String get progressForWeek => 'За неделю';

  @override
  String get progressForMonth => 'За месяц';

  @override
  String get progressHabitProgress => 'Прогресс привычек';

  @override
  String get journalTitle => 'Дневник';

  @override
  String get journalNewEntry => 'Запись';

  @override
  String get journalEditEntry => 'Редактировать запись';

  @override
  String get journalNewEntryTitle => 'Новая запись';

  @override
  String get journalMoodQuestion => 'Как ваше настроение?';

  @override
  String get journalContentQuestion => 'Что произошло сегодня?';

  @override
  String get journalContentHint => 'Напишите о своём дне...';

  @override
  String get journalTags => 'Теги';

  @override
  String get tagProductivity => 'Продуктивность';

  @override
  String get tagReflection => 'Рефлексия';

  @override
  String get tagHealth => 'Здоровье';

  @override
  String get tagSport => 'Спорт';

  @override
  String get tagLearning => 'Учёба';

  @override
  String get moodGreat => 'Отлично';

  @override
  String get moodGood => 'Хорошо';

  @override
  String get moodNeutral => 'Нормально';

  @override
  String get moodBad => 'Плохо';

  @override
  String get moodTerrible => 'Ужасно';

  @override
  String get profileUser => 'Пользователь';

  @override
  String get profileSettings => 'Настройки';

  @override
  String get profileDaysWithUs => 'Дней с нами';

  @override
  String get profileHabitsCount => 'Привычек';

  @override
  String get profileBadgesCount => 'Бейджей';

  @override
  String get profileNotifications => 'Уведомления';

  @override
  String get profileGoals => 'Мои цели';

  @override
  String get profileTheme => 'Тема оформления';

  @override
  String get profileAbout => 'О приложении';

  @override
  String get profileSos => 'SOS — экстренная помощь';

  @override
  String get profileLogout => 'Выйти из аккаунта';

  @override
  String get profileLogoutTitle => 'Выход';

  @override
  String get profileLogoutConfirm =>
      'Вы уверены, что хотите выйти из аккаунта?';

  @override
  String get profileLogoutAction => 'Выйти';

  @override
  String get profileLanguage => 'Язык';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get languageSystem => 'Системный';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get aboutVersion => 'Версия 0.1.0';

  @override
  String get aboutHabitTracking => 'Отслеживание привычек';

  @override
  String get aboutHabitTrackingDesc =>
      'Создавайте привычки, отмечайте выполнение и следите за прогрессом каждый день.';

  @override
  String get aboutCloudSync => 'Облачная синхронизация';

  @override
  String get aboutCloudSyncDesc =>
      'Ваши данные безопасно синхронизируются между устройствами через Firebase.';

  @override
  String get aboutMoodJournal => 'Дневник настроения';

  @override
  String get aboutMoodJournalDesc =>
      'Записывайте мысли и отслеживайте настроение для понимания своих паттернов.';

  @override
  String get aboutCopyright => '© 2026 HabitBoost';

  @override
  String get aboutMadeWith => 'Сделано с заботой о ваших привычках';

  @override
  String get goalsTitle => 'Мои цели';

  @override
  String get goalsSubtitle =>
      'Выберите области, на которых хотите сфокусироваться';

  @override
  String get goalHealth => 'Здоровье';

  @override
  String get goalProductivity => 'Продуктивность';

  @override
  String get goalMentalHealth => 'Ментальное\nсостояние';

  @override
  String get goalSport => 'Спорт';

  @override
  String get goalNutrition => 'Питание';

  @override
  String get goalLearning => 'Обучение';

  @override
  String get onboardingWelcomeTitle => 'Создавай полезные привычки';

  @override
  String get onboardingWelcomeDesc =>
      'HabitBoost поможет вам выработать полезные привычки шаг за шагом. Отслеживайте прогресс, получайте напоминания и достигайте целей каждый день.';

  @override
  String get onboardingGoalsTitle => 'Что для вас важно?';

  @override
  String get onboardingGoalsSubtitle =>
      'Выберите области, на которых хотите сфокусироваться';

  @override
  String get onboardingNotifTitle => 'Не пропускай привычки';

  @override
  String get onboardingNotifDesc =>
      'Включите уведомления, чтобы получать напоминания о привычках в нужное время и не пропускать ни одного дня.';

  @override
  String get onboardingNotifAllow => 'Разрешить уведомления';

  @override
  String get sosTitle => 'Экстренная помощь';

  @override
  String get sosBanner =>
      'Сорвались или на грани? Это нормально.\nИспользуйте техники ниже, чтобы вернуть контроль.';

  @override
  String get sosTechniquesTitle => 'Техники самопомощи';

  @override
  String get sosTechnique1Title => 'Дыхание 4-7-8';

  @override
  String get sosTechnique1Desc =>
      'Вдох 4 сек → задержка 7 сек → выдох 8 сек. Повторите 3–4 раза.';

  @override
  String get sosTechnique2Title => 'Техника 5-4-3-2-1';

  @override
  String get sosTechnique2Desc =>
      'Назовите 5 вещей, которые видите, 4 — слышите, 3 — ощущаете, 2 — чувствуете запах, 1 — вкус.';

  @override
  String get sosTechnique3Title => 'Сканирование тела';

  @override
  String get sosTechnique3Desc =>
      'Закройте глаза. Медленно переведите внимание от макушки к стопам, замечая ощущения.';

  @override
  String get sosTechnique4Title => 'Смена обстановки';

  @override
  String get sosTechnique4Desc =>
      'Встаньте, пройдитесь, выпейте воды. Даже 2 минуты движения помогают.';

  @override
  String notifTemplate0(String title) {
    return 'Время для привычки «$title»';
  }

  @override
  String notifTemplate1(String title) {
    return 'Пора выполнить «$title»!';
  }

  @override
  String notifTemplate2(String title) {
    return 'Не забудь про «$title» сегодня';
  }

  @override
  String notifTemplate3(String title) {
    return 'Напоминание: «$title» ждёт тебя';
  }

  @override
  String notifTemplate4(String title) {
    return '«$title» — самое время начать!';
  }

  @override
  String notifTemplate5(String title) {
    return 'Давай выполним «$title»!';
  }

  @override
  String notifTemplate6(String title) {
    return 'Сегодня отличный день для «$title»';
  }

  @override
  String notifTemplate7(String title) {
    return 'Маленький шаг: выполни «$title»';
  }

  @override
  String notifTemplate8(String title) {
    return '«$title» — твоя привычка на сегодня';
  }

  @override
  String notifTemplate9(String title) {
    return 'Ты справишься! Пора за «$title»';
  }

  @override
  String get notifChannelName => 'Напоминания о привычках';

  @override
  String get notifChannelDesc => 'Напоминания о выполнении привычек';

  @override
  String get quote0 =>
      'Маленькие ежедневные улучшения — ключ к ошеломляющим долгосрочным результатам.';

  @override
  String get quote1 =>
      'Вы не поднимаетесь до уровня своих целей. Вы опускаетесь до уровня своих систем.';

  @override
  String get quote2 => 'Привычка — это не финишная черта, а образ жизни.';

  @override
  String get quote3 =>
      'Лучшее время посадить дерево было 20 лет назад. Второе лучшее время — сейчас.';

  @override
  String get quote4 => 'Дисциплина — это мост между целями и достижениями.';

  @override
  String get errorNoInternet => 'Нет подключения к интернету';

  @override
  String get errorSomethingWrong => 'Что-то пошло не так';

  @override
  String get errorTryAgain => 'Попробовать снова';

  @override
  String get errorLoadFailed => 'Ошибка загрузки';

  @override
  String get emptyHabits => 'Пока нет привычек';

  @override
  String get emptyHabitsSubtitle => 'Создайте первую привычку!';

  @override
  String get emptyJournal => 'Пока нет записей';

  @override
  String get emptyJournalSubtitle => 'Напишите первую запись в дневнике!';

  @override
  String get validatorEmailRequired => 'Введите email';

  @override
  String get validatorEmailInvalid => 'Некорректный email';

  @override
  String get validatorPasswordRequired => 'Введите пароль';

  @override
  String get validatorPasswordMinLength => 'Минимум 6 символов';

  @override
  String get validatorPasswordsMismatch => 'Пароли не совпадают';

  @override
  String validatorFieldRequired(String field) {
    return '$field обязательно';
  }
}
