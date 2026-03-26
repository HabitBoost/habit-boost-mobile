import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_boost/app/di/injection_container.dart';
import 'package:habit_boost/app/router/app_router.dart';
import 'package:habit_boost/core/locale/locale_cubit.dart';
import 'package:habit_boost/core/theme/app_theme.dart';
import 'package:habit_boost/core/theme/theme_cubit.dart';
import 'package:habit_boost/l10n/app_localizations.dart';

class App extends StatelessWidget {
  App({super.key});

  final _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<LocaleCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale?>(
            builder: (context, locale) {
              return createBlocProviders(
                child: MaterialApp.router(
                  title: 'HabitBoost',
                  theme: AppTheme.light(),
                  darkTheme: AppTheme.dark(),
                  themeMode: themeMode,
                  locale: locale,
                  supportedLocales:
                      AppLocalizations.supportedLocales,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  routerConfig: _router,
                  debugShowCheckedModeBanner: false,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
