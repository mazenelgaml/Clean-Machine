import 'package:clean_machine/screens/Login/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../cutom_widgets/cutom_nav_bar.dart';
import '../profileController/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
    builder: (ProfileController controller) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: null,
        title: Text(
          "C Machine",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              controller.showLanguageBottomSheet(context);
            },
            icon: Icon(
              Icons.language_outlined,
              size: 25,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: Color(0xffcee5cb),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("0",style: TextStyle(
                              fontWeight: FontWeight.w800
                          ),),
                          Text("accept",style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12
                          ),),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: Color(0xfff7ced2),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("50",style: TextStyle(
                              fontWeight: FontWeight.w800
                          ),),
                          Text("OnReview",style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12
                          ),),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: Color(0xfffdf9ca),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("3",style: TextStyle(
                            fontWeight: FontWeight.w800
                          ),),
                          Text("Refused",style: TextStyle(
                              fontWeight: FontWeight.w700,
                            fontSize: 12
                          ),),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 36),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: Get.width * 0.9,
                    height: 40,
                    color: Colors.grey[400],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'm.elgamal0551@gmail.com',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: Get.width * 0.9,
                    height: 40,
                    color: Colors.grey[400],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'm.elgamal0551@gmail.com',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: Get.width * 0.9,
                    height: 40,
                    color: Colors.grey[400],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'm.elgamal0551@gmail.com',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: Get.width * 0.9,
                    height: 40,
                    color: Colors.grey[400],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            '12345678912',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: Get.width * 0.9,
                    height: 40,
                    color: Colors.grey[400],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            '2024-01-01',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: Get.width * 0.9,
                    height: 40,
                    color: Colors.grey[400],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            '2030-01-01',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: (){
                      Get.off(()=>LoginScreen());
                    },
                    child: Container(
                      width: Get.width * 0.9,
                      height: 40,
                      color: Colors.grey[500],
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(currentTabIndex: 2,),
    );});
  }
}
