import 'dart:io';
import 'package:clean_machine/screens/home/controller/home_controller.dart';
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
import '../../home/home_screen/home_screen.dart';

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
    await initializeHive();
    await checkPermissions();
    await checkLocationPermission();
    await getCurrentLocation();
    await loadSavedData();
  }

  @override
  void onClose() {
    Hive.close();
    super.onClose();
  }

  Future<void> initializeHive() async {
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);
    await Hive.openBox('offline_data');
  }

  Future<void> loadSavedData() async {
    var box = await Hive.openBox('offline_data');
    var savedData = box.values.where((data) => data["footerId"] == footerId).toList();
    if (savedData.isNotEmpty) {
      var data = savedData.last;
      locationController.text = data["location"];
      commentVisitedController.text = data["comment"];
      commentDamagedController.text = data["commentDamag"];
      beforeCleanImages = (data["imageBefor"] as List<String>).map((path) => File(path)).toList();
      afterCleanImages = (data["imageAfter"] as List<String>).map((path) => File(path)).toList();
      update();
    }
  }

  Future<void> checkLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      var result = await Permission.location.request();
      if (!result.isGranted) {
        Get.snackbar("Permission Denied", "Location permission is required.");
      }
    }
  }

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

      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks.first;
      locationController.text = "${place.street}, ${place.locality}, ${place.country}";
      update();
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text("Failed to get location.")),
      );
    }
  }

  Future<File> compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf('.');
    final newPath = filePath.substring(0, lastIndex) + '_compressed.jpg';

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      filePath,
      newPath,
      quality: 70,
    );

    return File(compressedFile!.path);
  }

  Future<void> checkPermissions() async {
    // Request permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
      Permission.storage,
    ].request();

    // Handle location permission
    if (statuses[Permission.location] == PermissionStatus.denied ||
        statuses[Permission.location] == PermissionStatus.permanentlyDenied) {
      Get.snackbar("Location Permission", "Location access is required.");
    }

    // Handle camera permission
    if (statuses[Permission.camera] == PermissionStatus.denied ||
        statuses[Permission.camera] == PermissionStatus.permanentlyDenied) {
      Get.snackbar("Camera Permission", "Camera access is required to take pictures.");
    }

    // Handle storage permission
    if (statuses[Permission.storage] == PermissionStatus.denied ||
        statuses[Permission.storage] == PermissionStatus.permanentlyDenied) {
      Get.snackbar("Storage Permission", "Storage access is required to save images.");
    }

    // If any permission is permanently denied, prompt to go to settings
    if (statuses.values.any((status) => status == PermissionStatus.permanentlyDenied)) {
      await Future.delayed(const Duration(seconds: 1));
      Get.defaultDialog(
        title: "Permission Required",
        middleText: "Some permissions are permanently denied. Please enable them from app settings.",
        textConfirm: "Open Settings",
        textCancel: "Cancel",
        confirmTextColor: Colors.white,
        onConfirm: () {
          openAppSettings();
          Get.back();
        },
      );
    }
  }

  // Change this method to allow taking a photo using the camera.
  Future<void> pickImageFromCamera(List<File> targetList) async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        File originalFile = File(pickedFile.path);
        File compressed = await compressImage(originalFile);
        targetList.add(compressed);
        update();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Image captured and compressed successfully!')),
        );
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('No image captured.')),
        );
      }
    } catch (e) {
      print('Error capturing/compressing image: $e');
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }


  void removeImage(List<File> targetList, int index) {
    if (index >= 0 && index < targetList.length) {
      targetList.removeAt(index);
      update();
    }
  }

  Future<void> clearSavedData(String footerId) async {
    var box = await Hive.openBox('offline_data');
    var keysToDelete = box.keys.where((key) {
      var data = box.get(key);
      return data != null && data["footerId"] == footerId;
    }).toList();

    for (var key in keysToDelete) {
      await box.delete(key);
    }
  }

  Future<void> postComment(BuildContext context, String footerId) async {
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
        beforeCleanImages.clear();
        afterCleanImages.clear();
        locationController.clear();
        commentVisitedController.clear();
        commentDamagedController.clear();
        await clearSavedData(footerId);
        Get.delete<OrderDetailsController>();
        Get.offAll(() => HomeScreen(initialTabIndex: 1));
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          title: "Submitted",
          text: "Order details submitted successfully.",
        );
        HomeController c =HomeController();
        c.getUserPlan();
        c.getUserReject();
        c.getUserWaiting();
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
  }
  // Future<bool> hasInternetConnection() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  //   } catch (_) {
  //     return false;
  //   }
  // }

  Future<void> syncDataWhenOnline() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.last != ConnectivityResult.none) {
      final box = Hive.box('offline_data');
      final dataList = box.values.where((data) => data["footerId"] == footerId).toList();

      if (dataList.isNotEmpty) {
        final data = dataList.last;
        await postImageBeforeAndAfter(
          Get.context!,
          data["footerId"],
          data["bankAtmId"],
        );
        await box.clear();
      }
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('No internet connection. Data saved locally.')),
      );
    }
  }

  Future<void> postImageBeforeAndAfter(BuildContext context, String footerId, String bankAtmId) async {
    isLoading = true;
    update();

    String id = await Get.find<CacheHelper>().getData(key: "id");

    final dio = diio.Dio(
      diio.BaseOptions(
        baseUrl: EndPoint.baseUrl,
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    try {
      List<diio.MultipartFile> beforeImages = await Future.wait(
        beforeCleanImages.map((file) async {
          File compressedFile = await compressImage(file);
          return await diio.MultipartFile.fromFile(compressedFile.path, filename: basename(compressedFile.path));
        }),
      );

      List<diio.MultipartFile> afterImages = await Future.wait(
        afterCleanImages.map((file) async {
          File compressedFile = await compressImage(file);
          return await diio.MultipartFile.fromFile(compressedFile.path, filename: basename(compressedFile.path));
        }),
      );

      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.last == ConnectivityResult.none) {
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
      isLoading = false;
      update();
    }
  }

  HomeController controller = HomeController();
}
