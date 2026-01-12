import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en', 'US')) {
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    final box = Hive.box(AppConstants.appSettingsBox);
    final languageCode = box.get('language_code', defaultValue: 'en') as String;
    final countryCode = box.get('country_code', defaultValue: 'US') as String;
    emit(Locale(languageCode, countryCode));
  }

  Future<void> changeLanguage(Locale locale) async {
    final box = Hive.box(AppConstants.appSettingsBox);
    await box.put('language_code', locale.languageCode);
    await box.put('country_code', locale.countryCode ?? '');
    emit(locale);
  }

  void toggleLanguage() {
    if (state.languageCode == 'en') {
      changeLanguage(const Locale('ar', 'SA'));
    } else {
      changeLanguage(const Locale('en', 'US'));
    }
  }
}

