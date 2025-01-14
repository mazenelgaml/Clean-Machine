import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../orderDetails/orderDetailsScreen/order_details_screen.dart';

class HomeController extends GetxController {
  int currentTabIndex = 0; // For BottomNavigationBar

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
                  // Handle Arabic language selection
                  Navigator.pop(context); // Close the bottom sheet
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
                    child: Text("ar", style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle English language selection
                  Navigator.pop(context); // Close the bottom sheet
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
                    child: Text("en", style: TextStyle(fontSize: 18, color: Colors.black)),
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
    update(); // Notify GetX to rebuild
  }

  // Builds content for each tab
  Widget buildTabContent(String tabName) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: 5, // Example count
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            Get.to(()=>DynamicExpandableContainer());
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
                    "Order num: 608${index + 3}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Serial num: ${tabName} ${index + 1}",
                    style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Alex Bank", style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w800)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color:Colors.black),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "Location for ${tabName.toLowerCase()} orders.",
                          style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.w800),
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
}
