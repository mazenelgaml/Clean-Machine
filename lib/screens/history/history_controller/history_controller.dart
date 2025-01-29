import 'package:clean_machine/models/get_all_plan_history.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/get_all_plan_model.dart';
import '../../../services/end_points.dart';
import '../../../services/localization_services.dart';
import '../../../services/memory.dart';
import '../../../services/translation_key.dart';

class HistoryController extends GetxController{
  bool isLoading = false; // Loading state
  final cacheHelper = Get.find<CacheHelper>();
  List<GetAllPlanHistoryModel> allPlan=[];
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

  Future<void> getUserPlanHistory(DateTime startDate, DateTime endDate) async {
    allPlan=[];
    print("Fetching plans from: $startDate to $endDate");
    isLoading = true;
    update(); // Notify listeners about the loading state

    String id = await Get.find<CacheHelper>().getData(key: "id"); // Retrieve the user ID
    final Dio dio = Dio(BaseOptions(
      baseUrl: EndPoint.baseUrl,
      validateStatus: (status) => status != null && status < 500,
    ));

    try {
      final response = await dio.get(
        "/api/Reports/GetBYDate&RepresentativeId",
        queryParameters: {
          "StartDate": startDate.toIso8601String(),
          "EndDate": endDate.toIso8601String(),
          "RepresentativeId": id,
        },
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        print("Response data type: ${response.data.runtimeType}");
        print("Response data: ${response.data}");

        // Handle response when it's a single Map object
        if (response.data is Map<String, dynamic>) {
          final plan = GetAllPlanHistoryModel.fromJson(response.data);
          allPlan = [plan]; // Wrap the single plan in a list
        } else if (response.data is List) {
          // Handle response when it's a List of Maps
          allPlan = List<GetAllPlanHistoryModel>.from(
            response.data.map((x) => GetAllPlanHistoryModel.fromJson(x as Map<String, dynamic>)),
          );
        } else {
          throw Exception('Unexpected response format');
        }

        print("Fetched plans: $allPlan");
      } else {}
    } catch (e) {
      print("Error occurred: $e");
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Error occurred while connecting to the server')),
      );
    } finally {
      isLoading = false; // Hide loading indicator
      update(); // Notify listeners
    }
  }
}