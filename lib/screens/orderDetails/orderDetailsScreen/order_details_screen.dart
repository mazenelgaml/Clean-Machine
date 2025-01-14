import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: Get.width * 0.9,
              height: _isExpanded ? 250 : 50,
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Before Clean',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Icon(
                            _isExpanded
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // تظهر أيقونة الكاميرا في المنتصف فقط عند التوسيع
                    if (_isExpanded)
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            print("تحديد صورة");
                          },
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () {
                              print("فتح الكاميرا");
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Location TextFormField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: Get.width * 0.9,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Location',
                  hintStyle: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
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

          // Comment Damaged TextFormField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: Get.width * 0.9,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Comment Damaged',
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.5),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                ),
              ),
            ),
          ),

          // Comment Visited TextFormField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: Get.width * 0.9,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Comment Visited',
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.5),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
