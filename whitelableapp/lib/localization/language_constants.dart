import 'package:flutter/material.dart';
import 'package:whitelableapp/localization/demo_localization.dart';
import 'package:whitelableapp/service/shared_preference.dart';

//languages code
const String english = 'en';
const String hindi = 'hi';
const String gujrati = 'ml';

Future<Locale> setLocale(String languageCode) async {
  await SharedPreference.setLocale(languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  String languageCode = SharedPreference.getLocale();
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case english:
      return Locale(english, 'US');
    case gujrati:
      return Locale(gujrati, "IN");
    case hindi:
      return Locale(hindi, "IN");
    default:
      return Locale(english, 'US');
  }
}

String getTranslated(BuildContext context, var key) {
  return DemoLocalization.of(context)!.translate(key);
}