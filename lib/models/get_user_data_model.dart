// To parse this JSON data, do
//
//     final getUserDataModel = getUserDataModelFromJson(jsonString);

import 'dart:convert';

GetUserDataModel getUserDataModelFromJson(String str) => GetUserDataModel.fromJson(json.decode(str));

String getUserDataModelToJson(GetUserDataModel data) => json.encode(data.toJson());

class GetUserDataModel {
  String userId;
  String userName;
  String email;
  List<String> roles;
  String delegateNameL1;
  dynamic delegateNameL2;
  dynamic delegateMobil;
  DateTime startDate;
  DateTime endDate;
  dynamic delegateAddress;
  dynamic cityName;
  int numberOfNewOrders;
  int numberOfWaitingOrders;
  int numberOfAcceptOrders;
  int numberOfRejectOrders;
  int numberOfOrdersAcceptForOwner;
  int numberOfOrdersRejectForAdmin;

  GetUserDataModel({
    required this.userId,
    required this.userName,
    required this.email,
    required this.roles,
    required this.delegateNameL1,
    required this.delegateNameL2,
    required this.delegateMobil,
    required this.startDate,
    required this.endDate,
    required this.delegateAddress,
    required this.cityName,
    required this.numberOfNewOrders,
    required this.numberOfWaitingOrders,
    required this.numberOfAcceptOrders,
    required this.numberOfRejectOrders,
    required this.numberOfOrdersAcceptForOwner,
    required this.numberOfOrdersRejectForAdmin,
  });

  factory GetUserDataModel.fromJson(Map<String, dynamic> json) => GetUserDataModel(
    userId: json["userId"],
    userName: json["userName"],
    email: json["email"],
    roles: List<String>.from(json["roles"].map((x) => x)),
    delegateNameL1: json["delegateNameL1"],
    delegateNameL2: json["delegateNameL2"],
    delegateMobil: json["delegateMobil"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    delegateAddress: json["delegateAddress"],
    cityName: json["cityName"],
    numberOfNewOrders: json["numberOfNewOrders"],
    numberOfWaitingOrders: json["numberOfWaitingOrders"],
    numberOfAcceptOrders: json["numberOfAcceptOrders"],
    numberOfRejectOrders: json["numberOfRejectOrders"],
    numberOfOrdersAcceptForOwner: json["numberOfOrdersAcceptForOwner"],
    numberOfOrdersRejectForAdmin: json["numberOfOrdersRejectForAdmin"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "email": email,
    "roles": List<dynamic>.from(roles.map((x) => x)),
    "delegateNameL1": delegateNameL1,
    "delegateNameL2": delegateNameL2,
    "delegateMobil": delegateMobil,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "delegateAddress": delegateAddress,
    "cityName": cityName,
    "numberOfNewOrders": numberOfNewOrders,
    "numberOfWaitingOrders": numberOfWaitingOrders,
    "numberOfAcceptOrders": numberOfAcceptOrders,
    "numberOfRejectOrders": numberOfRejectOrders,
    "numberOfOrdersAcceptForOwner": numberOfOrdersAcceptForOwner,
    "numberOfOrdersRejectForAdmin": numberOfOrdersRejectForAdmin,
  };
}
