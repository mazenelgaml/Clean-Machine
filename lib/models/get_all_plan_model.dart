// To parse this JSON data, do
//
//     final getAllPlansModel = getAllPlansModelFromJson(jsonString);

import 'dart:convert';

List<GetAllPlansModel> getAllPlansModelFromJson(String str) => List<GetAllPlansModel>.from(json.decode(str).map((x) => GetAllPlansModel.fromJson(x)));

String getAllPlansModelToJson(List<GetAllPlansModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllPlansModel {
  DateTime startDate;
  DateTime endDate;
  int orderNumberFooter;
  int orderStatusId;
  String statusNameL1;
  String? atmserial;
  dynamic atmaddress;
  String? atmlocation;
  dynamic aspNetUsersId;
  dynamic imageUrl;
  String banknameL1;
  bool isNotActive;
  bool isDeleted;
  String footerId;
  String bankAtmid;

  GetAllPlansModel({
    required this.startDate,
    required this.endDate,
    required this.orderNumberFooter,
    required this.orderStatusId,
    required this.statusNameL1,
    required this.atmserial,
    required this.atmaddress,
    required this.atmlocation,
    required this.aspNetUsersId,
    required this.imageUrl,
    required this.banknameL1,
    required this.isNotActive,
    required this.isDeleted,
    required this.footerId,
    required this.bankAtmid,
  });

  factory GetAllPlansModel.fromJson(Map<String, dynamic> json) => GetAllPlansModel(
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    orderNumberFooter: json["orderNumberFooter"],
    orderStatusId: json["orderStatusId"],
    statusNameL1: json["statusNameL1"],
    atmserial: json["atmserial"],
    atmaddress: json["atmaddress"],
    atmlocation: json["atmlocation"],
    aspNetUsersId: json["aspNetUsersId"],
    imageUrl: json["imageUrl"],
    banknameL1: json["banknameL1"],
    isNotActive: json["isNotActive"],
    isDeleted: json["isDeleted"],
    footerId: json["footerId"],
    bankAtmid: json["bankAtmid"],
  );

  Map<String, dynamic> toJson() => {
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "orderNumberFooter": orderNumberFooter,
    "orderStatusId": orderStatusId,
    "statusNameL1": statusNameL1,
    "atmserial": atmserial,
    "atmaddress": atmaddress,
    "atmlocation": atmlocation,
    "aspNetUsersId": aspNetUsersId,
    "imageUrl": imageUrl,
    "banknameL1": banknameL1,
    "isNotActive": isNotActive,
    "isDeleted": isDeleted,
    "footerId": footerId,
    "bankAtmid": bankAtmid,
  };
}
