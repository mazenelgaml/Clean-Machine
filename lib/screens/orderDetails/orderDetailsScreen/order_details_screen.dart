import 'dart:io';
import 'package:clean_machine/screens/orderDetails/orderDetailsController/order_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/translation_key.dart';

class DynamicExpandableContainer extends StatefulWidget {
  final int orderNum;
  final String serialNum;
  final String atmName;
  final String atmLocation;
  final String footerId;
  final String bankAtmId;

  const DynamicExpandableContainer({
    super.key,
    required this.orderNum,
    required this.serialNum,
    required this.atmName,
    required this.atmLocation,
    required this.footerId,
    required this.bankAtmId,
  });

  @override
  _DynamicExpandableContainerState createState() =>
      _DynamicExpandableContainerState();
}

class _DynamicExpandableContainerState
    extends State<DynamicExpandableContainer> {
  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required List<File> images,
    required VoidCallback onPickImage,
    required void Function(int index) onRemoveImage,
  }) {
    int rows = (images.length / 3).ceil(); // Calculate the number of rows
    double dynamicHeight = 54 + (isExpanded ? (rows * 120 + 60) : 0); // Adjust height dynamically

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: MediaQuery.of(context).size.width * 0.95,
        height: dynamicHeight,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: onToggle,
                        child: Icon(
                          isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  if (isExpanded)
                    Column(
                      children: [
                        GestureDetector(
                          onTap: onPickImage,
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        if (images.isNotEmpty)
                          Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: GridView.builder(
                              shrinkWrap: true, // Important: Allows the grid to adjust its height
                              physics: NeverScrollableScrollPhysics(), // Prevent GridView from scrolling independently
                              itemCount: images.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio:1, // Makes items square
                              ),
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Image.file(
                                      images[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () => onRemoveImage(index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailsController>(
        init: OrderDetailsController( footerId: widget.footerId, bankAtmId: widget.bankAtmId,),
        builder: (OrderDetailsController controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: BackButton(
                color: Colors.white,
                onPressed: () {
                  Get.back();
                },
              ),
              title: Text(
                orderDetails.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
            body: controller.isLoading?Center(child: CircularProgressIndicator()):SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    color: Color(0xffcfd0d4),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order num: ${widget.orderNum}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Serial num: ${widget.serialNum}",
                            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w800),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(widget.atmName, style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w800)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.black),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  widget.atmLocation,
                                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildExpandableSection(
                    title: beforeClean.tr,
                    isExpanded: controller.isBeforeCleanExpanded,
                    onToggle: () {
                      setState(() {
                        controller.isBeforeCleanExpanded = !controller.isBeforeCleanExpanded;
                      });
                    },
                    images: controller.beforeCleanImages,
                    onPickImage: () => controller.pickImageFromCamera(controller.beforeCleanImages),
                    onRemoveImage: (index) => controller.removeImage(controller.beforeCleanImages, index),
                  ),
                  _buildExpandableSection(
                    title: afterClean.tr,
                    isExpanded: controller.isAfterCleanExpanded,
                    onToggle: () {
                      setState(() {
                        controller.isAfterCleanExpanded = !controller.isAfterCleanExpanded;
                      });
                    },
                    images: controller.afterCleanImages,
                    onPickImage: () => controller.pickImageFromCamera(controller.afterCleanImages),
                    onRemoveImage: (index) => controller.removeImage(controller.afterCleanImages, index),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: Get.width * 0.95,
                      child: TextFormField(
                        controller: controller.locationController,
                        readOnly: true,
                        onTap: () {
                          controller.getCurrentLocation();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى تحديد الموقع';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: location.tr,
                          hintStyle: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: Get.width * 0.95,
                      child: TextFormField(
                        controller: controller.commentDamagedController,
                        decoration: InputDecoration(
                          hintText: damageComment.tr,
                          hintStyle: TextStyle(color: Colors.grey[700]),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: Get.width * 0.95,
                      child: TextFormField(
                        controller: controller.commentVisitedController,
                        decoration: InputDecoration(
                          hintText: visitedComment.tr,
                          hintStyle: TextStyle(color: Colors.grey[700]),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await controller.postImageBeforeAndAfter(
                              context, widget.footerId, widget.bankAtmId);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error: $e'),
                          ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(Get.width * 0.95, Get.height * 0.05),
                          backgroundColor: Color(0xffcfd1d0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25))),
                      child: Text(
                        send.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
