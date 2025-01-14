import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text(
              'Hi There!  ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Icon(
              Icons.waving_hand, // يمكن استبداله برمز آخر
              color: Colors.yellow,
              size: 30,
            ),
          ],
        ),
        Text(
          'Welcone back,Sign in to your account',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        Container(
          width: Get.width*0.8,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.email, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0), // Rounded corners
                borderSide: BorderSide.none,
              ),
            ),

          ),
        ),
      ]),
    );
  }
}
