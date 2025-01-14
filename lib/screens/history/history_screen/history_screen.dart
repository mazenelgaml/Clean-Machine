import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../cutom_widgets/cutom_nav_bar.dart';
import '../history_controller/history_controller.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime? _toDate;
  DateTime? _fromDate;

  void _selectDate(BuildContext context, {required bool isToDate}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.grey[850]!,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.black,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isToDate) {
          _toDate = pickedDate;
        } else {
          _fromDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(
        init: HistoryController(),
        builder: (HistoryController controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: BackButton(color: Colors.white,onPressed: (){Get.back();},),
              title: Text(
                "History",
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
            ),
            bottomNavigationBar: CustomNavBar(
              currentTabIndex: 1,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, isToDate: true),
                          child: _buildDateContainer(
                            _toDate,
                            "To Date",
                            Colors.black,
                            Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, isToDate: false),
                          child: _buildDateContainer(
                            _fromDate,
                            "From Date",
                            Colors.black,
                            Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildDateContainer(
      DateTime? date, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          date != null
              ? "${date.day}/${date.month}/${date.year}"
              : label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
