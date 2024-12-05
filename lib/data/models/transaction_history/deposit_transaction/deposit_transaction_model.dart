// To parse this JSON data, do
//
//     final getDepositTransactionModel = getDepositTransactionModelFromJson(jsonString);

import 'dart:convert';

GetDepositTransactionModel getDepositTransactionModelFromJson(String str) => GetDepositTransactionModel.fromJson(json.decode(str));

String getDepositTransactionModelToJson(GetDepositTransactionModel data) => json.encode(data.toJson());

class GetDepositTransactionModel {
  final bool? success;
  final String? message;
  final DepositTransactionModel? depositTransactionModel;

  GetDepositTransactionModel({
    this.success,
    this.message,
    this.depositTransactionModel,
  });

  factory GetDepositTransactionModel.fromJson(Map<String, dynamic> json) => GetDepositTransactionModel(
        success: json["success"],
        message: json["message"],
        depositTransactionModel: json["depositTransactionModel"] == null ? null : DepositTransactionModel.fromJson(json["depositTransactionModel"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": depositTransactionModel?.toJson(),
      };
}

class DepositTransactionModel {
  final List<Result>? results;
  final int? totalResults;
  final int? page;
  final int? limit;
  final int? totalPages;

  DepositTransactionModel({
    this.results,
    this.totalResults,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory DepositTransactionModel.fromJson(Map<String, dynamic> json) => DepositTransactionModel(
        results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
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

/*class Result {
  final String? id;
  final DateTime? createdAt;
  final num? amount;
  final num? fee;
  final num? tax;
  final String? currency;
  final String? status;
  final String? type;

  Result({
    this.id,
    this.createdAt,
    this.amount,
    this.fee,
    this.tax,
    this.currency,
    this.status,
    this.type,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["_id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        amount: json["amount"],
        fee: json["fee"],
        tax: json["tax"],
        currency: json["currency"],
        status: json["status"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "createdAt": createdAt?.toIso8601String(),
        "amount": amount,
        "fee": fee,
        "tax": tax,
        "currency": currency,
        "status": status,
        "type": type,
      };
}*/

class Result {
  final String? id;
  final Info? info;
  final String? user;
  final int? amount;
  final DateTime? createdAt;
  final int? withdraw;

  Result({
    this.id,
    this.info,
    this.user,
    this.amount,
    this.createdAt,
    this.withdraw,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["_id"],
    info: json["info"] == null ? null : Info.fromJson(json["info"]),
    user: json["user"],
    amount: json["amount"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    withdraw: json["withdraw"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "info": info?.toJson(),
    "user": user,
    "amount": amount,
    "createdAt": createdAt?.toIso8601String(),
    "withdraw": withdraw,
  };
}

class Info {
  final String? productId;
  final String? bankTransactionId;
  final String? externalOrderId;
  final String? utr;
  final String? transactionId;
  final String? paymentStatus;
  final num? amount;

  Info({
    this.productId,
    this.bankTransactionId,
    this.externalOrderId,
    this.utr,
    this.transactionId,
    this.paymentStatus,
    this.amount,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    productId: json["product_id"],
    bankTransactionId: json["bank_transaction_id"],
    externalOrderId: json["external_order_id"],
    utr: json["utr"],
    transactionId: json["transaction_id"],
    paymentStatus: json["payment_status"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "bank_transaction_id": bankTransactionId,
    "external_order_id": externalOrderId,
    "utr": utr,
    "transaction_id": transactionId,
    "payment_status": paymentStatus,
    "amount": amount,
  };
}
