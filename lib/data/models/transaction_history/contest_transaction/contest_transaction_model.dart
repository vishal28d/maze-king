// To parse this JSON data, do
//
//     final getContestTransactionModel = getContestTransactionModelFromJson(jsonString);

import 'dart:convert';

GetContestTransactionModel getContestTransactionModelFromJson(String str) => GetContestTransactionModel.fromJson(json.decode(str));

String getContestTransactionModelToJson(GetContestTransactionModel data) => json.encode(data.toJson());

class GetContestTransactionModel {
  final bool? success;
  final String? message;
  final ContestTransactionDataModel? contestTransactionModel;

  GetContestTransactionModel({
    this.success,
    this.message,
    this.contestTransactionModel,
  });

  factory GetContestTransactionModel.fromJson(Map<String, dynamic> json) => GetContestTransactionModel(
        success: json["success"],
        message: json["message"],
        contestTransactionModel: json["contestTransactionModel"] == null ? null : ContestTransactionDataModel.fromJson(json["contestTransactionModel"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": contestTransactionModel?.toJson(),
      };
}

class ContestTransactionDataModel {
  final List<ContestTransactionModel>? results;
  final int? totalResults;
  final int? page;
  final int? limit;
  final int? totalPages;

  ContestTransactionDataModel({
    this.results,
    this.totalResults,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory ContestTransactionDataModel.fromJson(Map<String, dynamic> json) => ContestTransactionDataModel(
        results: json["results"] == null ? [] : List<ContestTransactionModel>.from(json["results"]!.map((x) => ContestTransactionModel.fromJson(x))),
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

class ContestTransactionModel {
  final String? id;
  final num? joiningAmount;
  final DateTime? createdAt;
  final num? winningAmount;
  final num? offerAmount;
  final num? refundAmount;
  final bool? isRefund;
  final JoinDetails? joinDetails;
  final num? gameError;

  ContestTransactionModel({
    this.id,
    this.joiningAmount,
    this.createdAt,
    this.winningAmount,
    this.offerAmount,
    this.refundAmount,
    this.isRefund,
    this.joinDetails,
    this.gameError,
  });

  factory ContestTransactionModel.fromJson(Map<String, dynamic> json) => ContestTransactionModel(
        id: json["_id"],
        joiningAmount: json["joining_amount"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        winningAmount: json["winning_amount"],
        offerAmount: json["offer_amount"],
        refundAmount: json["refund_amount"],
        isRefund: json["contest_cancel"],
        gameError: json["game_error_refund"],
        joinDetails: json["join_details"] == null ? null : JoinDetails.fromJson(json["join_details"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "joining_amount": joiningAmount,
        "createdAt": createdAt?.toIso8601String(),
        "winning_amount": winningAmount,
        "offer_amount": offerAmount,
        "refund_amount": refundAmount,
        "contest_cancel": isRefund,
        "game_error_refund": gameError,
        "join_details": joinDetails?.toJson(),
      };
}

class JoinDetails {
  final int? unUtilized;
  final int? winnings;
  final int? discount;

  JoinDetails({
    this.unUtilized,
    this.winnings,
    this.discount,
  });

  factory JoinDetails.fromJson(Map<String, dynamic> json) => JoinDetails(
        unUtilized: json["un_utilized"],
        winnings: json["winnings"],
        discount: json["discount"],
      );

  Map<String, dynamic> toJson() => {
        "un_utilized": unUtilized,
        "winnings": winnings,
        "discount": discount,
      };
}
