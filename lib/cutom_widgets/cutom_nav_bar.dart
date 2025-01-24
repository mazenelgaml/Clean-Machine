import 'package:clean_machine/screens/home/home_screen/home_screen.dart';
import 'package:clean_machine/services/translation_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/history/history_screen/history_screen.dart';
import '../screens/profile/profileScreen/profile_screen.dart';

class CustomNavBar extends StatefulWidget {
  int currentTabIndex;
   CustomNavBar({super.key,  required this.currentTabIndex});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.black, // Slightly transparent black background
      ),
      child: ClipRRect(

        borderRadius: BorderRadius.circular(25),
        child: BottomNavigationBar(

          currentIndex: widget.currentTabIndex, // Replace with your current index variable
          onTap: (index) {
            setState(() {
              widget.currentTabIndex = index;
              if(index==2){
                Get.off(()=>ProfileScreen());
              }else if(index==0)
              {
                Get.off(()=>HomeScreen());
              }
              else{
                Get.off(()=>HistoryScreen());
              }// Update the current index on tap
            });
          },
          items:  [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: home.tr),
            BottomNavigationBarItem(icon: Icon(Icons.history), label:history.tr ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: profile.tr),
          ],
          backgroundColor: Colors.transparent, // Transparent background for the bar itself
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,

        ),
      ),
    );
  }
}
