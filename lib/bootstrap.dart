import 'package:flutter/material.dart';
import 'package:habit_boost/app/di/injection_container.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru');

  // Local auth mode — no backend required.
  // When adding Supabase/Firebase, use DI environments to switch:
  //   await configureDependencies(environment: Environment.prod);
  await configureDependencies();
}
