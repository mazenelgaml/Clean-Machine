import 'package:clean_machine/services/end_points.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/get_user_data_model.dart';
import '../../../services/localization_services.dart';
import '../../../services/memory.dart';
import '../../../services/translation_key.dart';

class ProfileController extends GetxController{
  bool isLoading=false;
  GetUserDataModel?userData;

  @override
  Future<void> onInit() async {
    super.onInit();
    await CacheHelper.init();
    await getUserProfile();
  }
  final cacheHelper = Get.find<CacheHelper>();
  void showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  // تغيير اللغة إلى العربية
                  final newLocale =  SupportedLocales.arabic;
                  // Update in storage and GetX
                  cacheHelper.activeLocale = newLocale;
                  Get.updateLocale(newLocale);
                  Navigator.pop(context); // إغلاق الـ bottom sheet
                },
                child: Container(
                  width: Get.width * 0.93,
                  height: Get.height * 0.05,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(ar.tr,
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // تغيير اللغة إلى الإنجليزية
                  final newLocale =  SupportedLocales.english;
                  // Update in storage and GetX
                  cacheHelper.activeLocale = newLocale;
                  Get.updateLocale(newLocale);
                  Navigator.pop(context); // إغلاق الـ bottom sheet
                },
                child: Container(
                  width: Get.width * 0.93,
                  height: Get.height * 0.05,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(en.tr,
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> getUserProfile() async {
    isLoading=true;
    update();
    String id=await Get.find<CacheHelper>().getData(key: "id");
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: EndPoint.baseUrl,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );
    // Start loading

    try {
      final response = await dio.get(
        "/api/ApplicationUsers/GetUserById/${id}",
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        GetUserDataModel userDataModel=GetUserDataModel.fromJson(response.data);
        userData=userDataModel;

      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text('Error fetching user data')));
      }
    } catch (e) {
      print(e);
      // Handle any errors that occur during the API call
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Error occurred while connecting to the Server')));

    } finally {
      isLoading = false;
      update();// Stop loading
    }
    update(); // Update UI
  }
}