import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class LanguageCubit extends HydratedCubit<Locale?> {
  LanguageCubit() : super(null);

  void changeLanguage(String languageCode) {
    emit(Locale(languageCode));
  }

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    final languageCode = json["languageCode"] as String?;
    return languageCode != null ? Locale(languageCode) : null;
  }

  @override
  Map<String, dynamic>? toJson(Locale? state) {
    if (state == null) {
      return null;
    }

    return {"languageCode": state.languageCode};
  }
}
