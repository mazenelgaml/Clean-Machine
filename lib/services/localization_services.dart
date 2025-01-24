import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'memory.dart';

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
    Get.find<CacheHelper>().activeLocale = locale; // تحديث التخزين
    Get.updateLocale(locale); // تحديث اللغة في GetX
  }

  static LocalizationService init() {
    // جلب اللغة النشطة من التخزين أو التعيين إلى الإنجليزية كافتراضية
    Locale activeLocale = Get.find<CacheHelper>().activeLocale ?? SupportedLocales.english;
    return LocalizationService(activeLocale.obs);
  }

  void toggleLocale() {
    activeLocale = activeLocale == SupportedLocales.arabic
        ? SupportedLocales.english
        : SupportedLocales.arabic;
  }
}
