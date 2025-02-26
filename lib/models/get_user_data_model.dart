// To parse this JSON data, do
//
//     final getUserDataModel = getUserDataModelFromJson(jsonString);

import 'dart:convert';

GetUserDataModel getUserDataModelFromJson(String str) => GetUserDataModel.fromJson(json.decode(str));

String getUserDataModelToJson(GetUserDataModel data) => json.encode(data.toJson());

class GetUserDataModel {
  String? userId;
  String? userName;
  String? email;
  List<String>? roles;
  dynamic delegateNameL1;
  dynamic delegateNameL2;
  dynamic delegateMobil;
  dynamic startDate;
  dynamic endDate;
  dynamic delegateAddress;
  dynamic cityName;
  int? numberOfNewOrders;
  int? numberOfWaitingOrders;
  int? numberOfAcceptOrders;
  int? numberOfRejectOrders;
  int? numberOfOrdersAcceptForOwner;
  int? numberOfOrdersRejectForAdmin;

  GetUserDataModel({
    this.userId,
    this.userName,
    this.email,
    this.roles,
    this.delegateNameL1,
    this.delegateNameL2,
    this.delegateMobil,
    this.startDate,
    this.endDate,
    this.delegateAddress,
    this.cityName,
    this.numberOfNewOrders,
    this.numberOfWaitingOrders,
    this.numberOfAcceptOrders,
    this.numberOfRejectOrders,
    this.numberOfOrdersAcceptForOwner,
    this.numberOfOrdersRejectForAdmin,
  });

  factory GetUserDataModel.fromJson(Map<String, dynamic> json) => GetUserDataModel(
    userId: json["userId"],
    userName: json["userName"],
    email: json["email"],
    roles: json["roles"] == null ? [] : List<String>.from(json["roles"]!.map((x) => x)),
    delegateNameL1: json["delegateNameL1"],
    delegateNameL2: json["delegateNameL2"],
    delegateMobil: json["delegateMobil"],
    startDate: json["startDate"],
    endDate: json["endDate"],
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
    "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x)),
    "delegateNameL1": delegateNameL1,
    "delegateNameL2": delegateNameL2,
    "delegateMobil": delegateMobil,
    "startDate": startDate,
    "endDate": endDate,
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
