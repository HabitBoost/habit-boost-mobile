import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:habit_boost/core/network/network_info.dart';
import 'package:habit_boost/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:habit_boost/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:habit_boost/features/auth/domain/repositories/auth_repository.dart';
import 'package:habit_boost/features/auth/domain/usecases/get_current_user.dart';
import 'package:habit_boost/features/auth/domain/usecases/login.dart';
import 'package:habit_boost/features/auth/domain/usecases/logout.dart';
import 'package:habit_boost/features/auth/domain/usecases/register.dart';
import 'package:habit_boost/features/auth/domain/usecases/reset_password.dart';
import 'package:habit_boost/features/habits/domain/repositories/habits_repository.dart';
import 'package:habit_boost/features/habits/domain/usecases/create_habit.dart';
import 'package:habit_boost/features/habits/domain/usecases/delete_habit.dart';
import 'package:habit_boost/features/habits/domain/usecases/get_completions_for_date.dart';
import 'package:habit_boost/features/habits/domain/usecases/get_today_habits.dart';
import 'package:habit_boost/features/habits/domain/usecases/toggle_completion.dart';
import 'package:habit_boost/features/habits/domain/usecases/update_habit.dart';
import 'package:habit_boost/features/journal/domain/repositories/journal_repository.dart';
import 'package:habit_boost/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:habit_boost/features/progress/domain/repositories/progress_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthRemoteDataSource extends Mock
    implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock
    implements AuthLocalDataSource {}

class MockLogin extends Mock implements Login {}

class MockRegister extends Mock implements Register {}

class MockLogout extends Mock implements Logout {}

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

class MockResetPassword extends Mock implements ResetPassword {}

class MockOnboardingRepository extends Mock
    implements OnboardingRepository {}

class MockHabitsRepository extends Mock implements HabitsRepository {}

class MockGetTodayHabits extends Mock implements GetTodayHabits {}

class MockCreateHabit extends Mock implements CreateHabit {}

class MockUpdateHabit extends Mock implements UpdateHabit {}

class MockDeleteHabit extends Mock implements DeleteHabit {}

class MockToggleCompletion extends Mock implements ToggleCompletion {}

class MockGetCompletionsForDate extends Mock
    implements GetCompletionsForDate {}

class MockJournalRepository extends Mock implements JournalRepository {}

class MockProgressRepository extends Mock implements ProgressRepository {}
