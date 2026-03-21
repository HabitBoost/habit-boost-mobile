import 'package:get_it/get_it.dart';
import 'package:habit_boost/app/di/injection_container.config.dart';
import 'package:injectable/injectable.dart';

final sl = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => sl.init();
