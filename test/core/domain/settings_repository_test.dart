import 'package:expenses_tracker/app/config/app_language.dart';
import 'package:expenses_tracker/app/config/app_theme_mode.dart';
import 'package:expenses_tracker/core/data/repository/settings_repository_impl.dart';
import 'package:expenses_tracker/core/domain/repository/settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SettingsRepository settingsRepository;

  setUp(
    () async {
      SharedPreferences.setMockInitialValues(
        {
          SettingsRepositoryImpl.keyLocale: AppLanguage.ukrainian.code,
          SettingsRepositoryImpl.keyThemeMode: AppThemeMode.dark.name,
        },
      );
      final sharedPreferences = await SharedPreferences.getInstance();
      settingsRepository = SettingsRepositoryImpl(sharedPreferences);
    },
  );

  test('test settings return correct locale', () async {
    var locale = settingsRepository.getCurrentLocale();
    expect(locale, AppLanguage.ukrainian.code);

    settingsRepository.saveCurrentLocale(AppLanguage.english.code);

    locale = settingsRepository.getCurrentLocale();
    expect(locale, AppLanguage.english.code);
  });

  test(
    'test settings return correct theme mode',
    () async {
      var themeMode = settingsRepository.getThemeMode();
      expect(themeMode, AppThemeMode.dark.name);

      settingsRepository.saveThemeMode(AppThemeMode.light.name);
      themeMode = settingsRepository.getThemeMode();
      expect(themeMode, AppThemeMode.light.name);

      settingsRepository.saveThemeMode(AppThemeMode.system.name);
      themeMode = settingsRepository.getThemeMode();
      expect(themeMode, AppThemeMode.system.name);
    },
  );
}
