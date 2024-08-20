abstract interface class SettingsRepository {
  Future<bool> saveThemeMode(String mode);

  String? getThemeMode();

  Future<bool> saveCurrentLocale(String locale);

  String? getCurrentLocale();
}
