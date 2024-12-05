// To parse this JSON data, do
//
//     final getJoinContestPricingDataModel = getJoinContestPricingDataModelFromJson(jsonString);

import 'dart:convert';

GetJoinContestPricingDataModel getJoinContestPricingDataModelFromJson(String str) => GetJoinContestPricingDataModel.fromJson(json.decode(str));

String getJoinContestPricingDataModelToJson(GetJoinContestPricingDataModel data) => json.encode(data.toJson());

class GetJoinContestPricingDataModel {
  bool? success;
  JoinContestPricingModel? joinContestPricingModel;

  GetJoinContestPricingDataModel({
    this.success,
    this.joinContestPricingModel,
  });

  factory GetJoinContestPricingDataModel.fromJson(Map<String, dynamic> json) => GetJoinContestPricingDataModel(
        success: json["success"],
        joinContestPricingModel: json["data"] == null ? null : JoinContestPricingModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": joinContestPricingModel?.toJson(),
      };
}

class JoinContestPricingModel {
  num discount;
  num unUtilized;
  num winning;
  bool insufficientBalance;
  num requireAmount;
  Wallet wallet;

  JoinContestPricingModel({
    required this.discount,
    required this.unUtilized,
    required this.winning,
    required this.insufficientBalance,
    required this.requireAmount,
    required this.wallet,
  });

  factory JoinContestPricingModel.fromJson(Map<String, dynamic> json) => JoinContestPricingModel(
        discount: json["discount"],
        unUtilized: json["un_utilized"],
        winning: json["winning"],
        insufficientBalance: json["insufficientBalance"] ?? false,
        requireAmount: num.parse((json["requireAmount"] ?? 0).toString()),
        wallet: Wallet.fromJson(json["wallet"]),
      );

  Map<String, dynamic> toJson() => {
        "discount": discount,
        "un_utilized": unUtilized,
        "winning": winning,
        "insufficientBalance": insufficientBalance,
        "requireAmount": requireAmount,
        "wallet": wallet,
      };
}

class Wallet {
  num unUtilized;
  num winnings;
  num discount;

  Wallet({
    required this.unUtilized,
    required this.winnings,
    required this.discount,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
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
