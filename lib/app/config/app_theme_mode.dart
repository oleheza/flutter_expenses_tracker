enum AppThemeMode { system, light, dark }

AppThemeMode getThemeModeByString(String? mode) {
  return mode != null ? AppThemeMode.values.byName(mode) : AppThemeMode.system;
}

