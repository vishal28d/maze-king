// To parse this JSON data, do
//
//     final getWinningBoardDataModel = getWinningBoardDataModelFromJson(jsonString);

import 'dart:convert';

GetWinningBoardDataModel getWinningBoardDataModelFromJson(String str) => GetWinningBoardDataModel.fromJson(json.decode(str));

String getWinningBoardDataModelToJson(GetWinningBoardDataModel data) => json.encode(data.toJson());

class GetWinningBoardDataModel {
  bool? success;
  Data? data;

  GetWinningBoardDataModel({
    this.success,
    this.data,
  });

  factory GetWinningBoardDataModel.fromJson(Map<String, dynamic> json) => GetWinningBoardDataModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class Data {
  List<Map<String, int>>? ranking;
  double? availableDistributionAmount;
  double? totalUserDistributionPercentage;

  Data({
    this.ranking,
    this.availableDistributionAmount,
    this.totalUserDistributionPercentage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ranking: json["ranking"] == null ? [] : List<Map<String, int>>.from(json["ranking"]!.map((x) => Map.from(x).map((k, v) => MapEntry<String, int>(k, v)))),
        availableDistributionAmount: json["availableDistributionAmount"]?.toDouble(),
        totalUserDistributionPercentage: json["totalUserDistributionPercentage"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "ranking": ranking == null ? [] : List<dynamic>.from(ranking!.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
        "availableDistributionAmount": availableDistributionAmount,
        "totalUserDistributionPercentage": totalUserDistributionPercentage,
      };
}
