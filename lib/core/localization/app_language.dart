enum AppLanguage {
  english('en', 'US', '🇬🇧', 'English'),
  arabic('ar', 'SA', '🇸🇦', 'العربية');

  final String languageCode;
  final String countryCode;
  final String flag;
  final String nativeName;

  const AppLanguage(
    this.languageCode,
    this.countryCode,
    this.flag,
    this.nativeName,
  );

  String get localeString => '${languageCode}_$countryCode';

  static AppLanguage fromLanguageCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.languageCode == code,
      orElse: () => AppLanguage.english,
    );
  }
}

