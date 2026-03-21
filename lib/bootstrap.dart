import 'package:flutter/material.dart';
import 'package:habit_boost/app/di/injection_container.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO(dev): Initialize Firebase after running `flutterfire configure`
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // FlutterError.onError =
  //     FirebaseCrashlytics.instance.recordFlutterFatalError;

  await configureDependencies();
}
