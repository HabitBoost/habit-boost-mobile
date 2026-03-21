import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupTestDependencies() {
  // Register mock dependencies here as features are added.
}

void tearDownTestDependencies() {
  sl.reset();
}
