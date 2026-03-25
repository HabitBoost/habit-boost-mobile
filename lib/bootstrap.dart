import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habit_boost/app/di/injection_container.dart';
import 'package:habit_boost/core/sync/connectivity_listener.dart';
import 'package:habit_boost/core/utils/app_logger.dart';
import 'package:habit_boost/features/notifications/domain/repositories/notification_repository.dart';
import 'package:habit_boost/firebase_options.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('ru');
  await configureDependencies(environment: Environment.prod);
  sl<ConnectivityListener>().start();
  try {
    await sl<NotificationRepository>().init();
  } on Exception catch (e) {
    log.e('Notification init failed', error: e);
  }
}
