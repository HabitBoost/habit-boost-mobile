import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ru'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In ru, this message translates to:
  /// **'HabitBoost'**
  String get appName;

  /// No description provided for @appSlogan.
  ///
  /// In ru, this message translates to:
  /// **'Маленькие шаги к большим переменам'**
  String get appSlogan;

  /// No description provided for @navHome.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get navHome;

  /// No description provided for @navProgress.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс'**
  String get navProgress;

  /// No description provided for @navJournal.
  ///
  /// In ru, this message translates to:
  /// **'Дневник'**
  String get navJournal;

  /// No description provided for @navProfile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get navProfile;

  /// No description provided for @authLoginTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вход в аккаунт'**
  String get authLoginTitle;

  /// No description provided for @authLogin.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get authLogin;

  /// No description provided for @authRegisterTitle.
  ///
  /// In ru, this message translates to:
  /// **'Создать аккаунт'**
  String get authRegisterTitle;

  /// No description provided for @authRegister.
  ///
  /// In ru, this message translates to:
  /// **'Зарегистрироваться'**
  String get authRegister;

  /// No description provided for @authForgotPassword.
  ///
  /// In ru, this message translates to:
  /// **'Забыли пароль?'**
  String get authForgotPassword;

  /// No description provided for @authEmail.
  ///
  /// In ru, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authEmailHint.
  ///
  /// In ru, this message translates to:
  /// **'example@email.com'**
  String get authEmailHint;

  /// No description provided for @authPassword.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get authPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердите пароль'**
  String get authConfirmPassword;

  /// No description provided for @authName.
  ///
  /// In ru, this message translates to:
  /// **'Имя'**
  String get authName;

  /// No description provided for @authNameHint.
  ///
  /// In ru, this message translates to:
  /// **'Ваше имя'**
  String get authNameHint;

  /// No description provided for @authHaveAccount.
  ///
  /// In ru, this message translates to:
  /// **'Уже есть аккаунт? '**
  String get authHaveAccount;

  /// No description provided for @authNoAccount.
  ///
  /// In ru, this message translates to:
  /// **'Нет аккаунта?'**
  String get authNoAccount;

  /// No description provided for @authOr.
  ///
  /// In ru, this message translates to:
  /// **'или'**
  String get authOr;

  /// No description provided for @authAcceptTerms.
  ///
  /// In ru, this message translates to:
  /// **'Примите условия использования'**
  String get authAcceptTerms;

  /// No description provided for @authAgreeTerms.
  ///
  /// In ru, this message translates to:
  /// **'Согласен с условиями использования'**
  String get authAgreeTerms;

  /// No description provided for @authResetPasswordTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сброс пароля'**
  String get authResetPasswordTitle;

  /// No description provided for @authResetPasswordDesc.
  ///
  /// In ru, this message translates to:
  /// **'Введите email, привязанный к вашему аккаунту. Мы отправим ссылку для сброса пароля.'**
  String get authResetPasswordDesc;

  /// No description provided for @authResetLinkSent.
  ///
  /// In ru, this message translates to:
  /// **'Ссылка для сброса отправлена на email'**
  String get authResetLinkSent;

  /// No description provided for @authSendLink.
  ///
  /// In ru, this message translates to:
  /// **'Отправить ссылку'**
  String get authSendLink;

  /// No description provided for @habitAdd.
  ///
  /// In ru, this message translates to:
  /// **'Добавить привычку'**
  String get habitAdd;

  /// No description provided for @habitEdit.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать'**
  String get habitEdit;

  /// No description provided for @habitDelete.
  ///
  /// In ru, this message translates to:
  /// **'Удалить'**
  String get habitDelete;

  /// No description provided for @habitTitle.
  ///
  /// In ru, this message translates to:
  /// **'Название привычки'**
  String get habitTitle;

  /// No description provided for @habitTitleHint.
  ///
  /// In ru, this message translates to:
  /// **'Например: Утренняя пробежка'**
  String get habitTitleHint;

  /// No description provided for @habitIcon.
  ///
  /// In ru, this message translates to:
  /// **'Иконка'**
  String get habitIcon;

  /// No description provided for @habitColor.
  ///
  /// In ru, this message translates to:
  /// **'Цвет'**
  String get habitColor;

  /// No description provided for @habitCategory.
  ///
  /// In ru, this message translates to:
  /// **'Категория'**
  String get habitCategory;

  /// No description provided for @habitDaysOfWeek.
  ///
  /// In ru, this message translates to:
  /// **'Дни недели'**
  String get habitDaysOfWeek;

  /// No description provided for @habitReminder.
  ///
  /// In ru, this message translates to:
  /// **'Напоминание'**
  String get habitReminder;

  /// No description provided for @habitAddReminder.
  ///
  /// In ru, this message translates to:
  /// **'Добавить напоминание'**
  String get habitAddReminder;

  /// No description provided for @habitDeleteConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Вы уверены, что хотите удалить эту привычку?'**
  String get habitDeleteConfirm;

  /// No description provided for @habitDetail.
  ///
  /// In ru, this message translates to:
  /// **'Детали привычки'**
  String get habitDetail;

  /// No description provided for @habitSchedule.
  ///
  /// In ru, this message translates to:
  /// **'Расписание'**
  String get habitSchedule;

  /// No description provided for @habitNotifDisabled.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления отключены в настройках. Включите их в профиле, чтобы получать напоминания.'**
  String get habitNotifDisabled;

  /// No description provided for @habitTodayTitle.
  ///
  /// In ru, this message translates to:
  /// **'Привычки на сегодня'**
  String get habitTodayTitle;

  /// No description provided for @habitEnterTitle.
  ///
  /// In ru, this message translates to:
  /// **'Введите название привычки'**
  String get habitEnterTitle;

  /// No description provided for @save.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @next.
  ///
  /// In ru, this message translates to:
  /// **'Далее'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In ru, this message translates to:
  /// **'Пропустить'**
  String get skip;

  /// No description provided for @categorySport.
  ///
  /// In ru, this message translates to:
  /// **'Спорт'**
  String get categorySport;

  /// No description provided for @categoryHealth.
  ///
  /// In ru, this message translates to:
  /// **'Здоровье'**
  String get categoryHealth;

  /// No description provided for @categoryProductivity.
  ///
  /// In ru, this message translates to:
  /// **'Продуктивность'**
  String get categoryProductivity;

  /// No description provided for @categoryMentalHealth.
  ///
  /// In ru, this message translates to:
  /// **'Ментальное здоровье'**
  String get categoryMentalHealth;

  /// No description provided for @categoryNutrition.
  ///
  /// In ru, this message translates to:
  /// **'Питание'**
  String get categoryNutrition;

  /// No description provided for @categoryLearning.
  ///
  /// In ru, this message translates to:
  /// **'Обучение'**
  String get categoryLearning;

  /// No description provided for @dayMon.
  ///
  /// In ru, this message translates to:
  /// **'Пн'**
  String get dayMon;

  /// No description provided for @dayTue.
  ///
  /// In ru, this message translates to:
  /// **'Вт'**
  String get dayTue;

  /// No description provided for @dayWed.
  ///
  /// In ru, this message translates to:
  /// **'Ср'**
  String get dayWed;

  /// No description provided for @dayThu.
  ///
  /// In ru, this message translates to:
  /// **'Чт'**
  String get dayThu;

  /// No description provided for @dayFri.
  ///
  /// In ru, this message translates to:
  /// **'Пт'**
  String get dayFri;

  /// No description provided for @daySat.
  ///
  /// In ru, this message translates to:
  /// **'Сб'**
  String get daySat;

  /// No description provided for @daySun.
  ///
  /// In ru, this message translates to:
  /// **'Вс'**
  String get daySun;

  /// No description provided for @dayMonShort.
  ///
  /// In ru, this message translates to:
  /// **'ПН'**
  String get dayMonShort;

  /// No description provided for @dayTueShort.
  ///
  /// In ru, this message translates to:
  /// **'ВТ'**
  String get dayTueShort;

  /// No description provided for @dayWedShort.
  ///
  /// In ru, this message translates to:
  /// **'СР'**
  String get dayWedShort;

  /// No description provided for @dayThuShort.
  ///
  /// In ru, this message translates to:
  /// **'ЧТ'**
  String get dayThuShort;

  /// No description provided for @dayFriShort.
  ///
  /// In ru, this message translates to:
  /// **'ПТ'**
  String get dayFriShort;

  /// No description provided for @daySatShort.
  ///
  /// In ru, this message translates to:
  /// **'СБ'**
  String get daySatShort;

  /// No description provided for @daySunShort.
  ///
  /// In ru, this message translates to:
  /// **'ВС'**
  String get daySunShort;

  /// No description provided for @streakAllDone.
  ///
  /// In ru, this message translates to:
  /// **'Все привычки выполнены!'**
  String get streakAllDone;

  /// No description provided for @streakProgress.
  ///
  /// In ru, this message translates to:
  /// **'Выполнено {completed} из {total}'**
  String streakProgress(int completed, int total);

  /// No description provided for @currentStreak.
  ///
  /// In ru, this message translates to:
  /// **'Текущая серия'**
  String get currentStreak;

  /// No description provided for @bestStreak.
  ///
  /// In ru, this message translates to:
  /// **'Лучшая серия'**
  String get bestStreak;

  /// No description provided for @completionRate.
  ///
  /// In ru, this message translates to:
  /// **'Процент выполнения'**
  String get completionRate;

  /// No description provided for @progressTitle.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс'**
  String get progressTitle;

  /// No description provided for @progressWeek.
  ///
  /// In ru, this message translates to:
  /// **'Неделя'**
  String get progressWeek;

  /// No description provided for @progressMonth.
  ///
  /// In ru, this message translates to:
  /// **'Месяц'**
  String get progressMonth;

  /// No description provided for @progressToday.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get progressToday;

  /// No description provided for @progressCurrentStreak.
  ///
  /// In ru, this message translates to:
  /// **'Текущий стрик'**
  String get progressCurrentStreak;

  /// No description provided for @progressForWeek.
  ///
  /// In ru, this message translates to:
  /// **'За неделю'**
  String get progressForWeek;

  /// No description provided for @progressForMonth.
  ///
  /// In ru, this message translates to:
  /// **'За месяц'**
  String get progressForMonth;

  /// No description provided for @progressHabitProgress.
  ///
  /// In ru, this message translates to:
  /// **'Прогресс привычек'**
  String get progressHabitProgress;

  /// No description provided for @journalTitle.
  ///
  /// In ru, this message translates to:
  /// **'Дневник'**
  String get journalTitle;

  /// No description provided for @journalNewEntry.
  ///
  /// In ru, this message translates to:
  /// **'Запись'**
  String get journalNewEntry;

  /// No description provided for @journalEditEntry.
  ///
  /// In ru, this message translates to:
  /// **'Редактировать запись'**
  String get journalEditEntry;

  /// No description provided for @journalNewEntryTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая запись'**
  String get journalNewEntryTitle;

  /// No description provided for @journalMoodQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Как ваше настроение?'**
  String get journalMoodQuestion;

  /// No description provided for @journalContentQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Что произошло сегодня?'**
  String get journalContentQuestion;

  /// No description provided for @journalContentHint.
  ///
  /// In ru, this message translates to:
  /// **'Напишите о своём дне...'**
  String get journalContentHint;

  /// No description provided for @journalTags.
  ///
  /// In ru, this message translates to:
  /// **'Теги'**
  String get journalTags;

  /// No description provided for @tagProductivity.
  ///
  /// In ru, this message translates to:
  /// **'Продуктивность'**
  String get tagProductivity;

  /// No description provided for @tagReflection.
  ///
  /// In ru, this message translates to:
  /// **'Рефлексия'**
  String get tagReflection;

  /// No description provided for @tagHealth.
  ///
  /// In ru, this message translates to:
  /// **'Здоровье'**
  String get tagHealth;

  /// No description provided for @tagSport.
  ///
  /// In ru, this message translates to:
  /// **'Спорт'**
  String get tagSport;

  /// No description provided for @tagLearning.
  ///
  /// In ru, this message translates to:
  /// **'Учёба'**
  String get tagLearning;

  /// No description provided for @moodGreat.
  ///
  /// In ru, this message translates to:
  /// **'Отлично'**
  String get moodGreat;

  /// No description provided for @moodGood.
  ///
  /// In ru, this message translates to:
  /// **'Хорошо'**
  String get moodGood;

  /// No description provided for @moodNeutral.
  ///
  /// In ru, this message translates to:
  /// **'Нормально'**
  String get moodNeutral;

  /// No description provided for @moodBad.
  ///
  /// In ru, this message translates to:
  /// **'Плохо'**
  String get moodBad;

  /// No description provided for @moodTerrible.
  ///
  /// In ru, this message translates to:
  /// **'Ужасно'**
  String get moodTerrible;

  /// No description provided for @profileUser.
  ///
  /// In ru, this message translates to:
  /// **'Пользователь'**
  String get profileUser;

  /// No description provided for @profileSettings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get profileSettings;

  /// No description provided for @profileDaysWithUs.
  ///
  /// In ru, this message translates to:
  /// **'Дней с нами'**
  String get profileDaysWithUs;

  /// No description provided for @profileHabitsCount.
  ///
  /// In ru, this message translates to:
  /// **'Привычек'**
  String get profileHabitsCount;

  /// No description provided for @profileBadgesCount.
  ///
  /// In ru, this message translates to:
  /// **'Бейджей'**
  String get profileBadgesCount;

  /// No description provided for @profileNotifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get profileNotifications;

  /// No description provided for @profileGoals.
  ///
  /// In ru, this message translates to:
  /// **'Мои цели'**
  String get profileGoals;

  /// No description provided for @profileTheme.
  ///
  /// In ru, this message translates to:
  /// **'Тема оформления'**
  String get profileTheme;

  /// No description provided for @profileAbout.
  ///
  /// In ru, this message translates to:
  /// **'О приложении'**
  String get profileAbout;

  /// No description provided for @profileSos.
  ///
  /// In ru, this message translates to:
  /// **'SOS — экстренная помощь'**
  String get profileSos;

  /// No description provided for @profileLogout.
  ///
  /// In ru, this message translates to:
  /// **'Выйти из аккаунта'**
  String get profileLogout;

  /// No description provided for @profileLogoutTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выход'**
  String get profileLogoutTitle;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Вы уверены, что хотите выйти из аккаунта?'**
  String get profileLogoutConfirm;

  /// No description provided for @profileLogoutAction.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get profileLogoutAction;

  /// No description provided for @profileLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get profileLanguage;

  /// No description provided for @themeSystem.
  ///
  /// In ru, this message translates to:
  /// **'Системная'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ru, this message translates to:
  /// **'Тёмная'**
  String get themeDark;

  /// No description provided for @languageSystem.
  ///
  /// In ru, this message translates to:
  /// **'Системный'**
  String get languageSystem;

  /// No description provided for @languageRussian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In ru, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @aboutVersion.
  ///
  /// In ru, this message translates to:
  /// **'Версия 0.1.0'**
  String get aboutVersion;

  /// No description provided for @aboutHabitTracking.
  ///
  /// In ru, this message translates to:
  /// **'Отслеживание привычек'**
  String get aboutHabitTracking;

  /// No description provided for @aboutHabitTrackingDesc.
  ///
  /// In ru, this message translates to:
  /// **'Создавайте привычки, отмечайте выполнение и следите за прогрессом каждый день.'**
  String get aboutHabitTrackingDesc;

  /// No description provided for @aboutCloudSync.
  ///
  /// In ru, this message translates to:
  /// **'Облачная синхронизация'**
  String get aboutCloudSync;

  /// No description provided for @aboutCloudSyncDesc.
  ///
  /// In ru, this message translates to:
  /// **'Ваши данные безопасно синхронизируются между устройствами через Firebase.'**
  String get aboutCloudSyncDesc;

  /// No description provided for @aboutMoodJournal.
  ///
  /// In ru, this message translates to:
  /// **'Дневник настроения'**
  String get aboutMoodJournal;

  /// No description provided for @aboutMoodJournalDesc.
  ///
  /// In ru, this message translates to:
  /// **'Записывайте мысли и отслеживайте настроение для понимания своих паттернов.'**
  String get aboutMoodJournalDesc;

  /// No description provided for @aboutCopyright.
  ///
  /// In ru, this message translates to:
  /// **'© 2026 HabitBoost'**
  String get aboutCopyright;

  /// No description provided for @aboutMadeWith.
  ///
  /// In ru, this message translates to:
  /// **'Сделано с заботой о ваших привычках'**
  String get aboutMadeWith;

  /// No description provided for @goalsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Мои цели'**
  String get goalsTitle;

  /// No description provided for @goalsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Выберите области, на которых хотите сфокусироваться'**
  String get goalsSubtitle;

  /// No description provided for @goalHealth.
  ///
  /// In ru, this message translates to:
  /// **'Здоровье'**
  String get goalHealth;

  /// No description provided for @goalProductivity.
  ///
  /// In ru, this message translates to:
  /// **'Продуктивность'**
  String get goalProductivity;

  /// No description provided for @goalMentalHealth.
  ///
  /// In ru, this message translates to:
  /// **'Ментальное\nсостояние'**
  String get goalMentalHealth;

  /// No description provided for @goalSport.
  ///
  /// In ru, this message translates to:
  /// **'Спорт'**
  String get goalSport;

  /// No description provided for @goalNutrition.
  ///
  /// In ru, this message translates to:
  /// **'Питание'**
  String get goalNutrition;

  /// No description provided for @goalLearning.
  ///
  /// In ru, this message translates to:
  /// **'Обучение'**
  String get goalLearning;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Создавай полезные привычки'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeDesc.
  ///
  /// In ru, this message translates to:
  /// **'HabitBoost поможет вам выработать полезные привычки шаг за шагом. Отслеживайте прогресс, получайте напоминания и достигайте целей каждый день.'**
  String get onboardingWelcomeDesc;

  /// No description provided for @onboardingGoalsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Что для вас важно?'**
  String get onboardingGoalsTitle;

  /// No description provided for @onboardingGoalsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Выберите области, на которых хотите сфокусироваться'**
  String get onboardingGoalsSubtitle;

  /// No description provided for @onboardingNotifTitle.
  ///
  /// In ru, this message translates to:
  /// **'Не пропускай привычки'**
  String get onboardingNotifTitle;

  /// No description provided for @onboardingNotifDesc.
  ///
  /// In ru, this message translates to:
  /// **'Включите уведомления, чтобы получать напоминания о привычках в нужное время и не пропускать ни одного дня.'**
  String get onboardingNotifDesc;

  /// No description provided for @onboardingNotifAllow.
  ///
  /// In ru, this message translates to:
  /// **'Разрешить уведомления'**
  String get onboardingNotifAllow;

  /// No description provided for @sosTitle.
  ///
  /// In ru, this message translates to:
  /// **'Экстренная помощь'**
  String get sosTitle;

  /// No description provided for @sosBanner.
  ///
  /// In ru, this message translates to:
  /// **'Сорвались или на грани? Это нормально.\nИспользуйте техники ниже, чтобы вернуть контроль.'**
  String get sosBanner;

  /// No description provided for @sosTechniquesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Техники самопомощи'**
  String get sosTechniquesTitle;

  /// No description provided for @sosTechnique1Title.
  ///
  /// In ru, this message translates to:
  /// **'Дыхание 4-7-8'**
  String get sosTechnique1Title;

  /// No description provided for @sosTechnique1Desc.
  ///
  /// In ru, this message translates to:
  /// **'Вдох 4 сек → задержка 7 сек → выдох 8 сек. Повторите 3–4 раза.'**
  String get sosTechnique1Desc;

  /// No description provided for @sosTechnique2Title.
  ///
  /// In ru, this message translates to:
  /// **'Техника 5-4-3-2-1'**
  String get sosTechnique2Title;

  /// No description provided for @sosTechnique2Desc.
  ///
  /// In ru, this message translates to:
  /// **'Назовите 5 вещей, которые видите, 4 — слышите, 3 — ощущаете, 2 — чувствуете запах, 1 — вкус.'**
  String get sosTechnique2Desc;

  /// No description provided for @sosTechnique3Title.
  ///
  /// In ru, this message translates to:
  /// **'Сканирование тела'**
  String get sosTechnique3Title;

  /// No description provided for @sosTechnique3Desc.
  ///
  /// In ru, this message translates to:
  /// **'Закройте глаза. Медленно переведите внимание от макушки к стопам, замечая ощущения.'**
  String get sosTechnique3Desc;

  /// No description provided for @sosTechnique4Title.
  ///
  /// In ru, this message translates to:
  /// **'Смена обстановки'**
  String get sosTechnique4Title;

  /// No description provided for @sosTechnique4Desc.
  ///
  /// In ru, this message translates to:
  /// **'Встаньте, пройдитесь, выпейте воды. Даже 2 минуты движения помогают.'**
  String get sosTechnique4Desc;

  /// No description provided for @notifTemplate0.
  ///
  /// In ru, this message translates to:
  /// **'Время для привычки «{title}»'**
  String notifTemplate0(String title);

  /// No description provided for @notifTemplate1.
  ///
  /// In ru, this message translates to:
  /// **'Пора выполнить «{title}»!'**
  String notifTemplate1(String title);

  /// No description provided for @notifTemplate2.
  ///
  /// In ru, this message translates to:
  /// **'Не забудь про «{title}» сегодня'**
  String notifTemplate2(String title);

  /// No description provided for @notifTemplate3.
  ///
  /// In ru, this message translates to:
  /// **'Напоминание: «{title}» ждёт тебя'**
  String notifTemplate3(String title);

  /// No description provided for @notifTemplate4.
  ///
  /// In ru, this message translates to:
  /// **'«{title}» — самое время начать!'**
  String notifTemplate4(String title);

  /// No description provided for @notifTemplate5.
  ///
  /// In ru, this message translates to:
  /// **'Давай выполним «{title}»!'**
  String notifTemplate5(String title);

  /// No description provided for @notifTemplate6.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня отличный день для «{title}»'**
  String notifTemplate6(String title);

  /// No description provided for @notifTemplate7.
  ///
  /// In ru, this message translates to:
  /// **'Маленький шаг: выполни «{title}»'**
  String notifTemplate7(String title);

  /// No description provided for @notifTemplate8.
  ///
  /// In ru, this message translates to:
  /// **'«{title}» — твоя привычка на сегодня'**
  String notifTemplate8(String title);

  /// No description provided for @notifTemplate9.
  ///
  /// In ru, this message translates to:
  /// **'Ты справишься! Пора за «{title}»'**
  String notifTemplate9(String title);

  /// No description provided for @notifChannelName.
  ///
  /// In ru, this message translates to:
  /// **'Напоминания о привычках'**
  String get notifChannelName;

  /// No description provided for @notifChannelDesc.
  ///
  /// In ru, this message translates to:
  /// **'Напоминания о выполнении привычек'**
  String get notifChannelDesc;

  /// No description provided for @quote0.
  ///
  /// In ru, this message translates to:
  /// **'Маленькие ежедневные улучшения — ключ к ошеломляющим долгосрочным результатам.'**
  String get quote0;

  /// No description provided for @quote1.
  ///
  /// In ru, this message translates to:
  /// **'Вы не поднимаетесь до уровня своих целей. Вы опускаетесь до уровня своих систем.'**
  String get quote1;

  /// No description provided for @quote2.
  ///
  /// In ru, this message translates to:
  /// **'Привычка — это не финишная черта, а образ жизни.'**
  String get quote2;

  /// No description provided for @quote3.
  ///
  /// In ru, this message translates to:
  /// **'Лучшее время посадить дерево было 20 лет назад. Второе лучшее время — сейчас.'**
  String get quote3;

  /// No description provided for @quote4.
  ///
  /// In ru, this message translates to:
  /// **'Дисциплина — это мост между целями и достижениями.'**
  String get quote4;

  /// No description provided for @errorNoInternet.
  ///
  /// In ru, this message translates to:
  /// **'Нет подключения к интернету'**
  String get errorNoInternet;

  /// No description provided for @errorSomethingWrong.
  ///
  /// In ru, this message translates to:
  /// **'Что-то пошло не так'**
  String get errorSomethingWrong;

  /// No description provided for @errorTryAgain.
  ///
  /// In ru, this message translates to:
  /// **'Попробовать снова'**
  String get errorTryAgain;

  /// No description provided for @errorLoadFailed.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка загрузки'**
  String get errorLoadFailed;

  /// No description provided for @emptyHabits.
  ///
  /// In ru, this message translates to:
  /// **'Пока нет привычек'**
  String get emptyHabits;

  /// No description provided for @emptyHabitsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Создайте первую привычку!'**
  String get emptyHabitsSubtitle;

  /// No description provided for @emptyJournal.
  ///
  /// In ru, this message translates to:
  /// **'Пока нет записей'**
  String get emptyJournal;

  /// No description provided for @emptyJournalSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Напишите первую запись в дневнике!'**
  String get emptyJournalSubtitle;

  /// No description provided for @validatorEmailRequired.
  ///
  /// In ru, this message translates to:
  /// **'Введите email'**
  String get validatorEmailRequired;

  /// No description provided for @validatorEmailInvalid.
  ///
  /// In ru, this message translates to:
  /// **'Некорректный email'**
  String get validatorEmailInvalid;

  /// No description provided for @validatorPasswordRequired.
  ///
  /// In ru, this message translates to:
  /// **'Введите пароль'**
  String get validatorPasswordRequired;

  /// No description provided for @validatorPasswordMinLength.
  ///
  /// In ru, this message translates to:
  /// **'Минимум 6 символов'**
  String get validatorPasswordMinLength;

  /// No description provided for @validatorPasswordsMismatch.
  ///
  /// In ru, this message translates to:
  /// **'Пароли не совпадают'**
  String get validatorPasswordsMismatch;

  /// No description provided for @validatorFieldRequired.
  ///
  /// In ru, this message translates to:
  /// **'{field} обязательно'**
  String validatorFieldRequired(String field);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
