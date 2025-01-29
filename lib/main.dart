import 'package:clean_machine/screens/Login/login_screen/login_screen.dart';
import 'package:clean_machine/screens/home/home_screen/home_screen.dart';
import 'package:clean_machine/screens/orderDetails/orderDetailsController/order_details_controller.dart';
import 'package:clean_machine/services/app_translation.dart';
import 'package:clean_machine/services/memory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path/path.dart';
import 'screens/splash/splash_screen/splash_screen.dart';
import 'services/localization_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => CacheHelper.init(), permanent: true);
  Get.put(LocalizationService.init(), permanent: true);

  // Set the app language based on the device language
  final deviceLocale = await _getDeviceLocale();
  final locale = deviceLocale == 'ar' ? Locale('ar', 'EG') : Locale('en', 'US');

  runApp(MyApp(initialLocale: locale));
}

Future<String> _getDeviceLocale() async {
  // Get the device's locale
  final locale = await Get.find<LocalizationService>().getDeviceLocale();
  return locale.languageCode;
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;

  MyApp({required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GetMaterialApp(
      title: 'Clean Machine',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      translations: AppTranslations(),
      locale: initialLocale, // Set initial locale based on device language
      supportedLocales: SupportedLocales.all,
      fallbackLocale: SupportedLocales.english,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
