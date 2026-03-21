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
import 'package:habit_boost/features/onboarding/domain/repositories/onboarding_repository.dart';
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
