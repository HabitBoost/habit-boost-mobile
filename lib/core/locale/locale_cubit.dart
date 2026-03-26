import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit(this._prefs) : super(_loadInitial(_prefs));

  static const _key = 'app_locale';

  final SharedPreferences _prefs;

  static Locale? _loadInitial(SharedPreferences prefs) {
    final value = prefs.getString(_key);
    if (value == null) return null;
    return Locale(value);
  }

  Future<void> setLocale(Locale? locale) async {
    emit(locale);
    if (locale == null) {
      await _prefs.remove(_key);
    } else {
      await _prefs.setString(_key, locale.languageCode);
    }
  }
}
