import 'package:clean_machine/screens/profile/profileScreen/profile_screen.dart';
import 'package:clean_machine/services/translation_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../cutom_widgets/cutom_nav_bar.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (HomeController controller) {
        return DefaultTabController(
          length: 3, // Number of tabs
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
                  Tab(text:plan.tr),
                  Tab(text: reject.tr),
                  Tab(text: waiting.tr),

                ],
              ),
            ),
            body: TabBarView(
              children: [
                controller.buildTabContent(plan.tr),
                controller.buildTabContent(reject.tr),
                controller.buildTabContent(waiting.tr),

              ],
            ),
              bottomNavigationBar: CustomNavBar(currentTabIndex: 0,)



            ,floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  controller.isLoading=true;
                  controller.getUserPlan();
                  controller.getUserReject();
                  controller.getUserWaiting();

                });
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
