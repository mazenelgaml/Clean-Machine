import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // Added package for decoding token

import '../../../services/end_points.dart';
import '../../../services/memory.dart';
import '../../home/home_screen/home_screen.dart';

class LoginController extends GetxController {
  // Controllers for email and password input
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Observables for checkbox and password visibility
  RxBool isChecked = false.obs;
  RxBool obscureText = true.obs;

  // Form validation key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Validation for email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email with "@"';
    }
    return null;
  }

  // Validation for password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  // Toggle for Remember Me checkbox
  void toggleRememberMe(bool? newValue) {
    isChecked.value = newValue ?? false;
  }

  // Loading state
  bool isLoading = false;

  // On Login button press
  void onLoginPressed(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      await logIn(context);
    }
  }

  // Login function
  Future<void> logIn(BuildContext context) async {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: EndPoint.baseUrl,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    isLoading = true; // Start loading
    update(); // Notify listeners about the change

    try {
      final response = await dio.post(
        "/UserAuthontication/Login",
        data: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        final token = response.data; // Extract the token from the response
        print(token);

        if (token != null && token.isNotEmpty) {
          try {
            Map<String, dynamic> decodedToken = JwtDecoder.decode(token); // Decode the token
            print(decodedToken); // For debugging
            // Adjust this based on your token structure
            String? userId = decodedToken['UserId']; // Change 'userId' to the actual key in your token
            await Get.find<CacheHelper>().saveData(key: "id", value: userId);
            if (userId != null) {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.success,
                title: "Login Successful",
                text: "Welcome to Clean Machine",
              ).then((_) async {
                if (isChecked.value) {
                  // Save token if Remember Me is checked
                  await Get.find<CacheHelper>().saveData(key: "token",value: token,);
                }
                // Navigate to HomeScreen
                Get.off(() => HomeScreen());
              });
            } else {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.error,
                title: "Error",
                text: "User ID not found in the token.",
              );
            }
          } catch (e) {
            print('Error decoding token: $e');
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              title: "Token Decoding Error",
              text: "Failed to decode the token.",
            );
          }
        }

        else {
          // If token is null or empty
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Error",
            text: "Invalid token received.",
          );
        }
      } else {
        // Show error alert for invalid credentials
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "Error",
          text: "Invalid username or password.\nPlease try again.",
        );
      }
    } catch (e) {
      // Show error alert for connection issues
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "Connection Error",
        text: "Error occurred while connecting to the API",
      );
    } finally {
      isLoading = false; // Stop loading
      update(); // Notify listeners about the change
    }
  }

}
