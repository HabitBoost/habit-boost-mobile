// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'HabitBoost';

  @override
  String get appSlogan => 'Small steps to big changes';

  @override
  String get navHome => 'Today';

  @override
  String get navProgress => 'Progress';

  @override
  String get navJournal => 'Journal';

  @override
  String get navProfile => 'Profile';

  @override
  String get authLoginTitle => 'Sign in';

  @override
  String get authLogin => 'Sign in';

  @override
  String get authRegisterTitle => 'Create account';

  @override
  String get authRegister => 'Sign up';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authEmail => 'Email';

  @override
  String get authEmailHint => 'example@email.com';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm password';

  @override
  String get authName => 'Name';

  @override
  String get authNameHint => 'Your name';

  @override
  String get authHaveAccount => 'Already have an account? ';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authOr => 'or';

  @override
  String get authAcceptTerms => 'Please accept the terms of use';

  @override
  String get authAgreeTerms => 'I agree to the terms of use';

  @override
  String get authResetPasswordTitle => 'Reset password';

  @override
  String get authResetPasswordDesc =>
      'Enter the email linked to your account. We will send a password reset link.';

  @override
  String get authResetLinkSent => 'Reset link has been sent to your email';

  @override
  String get authSendLink => 'Send link';

  @override
  String get habitAdd => 'Add habit';

  @override
  String get habitEdit => 'Edit';

  @override
  String get habitDelete => 'Delete';

  @override
  String get habitTitle => 'Habit name';

  @override
  String get habitTitleHint => 'E.g.: Morning jog';

  @override
  String get habitIcon => 'Icon';

  @override
  String get habitColor => 'Color';

  @override
  String get habitCategory => 'Category';

  @override
  String get habitDaysOfWeek => 'Days of the week';

  @override
  String get habitReminder => 'Reminder';

  @override
  String get habitAddReminder => 'Add reminder';

  @override
  String get habitDeleteConfirm =>
      'Are you sure you want to delete this habit?';

  @override
  String get habitDetail => 'Habit details';

  @override
  String get habitSchedule => 'Schedule';

  @override
  String get habitNotifDisabled =>
      'Notifications are disabled in settings. Enable them in your profile to receive reminders.';

  @override
  String get habitTodayTitle => 'Today\'s habits';

  @override
  String get habitEnterTitle => 'Enter a habit name';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get categorySport => 'Sports';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryProductivity => 'Productivity';

  @override
  String get categoryMentalHealth => 'Mental health';

  @override
  String get categoryNutrition => 'Nutrition';

  @override
  String get categoryLearning => 'Learning';

  @override
  String get dayMon => 'Mon';

  @override
  String get dayTue => 'Tue';

  @override
  String get dayWed => 'Wed';

  @override
  String get dayThu => 'Thu';

  @override
  String get dayFri => 'Fri';

  @override
  String get daySat => 'Sat';

  @override
  String get daySun => 'Sun';

  @override
  String get dayMonShort => 'MO';

  @override
  String get dayTueShort => 'TU';

  @override
  String get dayWedShort => 'WE';

  @override
  String get dayThuShort => 'TH';

  @override
  String get dayFriShort => 'FR';

  @override
  String get daySatShort => 'SA';

  @override
  String get daySunShort => 'SU';

  @override
  String get streakAllDone => 'All habits completed!';

  @override
  String streakProgress(int completed, int total) {
    return 'Completed $completed of $total';
  }

  @override
  String get currentStreak => 'Current streak';

  @override
  String get bestStreak => 'Best streak';

  @override
  String get completionRate => 'Completion rate';

  @override
  String get progressTitle => 'Progress';

  @override
  String get progressWeek => 'Week';

  @override
  String get progressMonth => 'Month';

  @override
  String get progressToday => 'Today';

  @override
  String get progressCurrentStreak => 'Current streak';

  @override
  String get progressForWeek => 'This week';

  @override
  String get progressForMonth => 'This month';

  @override
  String get progressHabitProgress => 'Habit progress';

  @override
  String get journalTitle => 'Journal';

  @override
  String get journalNewEntry => 'Entry';

  @override
  String get journalEditEntry => 'Edit entry';

  @override
  String get journalNewEntryTitle => 'New entry';

  @override
  String get journalMoodQuestion => 'How are you feeling?';

  @override
  String get journalContentQuestion => 'What happened today?';

  @override
  String get journalContentHint => 'Write about your day...';

  @override
  String get journalTags => 'Tags';

  @override
  String get tagProductivity => 'Productivity';

  @override
  String get tagReflection => 'Reflection';

  @override
  String get tagHealth => 'Health';

  @override
  String get tagSport => 'Sports';

  @override
  String get tagLearning => 'Learning';

  @override
  String get moodGreat => 'Great';

  @override
  String get moodGood => 'Good';

  @override
  String get moodNeutral => 'Okay';

  @override
  String get moodBad => 'Bad';

  @override
  String get moodTerrible => 'Terrible';

  @override
  String get profileUser => 'User';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileDaysWithUs => 'Days with us';

  @override
  String get profileHabitsCount => 'Habits';

  @override
  String get profileBadgesCount => 'Badges';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileGoals => 'My goals';

  @override
  String get profileTheme => 'App theme';

  @override
  String get profileAbout => 'About';

  @override
  String get profileSos => 'SOS — Emergency help';

  @override
  String get profileLogout => 'Sign out';

  @override
  String get profileLogoutTitle => 'Sign out';

  @override
  String get profileLogoutConfirm => 'Are you sure you want to sign out?';

  @override
  String get profileLogoutAction => 'Sign out';

  @override
  String get profileLanguage => 'Language';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageSystem => 'System';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get aboutVersion => 'Version 0.1.0';

  @override
  String get aboutHabitTracking => 'Habit tracking';

  @override
  String get aboutHabitTrackingDesc =>
      'Create habits, mark completions, and track your progress every day.';

  @override
  String get aboutCloudSync => 'Cloud sync';

  @override
  String get aboutCloudSyncDesc =>
      'Your data is securely synced across devices via Firebase.';

  @override
  String get aboutMoodJournal => 'Mood journal';

  @override
  String get aboutMoodJournalDesc =>
      'Write down your thoughts and track your mood to understand your patterns.';

  @override
  String get aboutCopyright => '© 2026 HabitBoost';

  @override
  String get aboutMadeWith => 'Made with care for your habits';

  @override
  String get goalsTitle => 'My goals';

  @override
  String get goalsSubtitle => 'Choose areas you want to focus on';

  @override
  String get goalHealth => 'Health';

  @override
  String get goalProductivity => 'Productivity';

  @override
  String get goalMentalHealth => 'Mental\nhealth';

  @override
  String get goalSport => 'Sports';

  @override
  String get goalNutrition => 'Nutrition';

  @override
  String get goalLearning => 'Learning';

  @override
  String get onboardingWelcomeTitle => 'Build healthy habits';

  @override
  String get onboardingWelcomeDesc =>
      'HabitBoost will help you develop healthy habits step by step. Track progress, get reminders, and achieve your goals every day.';

  @override
  String get onboardingGoalsTitle => 'What matters to you?';

  @override
  String get onboardingGoalsSubtitle => 'Choose areas you want to focus on';

  @override
  String get onboardingNotifTitle => 'Don\'t miss your habits';

  @override
  String get onboardingNotifDesc =>
      'Enable notifications to get habit reminders at the right time and never miss a day.';

  @override
  String get onboardingNotifAllow => 'Allow notifications';

  @override
  String get sosTitle => 'Emergency help';

  @override
  String get sosBanner =>
      'Slipped up or on the edge? That\'s okay.\nUse the techniques below to regain control.';

  @override
  String get sosTechniquesTitle => 'Self-help techniques';

  @override
  String get sosTechnique1Title => '4-7-8 Breathing';

  @override
  String get sosTechnique1Desc =>
      'Inhale 4 sec → hold 7 sec → exhale 8 sec. Repeat 3–4 times.';

  @override
  String get sosTechnique2Title => '5-4-3-2-1 Technique';

  @override
  String get sosTechnique2Desc =>
      'Name 5 things you see, 4 you hear, 3 you feel, 2 you smell, 1 you taste.';

  @override
  String get sosTechnique3Title => 'Body scan';

  @override
  String get sosTechnique3Desc =>
      'Close your eyes. Slowly move your attention from the top of your head to your feet, noticing sensations.';

  @override
  String get sosTechnique4Title => 'Change of scenery';

  @override
  String get sosTechnique4Desc =>
      'Stand up, take a walk, drink some water. Even 2 minutes of movement helps.';

  @override
  String notifTemplate0(String title) {
    return 'Time for \"$title\"';
  }

  @override
  String notifTemplate1(String title) {
    return 'Time to do \"$title\"!';
  }

  @override
  String notifTemplate2(String title) {
    return 'Don\'t forget about \"$title\" today';
  }

  @override
  String notifTemplate3(String title) {
    return 'Reminder: \"$title\" awaits you';
  }

  @override
  String notifTemplate4(String title) {
    return '\"$title\" — it\'s time to start!';
  }

  @override
  String notifTemplate5(String title) {
    return 'Let\'s do \"$title\"!';
  }

  @override
  String notifTemplate6(String title) {
    return 'Today is a great day for \"$title\"';
  }

  @override
  String notifTemplate7(String title) {
    return 'Small step: do \"$title\"';
  }

  @override
  String notifTemplate8(String title) {
    return '\"$title\" — your habit for today';
  }

  @override
  String notifTemplate9(String title) {
    return 'You can do it! Time for \"$title\"';
  }

  @override
  String get notifChannelName => 'Habit reminders';

  @override
  String get notifChannelDesc => 'Reminders to complete habits';

  @override
  String get quote0 =>
      'Small daily improvements are the key to staggering long-term results.';

  @override
  String get quote1 =>
      'You do not rise to the level of your goals. You fall to the level of your systems.';

  @override
  String get quote2 => 'A habit is not a finish line, but a way of life.';

  @override
  String get quote3 =>
      'The best time to plant a tree was 20 years ago. The second best time is now.';

  @override
  String get quote4 =>
      'Discipline is the bridge between goals and accomplishment.';

  @override
  String get errorNoInternet => 'No internet connection';

  @override
  String get errorSomethingWrong => 'Something went wrong';

  @override
  String get errorTryAgain => 'Try again';

  @override
  String get errorLoadFailed => 'Failed to load';

  @override
  String get emptyHabits => 'No habits yet';

  @override
  String get emptyHabitsSubtitle => 'Create your first habit!';

  @override
  String get emptyJournal => 'No entries yet';

  @override
  String get emptyJournalSubtitle => 'Write your first journal entry!';

  @override
  String get validatorEmailRequired => 'Enter your email';

  @override
  String get validatorEmailInvalid => 'Invalid email';

  @override
  String get validatorPasswordRequired => 'Enter your password';

  @override
  String get validatorPasswordMinLength => 'At least 6 characters';

  @override
  String get validatorPasswordsMismatch => 'Passwords don\'t match';

  @override
  String validatorFieldRequired(String field) {
    return '$field is required';
  }
}
