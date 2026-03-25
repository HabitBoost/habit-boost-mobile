// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:habit_boost/app/di/register_module.dart' as _i258;
import 'package:habit_boost/core/database/app_database.dart' as _i935;
import 'package:habit_boost/core/network/network_info.dart' as _i931;
import 'package:habit_boost/core/sync/connectivity_listener.dart' as _i851;
import 'package:habit_boost/core/sync/sync_service.dart' as _i833;
import 'package:habit_boost/core/theme/theme_cubit.dart' as _i294;
import 'package:habit_boost/features/auth/data/datasources/auth_local_datasource.dart'
    as _i972;
import 'package:habit_boost/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i76;
import 'package:habit_boost/features/auth/data/datasources/firebase_auth_remote_datasource.dart'
    as _i578;
import 'package:habit_boost/features/auth/data/repositories/auth_repository_impl.dart'
    as _i398;
import 'package:habit_boost/features/auth/domain/repositories/auth_repository.dart'
    as _i683;
import 'package:habit_boost/features/auth/domain/usecases/get_current_user.dart'
    as _i594;
import 'package:habit_boost/features/auth/domain/usecases/login.dart' as _i683;
import 'package:habit_boost/features/auth/domain/usecases/logout.dart' as _i304;
import 'package:habit_boost/features/auth/domain/usecases/register.dart'
    as _i593;
import 'package:habit_boost/features/auth/domain/usecases/reset_password.dart'
    as _i161;
import 'package:habit_boost/features/auth/presentation/bloc/auth_bloc.dart'
    as _i786;
import 'package:habit_boost/features/habits/data/datasources/habits_firestore_datasource.dart'
    as _i458;
import 'package:habit_boost/features/habits/data/datasources/habits_local_datasource.dart'
    as _i1015;
import 'package:habit_boost/features/habits/data/datasources/habits_remote_datasource.dart'
    as _i67;
import 'package:habit_boost/features/habits/data/repositories/habits_repository_impl.dart'
    as _i771;
import 'package:habit_boost/features/habits/domain/repositories/habits_repository.dart'
    as _i419;
import 'package:habit_boost/features/habits/domain/usecases/create_habit.dart'
    as _i164;
import 'package:habit_boost/features/habits/domain/usecases/delete_habit.dart'
    as _i1031;
import 'package:habit_boost/features/habits/domain/usecases/get_completions_for_date.dart'
    as _i103;
import 'package:habit_boost/features/habits/domain/usecases/get_today_habits.dart'
    as _i42;
import 'package:habit_boost/features/habits/domain/usecases/toggle_completion.dart'
    as _i87;
import 'package:habit_boost/features/habits/domain/usecases/update_habit.dart'
    as _i543;
import 'package:habit_boost/features/habits/presentation/bloc/habit_form_bloc.dart'
    as _i26;
import 'package:habit_boost/features/habits/presentation/bloc/habits_bloc.dart'
    as _i342;
import 'package:habit_boost/features/journal/data/datasources/journal_firestore_datasource.dart'
    as _i211;
import 'package:habit_boost/features/journal/data/datasources/journal_local_datasource.dart'
    as _i314;
import 'package:habit_boost/features/journal/data/datasources/journal_remote_datasource.dart'
    as _i283;
import 'package:habit_boost/features/journal/data/repositories/journal_repository_impl.dart'
    as _i1068;
import 'package:habit_boost/features/journal/domain/repositories/journal_repository.dart'
    as _i249;
import 'package:habit_boost/features/journal/domain/usecases/create_journal_entry.dart'
    as _i360;
import 'package:habit_boost/features/journal/domain/usecases/delete_journal_entry.dart'
    as _i413;
import 'package:habit_boost/features/journal/domain/usecases/get_journal_entries.dart'
    as _i800;
import 'package:habit_boost/features/journal/domain/usecases/update_journal_entry.dart'
    as _i636;
import 'package:habit_boost/features/journal/presentation/bloc/journal_bloc.dart'
    as _i949;
import 'package:habit_boost/features/notifications/data/datasources/notification_service.dart'
    as _i1035;
import 'package:habit_boost/features/notifications/data/repositories/notification_repository_impl.dart'
    as _i189;
import 'package:habit_boost/features/notifications/domain/repositories/notification_repository.dart'
    as _i722;
