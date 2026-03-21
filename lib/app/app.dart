import 'package:flutter/material.dart';
import 'package:habit_boost/app/router/app_router.dart';
import 'package:habit_boost/core/constants/app_strings.dart';
import 'package:habit_boost/core/theme/app_theme.dart';

class App extends StatelessWidget {
  App({super.key});

  final _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return createBlocProviders(
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
