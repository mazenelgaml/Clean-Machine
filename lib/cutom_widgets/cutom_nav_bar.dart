import 'package:clean_machine/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              }if(index==0)
              {
                Get.off(()=>HomeScreen());
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
    );
  }
}
