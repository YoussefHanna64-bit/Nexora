import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class LanguageCubit extends HydratedCubit<Locale> {
  LanguageCubit() : super(const Locale('en'));

  void changeLanguage(String languageCode) {
    emit(Locale(languageCode));
  }

  bool get isArabic => state.languageCode == 'ar';

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    final languageCode = json['languageCode'] as String?;
    return languageCode != null ? Locale(languageCode) : const Locale('en');
  }

  @override
  Map<String, dynamic>? toJson(Locale state) {
    return {'languageCode': state.languageCode};
  }
}
