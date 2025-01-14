import 'package:clean_machine/screens/profile/profileScreen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cutom_widgets/cutom_nav_bar.dart';
import 'controller/home_controller.dart';

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
          length: 4, // Number of tabs
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
                  Tab(text: "Plan"),
                  Tab(text: "Reject"),
                  Tab(text: "Waiting"),
                  Tab(text: "Review"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                controller.buildTabContent("Plan"),
                controller.buildTabContent("Reject"),
                controller.buildTabContent("Waiting"),
                controller.buildTabContent("Review"),
              ],
            ),
              bottomNavigationBar: CustomNavBar(currentTabIndex: 0,)



            ,floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {

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
