import 'package:clean_machine/models/get_all_plan_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../cutom_widgets/cutom_nav_bar.dart';
import '../../../services/translation_key.dart';
import '../../orderDetails/orderDetailsScreen/order_details_screen.dart';
import '../history_controller/history_controller.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime? _toDate;
  DateTime? _fromDate;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(
        init: HistoryController(),
        builder: (HistoryController controller) {
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

              // إذا كان التاريخين موجودين، نقوم باستدعاء الدالة مرة واحدة
              if (_fromDate != null && _toDate != null) {
                controller.getUserPlanHistory(_toDate!, _fromDate!);
              }
            }
          }


          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: BackButton(color: Colors.white, onPressed: () { Get.back(); }),
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
                            toDate.tr,
                            Colors.black,
                            Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){_selectDate(context, isToDate: false);},
                          child: _buildDateContainer(
                            _fromDate,
                            fromDate.tr,
                            Colors.black,
                            Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // Spacing between date pickers and displayed date
          controller.isLoading?Center(child: CircularProgressIndicator(),):controller.allPlan == null || controller.allPlan.isEmpty?Container(height: Get.height*0.6,child: Center(child: Text(noDataAvailable.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),)):Container(
            height: Get.height*0.5,
            width: Get.width*0.9,
            child: ListView.builder(
            padding: EdgeInsets.all(5.0),
            itemCount: controller.allPlan?.length??0, // Use the length of the selected list
            itemBuilder: (context, index) {
            // Access the specific item in the selected list
            GetAllPlanHistoryModel plan =  controller.allPlan![index];

            return GestureDetector(
            onTap: () {
            Get.to(() => DynamicExpandableContainer(orderNum: plan.orderNumberFooter, serialNum: plan.atmserial==null?"":plan.atmserial, atmName:plan.banknameL1, atmLocation:plan.atmlocation==null?"":plan.atmlocation, footerId:plan.footerId,bankAtmId:plan.bankAtmid,));
            },
            child: Card(
            color: Color(0xffcfd0d4),
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
            padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                        ],
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        child:Image(image: plan.imageUrl==null||plan.imageUrl==""?AssetImage("assets/images/atm-machine-3d-icon-png.png"):NetworkImage(plan.imageUrl),fit: BoxFit.fill,) ,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        plan.banknameL1,
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
                        child: GestureDetector(
                          onTap: () async {
                            String atmLocation = plan.atmlocation ?? "";

                            if (atmLocation.isNotEmpty) {
                              String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$atmLocation";

                              if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
                                await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
                              } else {
                                print("Could not launch Google Maps");
                              }
                            } else {
                              print("ATM location is empty");
                            }
                          },
                          child: Text(
                            plan.atmlocation ?? "",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
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
            ),
          )
                ],
              ),
            ),
          );
        });
  }

  Widget _buildDateContainer(DateTime? date, String label, Color bgColor, Color textColor) {
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
          date != null ? "${date.day}/${date.month}/${date.year}" : label,
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
