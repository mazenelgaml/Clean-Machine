// To parse this JSON data, do
//
//     final getUserDataModel = getUserDataModelFromJson(jsonString);

import 'dart:convert';

GetUserDataModel getUserDataModelFromJson(String str) => GetUserDataModel.fromJson(json.decode(str));

String getUserDataModelToJson(GetUserDataModel data) => json.encode(data.toJson());

class GetUserDataModel {
  UserData userData;
  UsrStatistic usrStatistic;

  GetUserDataModel({
    required this.userData,
    required this.usrStatistic,
  });

  factory GetUserDataModel.fromJson(Map<String, dynamic> json) => GetUserDataModel(
    userData: UserData.fromJson(json["userData"]),
    usrStatistic: UsrStatistic.fromJson(json["usrStatistic"]),
  );

  Map<String, dynamic> toJson() => {
    "userData": userData.toJson(),
    "usrStatistic": usrStatistic.toJson(),
  };
}

class UserData {
  int id;
  String userBarCode;
  String companyDataId;
  String userName;
  int cityCodeId;
  String userAddress;
  String userNationalId;
  String userWhatsapp;
  String email;
  String phoneNumber;
  DateTime dateStart;
  DateTime dateFinsh;
  String description;
  String imageUrl;
  String createUserId;

  UserData({
    required this.id,
    required this.userBarCode,
    required this.companyDataId,
    required this.userName,
    required this.cityCodeId,
    required this.userAddress,
    required this.userNationalId,
    required this.userWhatsapp,
    required this.email,
    required this.phoneNumber,
    required this.dateStart,
    required this.dateFinsh,
    required this.description,
    required this.imageUrl,
    required this.createUserId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    userBarCode: json["userBarCode"],
    companyDataId: json["companyDataId"],
    userName: json["userName"],
    cityCodeId: json["cityCodeId"],
    userAddress: json["userAddress"],
    userNationalId: json["userNationalId"],
    userWhatsapp: json["userWhatsapp"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    dateStart: DateTime.parse(json["dateStart"]),
    dateFinsh: DateTime.parse(json["dateFinsh"]),
    description: json["description"],
    imageUrl: json["imageUrl"],
    createUserId: json["createUserId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userBarCode": userBarCode,
    "companyDataId": companyDataId,
    "userName": userName,
    "cityCodeId": cityCodeId,
    "userAddress": userAddress,
    "userNationalId": userNationalId,
    "userWhatsapp": userWhatsapp,
    "email": email,
    "phoneNumber": phoneNumber,
    "dateStart": dateStart.toIso8601String(),
    "dateFinsh": dateFinsh.toIso8601String(),
    "description": description,
    "imageUrl": imageUrl,
    "createUserId": createUserId,
  };
}

class UsrStatistic {
  int userId;
  int numberOfNewOrders;
  int numberOfWaitingOrders;
  int numberOfAcceptOrders;
  int numberOfRejectOrders;
  int numberOfOrdersAcceptForOwner;
  int numberOfOrdersRejectForAdmin;

  UsrStatistic({
    required this.userId,
    required this.numberOfNewOrders,
    required this.numberOfWaitingOrders,
    required this.numberOfAcceptOrders,
    required this.numberOfRejectOrders,
    required this.numberOfOrdersAcceptForOwner,
    required this.numberOfOrdersRejectForAdmin,
  });

  factory UsrStatistic.fromJson(Map<String, dynamic> json) => UsrStatistic(
    userId: json["userId"],
    numberOfNewOrders: json["numberOfNewOrders"],
    numberOfWaitingOrders: json["numberOfWaitingOrders"],
    numberOfAcceptOrders: json["numberOfAcceptOrders"],
    numberOfRejectOrders: json["numberOfRejectOrders"],
    numberOfOrdersAcceptForOwner: json["numberOfOrdersAcceptForOwner"],
    numberOfOrdersRejectForAdmin: json["numberOfOrdersRejectForAdmin"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "numberOfNewOrders": numberOfNewOrders,
    "numberOfWaitingOrders": numberOfWaitingOrders,
    "numberOfAcceptOrders": numberOfAcceptOrders,
    "numberOfRejectOrders": numberOfRejectOrders,
    "numberOfOrdersAcceptForOwner": numberOfOrdersAcceptForOwner,
    "numberOfOrdersRejectForAdmin": numberOfOrdersRejectForAdmin,
  };
}
