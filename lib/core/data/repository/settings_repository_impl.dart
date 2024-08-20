import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repository/settings_repository.dart';

@Injectable(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _sharedPreferences;

  @visibleForTesting
  static const keyThemeMode = 'themeMode';
  @visibleForTesting
  static const keyLocale = 'locale';

  SettingsRepositoryImpl(this._sharedPreferences);

  @override
  String? getThemeMode() {
    return _sharedPreferences.getString(keyThemeMode);
  }

  @override
  Future<bool> saveThemeMode(String mode) {
    return _sharedPreferences.setString(keyThemeMode, mode);
  }

  @override
  String? getCurrentLocale() {
    return _sharedPreferences.getString(keyLocale);
  }

  @override
  Future<bool> saveCurrentLocale(String locale) {
    return _sharedPreferences.setString(keyLocale, locale);
  }
}
