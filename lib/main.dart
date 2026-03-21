import 'package:flutter/material.dart';
import 'package:habit_boost/app/app.dart';
import 'package:habit_boost/bootstrap.dart';

Future<void> main() async {
  await bootstrap();
  runApp(App());
}
