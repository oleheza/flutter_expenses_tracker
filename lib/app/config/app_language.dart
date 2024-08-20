enum AppLanguage {
  english(code: 'en'),
  ukrainian(code: 'uk');

  final String code;

  const AppLanguage({required this.code});
}

AppLanguage getAppLanguageByString(String? code) {
  return switch (code) {
    'uk' => AppLanguage.ukrainian,
    _ => AppLanguage.english
  };
}
