import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  fontSize: 24,
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
              bottomNavigationBar: Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black, // Slightly transparent black background
                ),
                child: ClipRRect(

                  borderRadius: BorderRadius.circular(25),
                  child: BottomNavigationBar(

                    currentIndex: _currentTabIndex, // Replace with your current index variable
                    onTap: (index) {
                      setState(() {
                        _currentTabIndex = index;
                        if(index==2){
                          Get.to(()=>HomeScreen());
                        }// Update the current index on tap
                      });
                    },
                    items: const [
                      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                      BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
                      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
                    ],
                    backgroundColor: Colors.transparent, // Transparent background for the bar itself
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.grey,

                  ),
                ),
              )



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
