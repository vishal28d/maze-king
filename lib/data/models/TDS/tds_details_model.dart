// To parse this JSON data, do
//
//     final getTdsDetailsModel = getTdsDetailsModelFromJson(jsonString);

import 'dart:convert';

GetTdsDetailsModel getTdsDetailsModelFromJson(String str) => GetTdsDetailsModel.fromJson(json.decode(str));

String getTdsDetailsModelToJson(GetTdsDetailsModel data) => json.encode(data.toJson());

class GetTdsDetailsModel {
  final bool? success;
  final TdsTransactionModel? data;

  GetTdsDetailsModel({
    this.success,
    this.data,
  });

  factory GetTdsDetailsModel.fromJson(Map<String, dynamic> json) => GetTdsDetailsModel(
        success: json["success"],
        data: json["data"] == null ? null : TdsTransactionModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class TdsTransactionModel {
  final num? withdraw;
  final num? payoutAmount;
  final num? payoutAmountPoint;
  final num? tdsDeduct;
  final num? tdsAmount;
  final num? availableUnUtilized;
  final num? tdsPercentage;

  TdsTransactionModel({
    this.withdraw,
    this.payoutAmount,
    this.payoutAmountPoint,
    this.tdsDeduct,
    this.tdsAmount,
    this.availableUnUtilized,
    this.tdsPercentage,
  });

  factory TdsTransactionModel.fromJson(Map<String, dynamic> json) => TdsTransactionModel(
        withdraw: json["withdraw"],
        payoutAmount: json["payoutAmount"],
        payoutAmountPoint: json["payoutAmountWithoutPoint"],
        tdsDeduct: json["tdsDeduct"],
        tdsAmount: json["tdsAmount"],
        availableUnUtilized: json["available_un_utilized"],
        tdsPercentage: json["tds_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "withdraw": withdraw,
        "payoutAmount": payoutAmount,
        "payoutAmountWithoutPoint": payoutAmountPoint,
        "tdsDeduct": tdsDeduct,
        "tdsAmount": tdsAmount,
        "available_un_utilized": availableUnUtilized,
        "tds_percentage": tdsPercentage,
      };
}
