// To parse this JSON data, do
//
//     final getTdsTransactionModel = getTdsTransactionModelFromJson(jsonString);

import 'dart:convert';

GetTdsTransactionModel getTdsTransactionModelFromJson(String str) => GetTdsTransactionModel.fromJson(json.decode(str));

String getTdsTransactionModelToJson(GetTdsTransactionModel data) => json.encode(data.toJson());

class GetTdsTransactionModel {
  final bool? success;
  final TdsTransactionDataModel? data;

  GetTdsTransactionModel({
    this.success,
    this.data,
  });

  factory GetTdsTransactionModel.fromJson(Map<String, dynamic> json) => GetTdsTransactionModel(
    success: json["success"],
    data: json["data"] == null ? null : TdsTransactionDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class TdsTransactionDataModel {
  final List<TdsTransactionModel>? results;
  final int? totalResults;
  final int? page;
  final int? limit;
  final int? totalPages;

  TdsTransactionDataModel({
    this.results,
    this.totalResults,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory TdsTransactionDataModel.fromJson(Map<String, dynamic> json) => TdsTransactionDataModel(
    results: json["results"] == null ? [] : List<TdsTransactionModel>.from(json["results"]!.map((x) => TdsTransactionModel.fromJson(x))),
    totalResults: json["totalResults"],
    page: json["page"],
    limit: json["limit"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
    "totalResults": totalResults,
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
  };
}

class TdsTransactionModel {
  final String? id;
  final String? payout;
  final String? user;
  final DateTime? createdAt;
  final double? payoutAmount;
  final double? tdsAmount;
  final double? tdsDeduct;
  final double? tdsPercentage;

  TdsTransactionModel({
    this.id,
    this.payout,
    this.user,
    this.createdAt,
    this.payoutAmount,
    this.tdsAmount,
    this.tdsDeduct,
    this.tdsPercentage,
  });

  factory TdsTransactionModel.fromJson(Map<String, dynamic> json) => TdsTransactionModel(
    id: json["_id"],
    payout: json["payout"],
    user: json["user"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    payoutAmount: json["payoutAmount"]?.toDouble(),
    tdsAmount: json["tdsAmount"]?.toDouble(),
    tdsDeduct: json["tdsDeduct"]?.toDouble(),
    tdsPercentage: json["tds_percentage"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "payout": payout,
    "user": user,
    "createdAt": createdAt?.toIso8601String(),
    "payoutAmount": payoutAmount,
    "tdsAmount": tdsAmount,
    "tdsDeduct": tdsDeduct,
    "tds_percentage": tdsPercentage,
  };
}
