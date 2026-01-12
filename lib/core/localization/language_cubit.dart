import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import 'app_language.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en', 'US')) {
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    final box = Hive.box(AppConstants.appSettingsBox);
    final languageCode = box.get(
      AppConstants.languageCodeKey,
      defaultValue: AppLanguage.english.languageCode,
    ) as String;
    final countryCode = box.get(
      AppConstants.countryCodeKey,
      defaultValue: AppLanguage.english.countryCode,
    ) as String;
    emit(Locale(languageCode, countryCode));
  }

  Future<void> changeLanguage(AppLanguage language) async {
    final box = Hive.box(AppConstants.appSettingsBox);
    await box.put(AppConstants.languageCodeKey, language.languageCode);
    await box.put(AppConstants.countryCodeKey, language.countryCode);
    emit(Locale(language.languageCode, language.countryCode));
  }

  void toggleLanguage() {
    final currentLanguage = AppLanguage.fromLanguageCode(state.languageCode);
    if (currentLanguage == AppLanguage.english) {
      changeLanguage(AppLanguage.arabic);
    } else {
      changeLanguage(AppLanguage.english);
    }
  }

  AppLanguage get currentLanguage {
    return AppLanguage.fromLanguageCode(state.languageCode);
  }
}

