// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:habit_boost/app/di/register_module.dart' as _i258;
import 'package:habit_boost/core/database/app_database.dart' as _i935;
import 'package:habit_boost/core/network/network_info.dart' as _i931;
import 'package:habit_boost/features/auth/data/datasources/auth_local_datasource.dart'
    as _i972;
import 'package:habit_boost/features/auth/data/datasources/auth_local_memory_datasource.dart'
    as _i1062;
import 'package:habit_boost/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i76;
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
import 'package:habit_boost/features/habits/data/datasources/habits_local_datasource.dart'
    as _i1015;
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
import 'package:habit_boost/features/onboarding/data/datasources/onboarding_local_datasource.dart'
    as _i802;
import 'package:habit_boost/features/onboarding/data/repositories/onboarding_repository_impl.dart'
    as _i55;
import 'package:habit_boost/features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i809;
import 'package:habit_boost/features/onboarding/presentation/bloc/onboarding_bloc.dart'
    as _i162;
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
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i935.AppDatabase>(() => databaseModule.database);
    gh.lazySingleton<_i1015.HabitsLocalDataSource>(
      () => _i1015.HabitsLocalDataSource(gh<_i935.AppDatabase>()),
    );
    gh.lazySingleton<_i76.AuthRemoteDataSource>(
      () => _i1062.LocalAuthRemoteDataSource(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i419.HabitsRepository>(
      () => _i771.HabitsRepositoryImpl(gh<_i1015.HabitsLocalDataSource>()),
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
    gh.lazySingleton<_i931.NetworkInfo>(
      () => _i931.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i802.OnboardingLocalDataSource>(
      () => _i802.OnboardingLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i972.AuthLocalDataSource>(
      () => _i972.AuthLocalDataSourceImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i26.HabitFormBloc>(
      () => _i26.HabitFormBloc(
        createHabit: gh<_i164.CreateHabit>(),
        updateHabit: gh<_i543.UpdateHabit>(),
        deleteHabit: gh<_i1031.DeleteHabit>(),
      ),
    );
    gh.lazySingleton<_i683.AuthRepository>(
      () => _i398.AuthRepositoryImpl(
        gh<_i76.AuthRemoteDataSource>(),
        gh<_i972.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i342.HabitsBloc>(
      () => _i342.HabitsBloc(
        getTodayHabits: gh<_i42.GetTodayHabits>(),
        toggleCompletion: gh<_i87.ToggleCompletion>(),
        getCompletionsForDate: gh<_i103.GetCompletionsForDate>(),
      ),
    );
    gh.lazySingleton<_i809.OnboardingRepository>(
      () =>
          _i55.OnboardingRepositoryImpl(gh<_i802.OnboardingLocalDataSource>()),
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
    return this;
  }
}

class _$RegisterModule extends _i258.RegisterModule {}

class _$DatabaseModule extends _i935.DatabaseModule {}
