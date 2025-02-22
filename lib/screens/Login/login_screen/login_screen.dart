import 'package:clean_machine/services/translation_key.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Login_controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    void togglePasswordVisibility() {
      controller.obscureText.value = !controller.obscureText.value;
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    hiThere.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Icon(
                    Icons.waving_hand,
                    color: Colors.yellow,
                    size: 30,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                welcomeBack.tr+signInToYourAccount.tr,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Container(
                  width: Get.width * 0.9,
                  child: TextFormField(

                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: email.tr,
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.email, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: controller.validateEmail,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Container(
                  width: Get.width * 0.9,
                  child: Obx(() => TextFormField(
                    controller: controller.passwordController,
                    obscureText: controller.obscureText.value,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: password.tr,
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscureText.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: togglePasswordVisibility,
                      ),
                    ),
                    validator: controller.validatePassword,
                  )),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Obx(() => Checkbox(
                    value: controller.isChecked.value,
                    onChanged: controller.toggleRememberMe,
                  )),
                  Text(
                    rememberMe.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap:(){ controller.onLoginPressed(context);},
                child: Container(
                  width: Get.width * 0.9,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Center(
                    child: Text(
                      logIn.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
