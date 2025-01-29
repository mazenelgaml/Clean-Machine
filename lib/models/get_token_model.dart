// To parse this JSON data, do
//
//     final getTokenModel = getTokenModelFromJson(jsonString);

import 'dart:convert';

GetTokenModel getTokenModelFromJson(String str) => GetTokenModel.fromJson(json.decode(str));

String getTokenModelToJson(GetTokenModel data) => json.encode(data.toJson());

class GetTokenModel {
  String token;

  GetTokenModel({
    required this.token,
  });

  factory GetTokenModel.fromJson(Map<String, dynamic> json) => GetTokenModel(
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
  };
}
