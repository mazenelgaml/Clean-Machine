import 'dart:convert';

List<GetAllPlansModel> getAllPlansModelFromJson(String str) =>
    List<GetAllPlansModel>.from(
        json.decode(str).map((x) => GetAllPlansModel.fromJson(x)));

String getAllPlansModelToJson(List<GetAllPlansModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllPlansModel {
  String footerId;
  String bankname;
  String? bankImage;
  DateTime? detailsDate;
  DateTime startDate;
  DateTime endDate;
  String workPlanHeaderIdId;
  int representativeId;
  String userName;
  String representativeImage;
  int orderStatusId;
  String orderStatusName;
  String dataAtmId;
  String atmCode;
  String atmmodel;
  String atmserial;
  DateTime createDateTime;
  String atmAdress;
  String atmLocation;
  String atmlat;
  String atmlong;
  String atmCity;
  int orderNumberFooter;
  int orderNumberHeader;

  GetAllPlansModel({
    required this.footerId,
    required this.bankname,
    required this.bankImage,
    required this.detailsDate,
    required this.startDate,
    required this.endDate,
    required this.workPlanHeaderIdId,
    required this.representativeId,
    required this.userName,
    required this.representativeImage,
    required this.orderStatusId,
    required this.orderStatusName,
    required this.dataAtmId,
    required this.atmCode,
    required this.atmmodel,
    required this.atmserial,
    required this.createDateTime,
    required this.atmAdress,
    required this.atmLocation,
    required this.atmlat,
    required this.atmlong,
    required this.atmCity,
    required this.orderNumberFooter,
    required this.orderNumberHeader,
  });

  factory GetAllPlansModel.fromJson(Map<String, dynamic> json) =>
      GetAllPlansModel(
        footerId: json["footerId"],
        bankname: json["_bankname"],
        bankImage: json["_bankImage"],
        detailsDate: json["detailsDate"] == null
            ? null
            : DateTime.parse(json["detailsDate"]),
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        workPlanHeaderIdId: json["workPlanHeaderIdId"],
        representativeId: json["representativeId"],
        userName: json["userName"],
        representativeImage: json["representativeImage"],
        orderStatusId: json["orderStatusId"],
        orderStatusName: json["orderStatusName"],
        dataAtmId: json["dataAtmId"],
        atmCode: json["atmCode"],
        atmmodel: json["atmmodel"],
        atmserial: json["atmserial"],
        createDateTime: DateTime.parse(json["createDateTime"]),
        atmAdress: json["atmAdress"],
        atmLocation: json["atmLocation"],
        atmlat: json["atmlat"],
        atmlong: json["atmlong"],
        atmCity: json["atmCity"],
        orderNumberFooter: json["orderNumberFooter"],
        orderNumberHeader: json["orderNumberHeader"],
      );

  Map<String, dynamic> toJson() => {
    "footerId": footerId,
    "_bankname": bankname,
    "_bankImage": bankImage,
    "detailsDate": detailsDate?.toIso8601String(),
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "workPlanHeaderIdId": workPlanHeaderIdId,
    "representativeId": representativeId,
    "userName": userName,
    "representativeImage": representativeImage,
    "orderStatusId": orderStatusId,
    "orderStatusName": orderStatusName,
    "dataAtmId": dataAtmId,
    "atmCode": atmCode,
    "atmmodel": atmmodel,
    "atmserial": atmserial,
    "createDateTime": createDateTime.toIso8601String(),
    "atmAdress": atmAdress,
    "atmLocation": atmLocation,
    "atmlat": atmlat,
    "atmlong": atmlong,
    "atmCity": atmCity,
    "orderNumberFooter": orderNumberFooter,
    "orderNumberHeader": orderNumberHeader,
  };
}