import 'package:habit_boost/features/notifications/domain/usecases/cancel_habit_reminder.dart'
    as _i984;
import 'package:habit_boost/features/notifications/domain/usecases/schedule_habit_reminder.dart'
    as _i478;
import 'package:habit_boost/features/onboarding/data/datasources/onboarding_local_datasource.dart'
    as _i802;
import 'package:habit_boost/features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i55;
import 'package:habit_boost/features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i809;
import 'package:habit_boost/features/onboarding/presentation/bloc/onboarding_bloc.dart'
    as _i162;
import 'package:habit_boost/features/progress/data/datasources/progress_local_datasource.dart'
    as _i382;
import 'package:habit_boost/features/progress/data/repositories/progress_repository_impl.dart'
    as _i453;
import 'package:habit_boost/features/progress/domain/repositories/progress_repository.dart'
    as _i497;
import 'package:habit_boost/features/progress/domain/usecases/get_progress_stats.dart'
    as _i385;
import 'package:habit_boost/features/progress/presentation/bloc/progress_bloc.dart'
    as _i81;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final databaseModule = _$DatabaseModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i935.AppDatabase>(() => databaseModule.database);
    gh.lazySingleton<_i1035.NotificationService>(
      () => _i1035.NotificationService(),
    );
    gh.lazySingleton<_i76.AuthRemoteDataSource>(
      () => _i578.FirebaseAuthRemoteDataSource(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i722.NotificationRepository>(
      () => _i189.NotificationRepositoryImpl(gh<_i1035.NotificationService>()),
    );
    gh.lazySingleton<_i1015.HabitsLocalDataSource>(
      () => _i1015.HabitsLocalDataSource(gh<_i935.AppDatabase>()),
    );
    gh.lazySingleton<_i314.JournalLocalDataSource>(
      () => _i314.JournalLocalDataSource(gh<_i935.AppDatabase>()),
    );
    gh.lazySingleton<_i382.ProgressLocalDataSource>(
      () => _i382.ProgressLocalDataSource(gh<_i935.AppDatabase>()),
    );
    gh.lazySingleton<_i497.ProgressRepository>(
      () => _i453.ProgressRepositoryImpl(gh<_i382.ProgressLocalDataSource>()),
    );
    gh.factory<_i294.ThemeCubit>(
      () => _i294.ThemeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i385.GetProgressStats>(
      () => _i385.GetProgressStats(gh<_i497.ProgressRepository>()),
    );
    gh.lazySingleton<_i283.JournalRemoteDataSource>(
      () => _i211.JournalFirestoreDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i931.NetworkInfo>(
      () => _i931.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i802.OnboardingLocalDataSource>(
      () => _i802.OnboardingLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i67.HabitsRemoteDataSource>(
      () => _i458.HabitsFirestoreDataSource(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i972.AuthLocalDataSource>(
      () => _i972.AuthLocalDataSourceImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i81.ProgressBloc>(
      () => _i81.ProgressBloc(getProgressStats: gh<_i385.GetProgressStats>()),
    );
    gh.factory<_i984.CancelHabitReminder>(
      () => _i984.CancelHabitReminder(gh<_i722.NotificationRepository>()),
    );
    gh.factory<_i478.ScheduleHabitReminder>(
      () => _i478.ScheduleHabitReminder(gh<_i722.NotificationRepository>()),
    );
    gh.lazySingleton<_i683.AuthRepository>(
      () => _i398.AuthRepositoryImpl(
        gh<_i76.AuthRemoteDataSource>(),
        gh<_i972.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i833.SyncService>(
      () => _i833.SyncService(
        gh<_i935.AppDatabase>(),
        gh<_i931.NetworkInfo>(),
        gh<_i1015.HabitsLocalDataSource>(),
        gh<_i67.HabitsRemoteDataSource>(),
        gh<_i314.JournalLocalDataSource>(),
        gh<_i283.JournalRemoteDataSource>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i809.OnboardingRepository>(
      () => _i55.OnboardingRepositoryImpl(
        gh<_i802.OnboardingLocalDataSource>(),
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i419.HabitsRepository>(
      () => _i771.HabitsRepositoryImpl(
        gh<_i1015.HabitsLocalDataSource>(),
        gh<_i833.SyncService>(),
        gh<_i722.NotificationRepository>(),
      ),
    );
    gh.factory<_i164.CreateHabit>(
      () => _i164.CreateHabit(gh<_i419.HabitsRepository>()),
    );
    gh.factory<_i1031.DeleteHabit>(
      () => _i1031.DeleteHabit(gh<_i419.HabitsRepository>()),
    );
    gh.factory<_i103.GetCompletionsForDate>(
      () => _i103.GetCompletionsForDate(gh<_i419.HabitsRepository>()),
    );
    gh.factory<_i42.GetTodayHabits>(
      () => _i42.GetTodayHabits(gh<_i419.HabitsRepository>()),
    );
    gh.factory<_i87.ToggleCompletion>(
      () => _i87.ToggleCompletion(gh<_i419.HabitsRepository>()),
    );
    gh.factory<_i543.UpdateHabit>(
      () => _i543.UpdateHabit(gh<_i419.HabitsRepository>()),
    );
    gh.factory<_i162.OnboardingBloc>(
      () => _i162.OnboardingBloc(gh<_i809.OnboardingRepository>()),
    );
    gh.factory<_i594.GetCurrentUser>(
      () => _i594.GetCurrentUser(gh<_i683.AuthRepository>()),
    );
    gh.factory<_i683.Login>(() => _i683.Login(gh<_i683.AuthRepository>()));
    gh.factory<_i304.Logout>(() => _i304.Logout(gh<_i683.AuthRepository>()));
    gh.factory<_i593.Register>(
      () => _i593.Register(gh<_i683.AuthRepository>()),
    );
    gh.factory<_i161.ResetPassword>(
      () => _i161.ResetPassword(gh<_i683.AuthRepository>()),
    );
    gh.factory<_i786.AuthBloc>(
      () => _i786.AuthBloc(
        login: gh<_i683.Login>(),
        register: gh<_i593.Register>(),
        logout: gh<_i304.Logout>(),
        getCurrentUser: gh<_i594.GetCurrentUser>(),
        resetPassword: gh<_i161.ResetPassword>(),
      ),
    );
    gh.factory<_i26.HabitFormBloc>(
      () => _i26.HabitFormBloc(
        createHabit: gh<_i164.CreateHabit>(),
        updateHabit: gh<_i543.UpdateHabit>(),
        deleteHabit: gh<_i1031.DeleteHabit>(),
      ),
    );
    gh.lazySingleton<_i851.ConnectivityListener>(
      () => _i851.ConnectivityListener(
        gh<_i895.Connectivity>(),
        gh<_i833.SyncService>(),
      ),
    );
    gh.lazySingleton<_i249.JournalRepository>(
      () => _i1068.JournalRepositoryImpl(
        gh<_i314.JournalLocalDataSource>(),
        gh<_i833.SyncService>(),
      ),
    );
    gh.factory<_i360.CreateJournalEntry>(
      () => _i360.CreateJournalEntry(gh<_i249.JournalRepository>()),
    );
    gh.factory<_i413.DeleteJournalEntry>(
      () => _i413.DeleteJournalEntry(gh<_i249.JournalRepository>()),
    );
    gh.factory<_i800.GetJournalEntries>(
      () => _i800.GetJournalEntries(gh<_i249.JournalRepository>()),
    );
    gh.factory<_i636.UpdateJournalEntry>(
      () => _i636.UpdateJournalEntry(gh<_i249.JournalRepository>()),
    );
    gh.factory<_i949.JournalBloc>(
      () => _i949.JournalBloc(
        getJournalEntries: gh<_i800.GetJournalEntries>(),
        createJournalEntry: gh<_i360.CreateJournalEntry>(),
        updateJournalEntry: gh<_i636.UpdateJournalEntry>(),
        deleteJournalEntry: gh<_i413.DeleteJournalEntry>(),
      ),
    );
    gh.factory<_i342.HabitsBloc>(
      () => _i342.HabitsBloc(
        getTodayHabits: gh<_i42.GetTodayHabits>(),
        toggleCompletion: gh<_i87.ToggleCompletion>(),
        getCompletionsForDate: gh<_i103.GetCompletionsForDate>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i258.RegisterModule {}

class _$DatabaseModule extends _i935.DatabaseModule {}
