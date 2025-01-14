import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../home/home_screen.dart';
 // استيراد صفحة HomeScreen

class LoginController extends GetxController {
  RxBool isChecked = false.obs;
  RxBool obscureText = true.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email with "@"';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  void onLoginPressed() {
    if (formKey.currentState?.validate() ?? false) {
      if (isChecked.value) {
        // نجاح تسجيل الدخول
        Get.snackbar('Success', 'Login Successful');
        // الانتقال إلى الصفحة الرئيسية
        Get.off(() => HomeScreen());
      } else {
        Get.snackbar('Error', 'Please agree to Remember Me');
      }
    }
  }



  void toggleRememberMe(bool? newValue) {
    isChecked.value = newValue ?? false;
  }
}
