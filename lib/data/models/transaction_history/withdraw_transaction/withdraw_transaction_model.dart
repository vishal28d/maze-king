// To parse this JSON data, do
//
//     final getWithdrawTransactionModel = getWithdrawTransactionModelFromJson(jsonString);

import 'dart:convert';

GetWithdrawTransactionModel getWithdrawTransactionModelFromJson(String str) => GetWithdrawTransactionModel.fromJson(json.decode(str));

String getWithdrawTransactionModelToJson(GetWithdrawTransactionModel data) => json.encode(data.toJson());

class GetWithdrawTransactionModel {
  final bool? success;
  final String? message;
  final WithdrawTransactionModel? withdrawTransactionModel;

  GetWithdrawTransactionModel({
    this.success,
    this.message,
    this.withdrawTransactionModel,
  });

  factory GetWithdrawTransactionModel.fromJson(Map<String, dynamic> json) => GetWithdrawTransactionModel(
        success: json["success"],
        message: json["message"],
        withdrawTransactionModel: json["data"] == null ? null : WithdrawTransactionModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": withdrawTransactionModel?.toJson(),
      };
}

class WithdrawTransactionModel {
  final List<WithdrawalTransactionModel>? results;
  final int? totalResults;
  final int? page;
  final int? limit;
  final int? totalPages;

  WithdrawTransactionModel({
    this.results,
    this.totalResults,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory WithdrawTransactionModel.fromJson(Map<String, dynamic> json) => WithdrawTransactionModel(
        results: json["results"] == null ? [] : List<WithdrawalTransactionModel>.from(json["results"]!.map((x) => WithdrawalTransactionModel.fromJson(x))),
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

class WithdrawalTransactionModel {
  final String? id;
  final DateTime? createdAt;
  final num? amount;
  final num? withdraw;
  final num? fee;
  final num? tax;
  final String? currency;
  final String? status;
  final num? tdsAmount;
  final num? tdsPercentage;

  WithdrawalTransactionModel({
    this.id,
    this.createdAt,
    this.amount,
    this.withdraw,
    this.fee,
    this.tax,
    this.currency,
    this.status,
    this.tdsAmount,
    this.tdsPercentage,
  });

  factory WithdrawalTransactionModel.fromJson(Map<String, dynamic> json) => WithdrawalTransactionModel(
        id: json["_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        amount: json["amount"],
        withdraw: json["withdraw"],
        fee: json["fee"],
        tax: json["tax"],
        currency: json["currency"],
        status: json["status"],
        tdsAmount: json["tds"],
        tdsPercentage: json["tds_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "createdAt": createdAt?.toIso8601String(),
        "amount": amount,
        "withdraw": withdraw,
        "fee": fee,
        "tax": tax,
        "currency": currency,
        "status": status,
        "tds": tdsAmount,
        "tds_percentage": tdsPercentage,
      };
}
