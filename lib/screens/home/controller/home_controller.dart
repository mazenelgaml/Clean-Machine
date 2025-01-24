import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/get_all_plan_model.dart';
import '../../../services/end_points.dart';
import '../../../services/localization_services.dart';
import '../../../services/memory.dart';
import '../../../services/translation_key.dart';
import '../../orderDetails/orderDetailsScreen/order_details_screen.dart';

class HomeController extends GetxController {
  final cacheHelper = Get.find<CacheHelper>();

  int currentTabIndex = 0; // For BottomNavigationBar
  bool isLoading = false; // Loading state

  List<GetAllPlansModel>? allPlan;
  List<GetAllPlansModel>? allRejectPlan;
  List<GetAllPlansModel>? allWaitingPlan;

  // Handles language selection bottom sheet
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

  // Handles tab changes in BottomNavigationBar
  void onTabChanged(int index) {
    currentTabIndex = index;
    isLoading = true; // Show loading indicator
    update(); // Notify GetX to rebuild

    // Fetch data for the selected tab
    if (currentTabIndex == 0) {
      getUserPlan(); // Fetch all plans when the first tab is selected
    } else if (currentTabIndex == 1) {
      getUserReject(); // Fetch rejected plans when the second tab is selected
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await CacheHelper.init();
    await getUserPlan();
    await getUserReject();
    await getUserWaiting(); // Initial fetch for the 'plan' tab data
  }

  // Builds content for each tab
  Widget buildTabContent(String tabName) {
    List<GetAllPlansModel>? selectedList;

    if (tabName == reject.tr) {
      selectedList = allRejectPlan;
    } else if (tabName == plan.tr) {
      selectedList = allPlan;
    } else if (tabName == waiting.tr) {
      selectedList = allWaitingPlan;
    }

    if (isLoading) {
      return Center(
          child: CircularProgressIndicator()); // Show loading indicator
    }

    if (selectedList == null || selectedList.isEmpty) {
      return Center(
          child:
              Text(noDataAvailable.tr)); // Show message if no data is available
    }

    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: selectedList.length, // Use the length of the selected list
      itemBuilder: (context, index) {
        // Access the specific item in the selected list
        GetAllPlansModel plan = selectedList![index];

        return GestureDetector(
          onTap: () {
            Get.to(() => DynamicExpandableContainer());
          },
          child: Card(
            color: Color(0xffcfd0d4),
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderNum.tr + ":" + "${plan.orderNumberFooter}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Serial num: ${plan.atmserial}",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        plan.bankname,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.black),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          plan.atmAdress,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Fetch user plan
  Future<void> getUserPlan() async {
    isLoading = true;
    update(); // Rebuild UI to show loading indicator

    String id = await Get.find<CacheHelper>().getData(key: "id");
    final Dio dio = Dio(BaseOptions(
      baseUrl: EndPoint.baseUrl,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));

    try {
      final response = await dio.get(
        "/DataAtm/WorkPlanFiltered?representativeId=${id}&orderStatusId=1",
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        List<GetAllPlansModel> plansList = List<GetAllPlansModel>.from(
            response.data.map((x) => GetAllPlansModel.fromJson(x)));
        allPlan = plansList; // Assign the list of plans to the allPlan variable
      } else {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text('Error fetching user data')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text('Error occurred while connecting to the Server')));
    } finally {
      isLoading = false; // Hide loading indicator
      update(); // Rebuild UI
    }
  }

  // Fetch rejected plans
  Future<void> getUserReject() async {
    isLoading = true;
    update(); // Rebuild UI to show loading indicator

    String id = await Get.find<CacheHelper>().getData(key: "id");
    final Dio dio = Dio(BaseOptions(
      baseUrl: EndPoint.baseUrl,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));

    try {
      final response = await dio.get(
        "/DataAtm/WorkPlanFiltered?representativeId=${id}&orderStatusId=6",
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        List<GetAllPlansModel> plansList = List<GetAllPlansModel>.from(
            response.data.map((x) => GetAllPlansModel.fromJson(x)));
        allRejectPlan =
            plansList; // Assign the list of rejected plans to allRejectPlan
      } else {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text('Error fetching user data')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text('Error occurred while connecting to the Server')));
    } finally {
      isLoading = false; // Hide loading indicator
      update(); // Rebuild UI
    }
  }

  Future<void> getUserWaiting() async {
    isLoading = true;
    update(); // Rebuild UI to show loading indicator

    String id = await Get.find<CacheHelper>().getData(key: "id");
    final Dio dio = Dio(BaseOptions(
      baseUrl: EndPoint.baseUrl,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));

    try {
      final response = await dio.get(
        "/DataAtm/WorkPlanFiltered?representativeId=${id}&orderStatusId=2",
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        List<GetAllPlansModel> plansList = List<GetAllPlansModel>.from(
            response.data.map((x) => GetAllPlansModel.fromJson(x)));
        allWaitingPlan =
            plansList; // Assign the list of rejected plans to allRejectPlan
      } else {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text('Error fetching user data')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text('Error occurred while connecting to the Server')));
    } finally {
      isLoading = false; // Hide loading indicator
      update(); // Rebuild UI
    }
  }
}
