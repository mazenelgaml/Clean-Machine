import 'package:clean_machine/models/get_token_model.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../services/end_points.dart';
import '../../../services/memory.dart';
import '../../home/home_screen/home_screen.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isChecked = false.obs;
  RxBool obscureText = true.obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني';
    }
    if (!value.contains('@')) {
      return 'يرجى إدخال بريد إلكتروني صالح يحتوي على "@"';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    }
    return null;
  }

  void toggleRememberMe(bool? newValue) {
    isChecked.value = newValue ?? false;
  }

  void onLoginPressed(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      await logIn(context);
    }
  }

  Future<void> logIn(BuildContext context) async {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: EndPoint.baseUrl,
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    isLoading = true;
    update();

    try {
      final response = await dio.post(
        "/api/ApplicationUsers/login",
        data: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        final getTokenModel = GetTokenModel.fromJson(response.data);
        final token = getTokenModel.token;

        if (token != null && token.isNotEmpty) {
          try {
            if (token is! String) {
              throw Exception("التوكن المستلم ليس نصًا");
            }

            Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
            print("محتوى التوكن: $decodedToken");  // طباعة الداتا للتحقق

            // استخراج معرف المستخدم من التوكن باستخدام المفتاح الصحيح
            String? userId = decodedToken['UserId'] ?? decodedToken['sub'];
               print(userId);
            if (userId != null) {
              await Get.find<CacheHelper>().saveData(key: "id", value: userId);
              CoolAlert.show(
                context: context,
                type: CoolAlertType.success,
                title: "تم تسجيل الدخول بنجاح",
                text: "مرحبًا بك في Clean Machine",
              ).then((_) async {
                if (isChecked.value) {
                  await Get.find<CacheHelper>().saveData(key: "token", value: token);
                }
                Get.off(() => HomeScreen());
              });
            } else {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.error,
                title: "خطأ",
                text: "تعذر العثور على معرف المستخدم في التوكن.",
              );
            }
          } catch (e) {
            print('خطأ في فك التشفير: $e');
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              title: "خطأ في التوكن",
              text: "تعذر فك تشفير التوكن.",
            );
          }
        } else {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "خطأ",
            text: "التوكن المستلم غير صالح.",
          );
        }
      } else {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "خطأ",
          text: "البريد الإلكتروني أو كلمة المرور غير صحيحة، يرجى المحاولة مرة أخرى.",
        );
      }
    } catch (e) {
      print('خطأ تسجيل الدخول: $e');
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "خطأ في الاتصال",
        text: "حدث خطأ أثناء الاتصال بالخادم.",
      );
    } finally {
      isLoading = false;
      update();
    }
  }
}

// نموذج لاستخراج التوكن من الاستجابة
class GetTokenModel {
  final String token;

  GetTokenModel({required this.token});

  factory GetTokenModel.fromJson(Map<String, dynamic> json) {
    return GetTokenModel(
      token: json['token'] as String,
    );
  }
}
