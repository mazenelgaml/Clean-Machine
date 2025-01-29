import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'memory.dart';
import 'package:flutter/services.dart';

class SupportedLocales {
  static final List<Locale> all = [const Locale("en"), const Locale("ar")];

  static const Locale english = Locale("en");
  static const Locale arabic = Locale("ar");
}

class LocalizationService extends GetxService {
  LocalizationService(this._activeLocale);

  final Rx<Locale> _activeLocale;

  Locale get activeLocale => _activeLocale.value;

  set activeLocale(Locale locale) {
    _activeLocale.value = locale;
    Get.find<CacheHelper>().activeLocale = locale; // Update storage
    Get.updateLocale(locale); // Update language in GetX
  }

  static LocalizationService init() {
    // Retrieve active locale from storage or set default to English
    Locale activeLocale = Get.find<CacheHelper>().activeLocale ?? SupportedLocales.english;
    return LocalizationService(activeLocale.obs);
  }

  void toggleLocale() {
    activeLocale = activeLocale == SupportedLocales.arabic
        ? SupportedLocales.english
        : SupportedLocales.arabic;
  }

  // New method to get the device's locale
  Future<Locale> getDeviceLocale() async {
    // Fetch the device's locale using the platform method
    final locale = await window.locales.first;
    return locale ?? SupportedLocales.english; // Default to English if null
  }
}
