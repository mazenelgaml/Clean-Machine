import 'package:clean_machine/services/translation_key.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../cutom_widgets/cutom_nav_bar.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  final int initialTabIndex; // تحديد التاب الافتراضي

  const HomeScreen({super.key, this.initialTabIndex = 0}); // افتراضيًا يبدأ من التاب الأول

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentTabIndex;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTabIndex; // تحديد التاب بناءً على القيمة الممررة
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (HomeController controller) {
        return DefaultTabController(
          length: 3,
          initialIndex: _currentTabIndex, // يفتح التاب المحدد
          child: Scaffold(
            backgroundColor: Colors.white,
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
              bottom: TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: plan.tr),
                  Tab(text: waiting.tr),
                  Tab(text: reject.tr),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                controller.buildTabContent(plan.tr),
                controller.buildTabContent(waiting.tr),
                controller.buildTabContent(reject.tr),
              ],
            ),
            bottomNavigationBar: CustomNavBar(currentTabIndex: 0),
            floatingActionButton: FloatingActionButton(

                onPressed: () async {
                  var connectivityResult = await Connectivity().checkConnectivity();
                  if (connectivityResult.last != ConnectivityResult.none) {
                    setState(() {
                      controller.isLoading = true;
                      controller.getUserPlan();
                      controller.getUserReject();
                      controller.getUserWaiting();
                    });
                  } else {
                    Get.snackbar("No Internet", "Please check your internet connection");
                  }
                },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              backgroundColor: Colors.blue,
              child: Icon(Icons.refresh, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
