import 'dart:io';
import 'package:clean_machine/services/end_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as diio;
import 'package:cool_alert/cool_alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../services/memory.dart';

class OrderDetailsController extends GetxController {
  List<File> beforeCleanImages = [];
  List<File> afterCleanImages = [];
  bool isBeforeCleanExpanded = false;
  bool isAfterCleanExpanded = false;

  final ImagePicker picker = ImagePicker();
  bool isLoading = false;

  final String footerId;
  final String bankAtmId;

  OrderDetailsController({required this.footerId, required this.bankAtmId});

  TextEditingController locationController = TextEditingController();
  TextEditingController commentDamagedController = TextEditingController();
  TextEditingController commentVisitedController = TextEditingController();

  double latitude = 0;
  double longitude = 0;

  @override
  Future<void> onInit() async {
    super.onInit();
    await initializeHive();;
    await checkLocationPermission();
    await getCurrentLocation();
    await loadSavedData();
  }

  @override
  void onClose() {
    Hive.close();
    super.onClose();
  }

  // Initialize Hive for local storage
  Future<void> initializeHive() async {
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);
    print("Hive initialized at ${appDir.path}");
    await Hive.openBox('offline_data');
  }

  // Load saved data from Hive
  Future<void> loadSavedData() async {
    print("dd");
    var box = await Hive.openBox('offline_data');
    var savedData = box.values.where((data) => data["footerId"] == footerId).toList();
    print(savedData);
    if (savedData.isNotEmpty) {
      var data = savedData.last;

      // Restore location
      locationController.text = data["location"];

      // Restore comments
      commentVisitedController.text = data["comment"];
      commentDamagedController.text = data["commentDamag"];

      // Restore images (convert paths back to File objects)
      beforeCleanImages = (data["imageBefor"] as List<String>).map((path) => File(path)).toList();
      afterCleanImages = (data["imageAfter"] as List<String>).map((path) => File(path)).toList();

      update();
    }
  }

  // Check location permission
  Future<void> checkLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      var result = await Permission.location.request();
      if (!result.isGranted) {
        Get.snackbar("Permission Denied", "Location permission is required.");
      }
    }
  }

  // Get current location
  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text("Please enable location services.")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(content: Text("Location permission denied.")),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text("Location permission permanently denied.")),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude = position.latitude;
      longitude = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      Placemark place = placemarks.first;
      locationController.text = "${place.street}, ${place.locality}, ${place.country}";
      update();
    } catch (e) {
      print("Error getting location: $e");
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text("Failed to get location.")),
      );
    }
  }

  // Pick image from camera
  Future<void> pickImageFromCamera(List<File> targetList) async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        targetList.add(File(pickedFile.path));
        update();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Remove image from list
  void removeImage(List<File> targetList, int index) {
    if (index >= 0 && index < targetList.length) {
      targetList.removeAt(index);
      update();
    }
  }
  Future<void> clearSavedData(String footerId) async {
    var box = await Hive.openBox('offline_data');

    // طباعة البيانات الحالية لتأكيد الفهم
    print("All data in offline_data box before deletion: ${box.toMap()}");

    // البحث عن المفاتيح المرتبطة بـ footerId
    var keysToDelete = box.keys.where((key) {
      var data = box.get(key);
      // تأكد من وجود footerId وتطابقه
      return data != null && data["footerId"] == footerId;
    }).toList();

    // طباعة المفاتيح اللي هتتحذف
    print("Keys to delete for footerId $footerId: $keysToDelete");

    // حذف كل المفاتيح
    for (var key in keysToDelete) {
      await box.delete(key);
    }

    // طباعة البيانات بعد الحذف
    print("All data in offline_data box after deletion: ${box.toMap()}");

    print("Deleted all saved data for footerId: $footerId.");
  }



  // Post comment
  Future<void> postComment(BuildContext context,String footerId) async {
    final diio.Dio dio = diio.Dio(
      diio.BaseOptions(
        baseUrl: EndPoint.baseUrl,
        validateStatus: (status) => status != null && status < 500,
      ),
    );



    try {
      final response = await dio.post(
        "/api/Reports/CreateWorkPlanComment",
        data: {
          "workPlanFooterId": footerId,
          "comment": commentVisitedController.text.trim(),
          "commentDamag": commentDamagedController.text.trim(),
        },
        options: diio.Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          title: "Submitted",
          text: "Order details submitted successfully.",
          onConfirmBtnTap: (){
            beforeCleanImages=[];
            afterCleanImages=[];
            locationController.clear();
            commentVisitedController.clear();
            commentDamagedController.clear();
          }
        );
        await clearSavedData(footerId);
        Get.delete<OrderDetailsController>();
      } else {
        print("Error: ${response.data}");
      }
    } catch (e) {
      print("Error posting comment: $e");
    } finally {
      isLoading = false;
      update();
    }
  }
  Future<File> compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf('.');
    final newPath = filePath.substring(0, lastIndex) + '_compressed.jpg';

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      filePath, newPath,
      quality: 70, // نسبة الضغط (كلما قلت زادت الجودة)
    );

    return File(compressedFile!.path);
  }
  // Save data locally in Hive
  Future<void> _saveDataLocally({
    required List<File> beforeImages,
    required List<File> afterImages,
    required String location,
    required double longitude,
    required double latitude,
  }) async {
    var box = await Hive.openBox('offline_data');
    await box.add({
      "footerId": footerId,
      "bankAtmId": bankAtmId,
      "imageBefor": beforeImages.map((file) => file.path).toList(),
      "imageAfter": afterImages.map((file) => file.path).toList(),
      "location": location,
      "ATMLong": longitude,
      "ATMLat": latitude,
      "comment": commentVisitedController.text.trim(),
      "commentDamag": commentDamagedController.text.trim(),
      "CreateDateTime": DateTime.now().toIso8601String(),
    });
    print("Data saved locally for footerId: $footerId.");
  }

  // Sync data when online
  Future<void> syncDataWhenOnline() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.last == ConnectivityResult.none) {
      final box = Hive.box('offline_data');
      final dataList = box.values.where((data) => data["footerId"] == footerId).toList();

      if (dataList.isNotEmpty) {
        final data = dataList.last;

        await postImageBeforeAndAfter(
          Get.context!,
          data["footerId"],
          data["bankAtmId"],
        );

        // After syncing, clear the data from Hive
        await box.clear();
        print("Offline data synced and removed.");
      }
    } else {
      print('No internet connection. Data saved locally.');
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('No internet connection. Data saved locally.')),
      );
    }
  }

  // Post images before and after cleaning
  Future<void> postImageBeforeAndAfter(BuildContext context, String footerId, String bankAtmId) async {
    isLoading=true;
    update();
    String id = await Get.find<CacheHelper>().getData(key: "id");
    final dio = diio.Dio(
      diio.BaseOptions(
        baseUrl: EndPoint.baseUrl,
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    isLoading = true;
    update();

    try {
      List<diio.MultipartFile> beforeImages = await Future.wait(
        beforeCleanImages.map((file) async {
          File compressedFile = await compressImage(file);
          String fileName = basename(compressedFile.path);
          return await diio.MultipartFile.fromFile(compressedFile.path, filename: fileName);
        }),
      );

      List<diio.MultipartFile> afterImages = await Future.wait(
        afterCleanImages.map((file) async {
          File compressedFile = await compressImage(file);
          String fileName = basename(compressedFile.path);
          return await diio.MultipartFile.fromFile(compressedFile.path, filename: fileName);
        }),
      );

      var connectivityResult = await Connectivity().checkConnectivity();
      print(connectivityResult);
      print(connectivityResult);
      if (connectivityResult.last == ConnectivityResult.none) {
        print("mazen mazen");
        await _saveDataLocally(
          beforeImages: beforeCleanImages,
          afterImages: afterCleanImages,
          location: locationController.text.trim(),
          longitude: longitude,
          latitude: latitude,
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No internet connection. Data saved locally.'),
        ));
        return;
      }

      diio.FormData formData = diio.FormData.fromMap({
        "workPlanFooterId": footerId,
        "CreateUserId": id,
        "IsBefore": true,
        "CreateDateTime": DateTime.now().toIso8601String(),
        "BankATMId": bankAtmId,
        "ATMLocation": locationController.text.trim(),
        "ATMLong": "$longitude",
        "ATMLat": "$latitude",
        "imageBefor": beforeImages,
        "imageAfter": afterImages,
      });

      diio.Response response = await dio.post(
        "/api/Reports/CreateWorkPlanDetails",
        data: formData,
        options: diio.Options(headers: {
          "Content-Type": "multipart/form-data",
        }),
      );

      if (response.statusCode == 200) {
        await postComment(context, footerId);
      } else {
        print("Error: ${response.data}");
      }
    } catch (e) {
      print("Error syncing data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error syncing data. Please try again later.')),
      );
    } finally {

    }
  }
}
