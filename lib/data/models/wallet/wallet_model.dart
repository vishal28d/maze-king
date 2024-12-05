// To parse this JSON data, do
//
//     final walletModel = walletModelFromJson(jsonString);

import 'dart:convert';

GetWalletModel walletModelFromJson(String str) => GetWalletModel.fromJson(json.decode(str));

String walletModelToJson(GetWalletModel data) => json.encode(data.toJson());

class GetWalletModel {
  final bool? success;
  final WalletModel? data;

  GetWalletModel({
    this.success,
    this.data,
  });

  factory GetWalletModel.fromJson(Map<String, dynamic> json) => GetWalletModel(
        success: json["success"],
        data: json["data"] == null ? null : WalletModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class WalletModel {
  final String? id;
  final num? unUtilized;
  final num? winnings;
  final num? discount;
  final String? isRedeemed;
  final String? user;
  final String? redeemedFrom;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final num? myBalance;

  final AccountDetails? accountDetails;
  final num? tdsPercentage;
  final bool? panCardVerify;
  final bool? bankVerified;
  final bool? profileVerified;
  final num? minDepositAmount;
  final num? maxDepositAmount;
  final num? minWithdrawAmount;

  WalletModel({
    this.id,
    this.unUtilized,
    this.winnings,
    this.discount,
    this.isRedeemed,
    this.user,
    this.redeemedFrom,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.myBalance,
    this.accountDetails,
    this.tdsPercentage,
    this.panCardVerify,
    this.bankVerified,
    this.profileVerified,
    this.minDepositAmount,
    this.maxDepositAmount,
    this.minWithdrawAmount,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        id: json["_id"],
        unUtilized: json["un_utilized"],
        winnings: json["winnings"],
        discount: json["discount"],
        isRedeemed: json["is_redeemed"],
        user: json["user"],
        redeemedFrom: json["redeemed_from"],
        deletedAt: json["deleted_at"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        myBalance: json["my_balance"],
        accountDetails: json["account_details"] == null ? null : AccountDetails.fromJson(json["account_details"]),
        tdsPercentage: json["tds_percentage"],
        panCardVerify: json["pancard_verify"],
        bankVerified: json["is_bank"],
        profileVerified: json["profile_verified"],
        minDepositAmount: json["min_deposit"],
        maxDepositAmount: json["max_deposit"],
        minWithdrawAmount: json["min_withdraw"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "un_utilized": unUtilized,
        "winnings": winnings,
        "discount": discount,
        "is_redeemed": isRedeemed,
        "user": user,
        "redeemed_from": redeemedFrom,
        "deleted_at": deletedAt,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "my_balance": myBalance,
        "account_details": accountDetails?.toJson(),
        "tds_percentage": tdsPercentage,
        "pancard_verify": panCardVerify,
        "is_bank": bankVerified,
        "profile_verified": profileVerified,
        "min_deposit": minDepositAmount,
        "max_deposit": maxDepositAmount,
        "min_withdraw": minWithdrawAmount,
      };
}

class AccountDetails {
  final String? ifsc;
  final String? bankName;
  final String? name;
  final List<dynamic>? notes;
  final String? accountNumber;
  final String? bankIdentifier;
  final String? identifierType;

  AccountDetails({
    this.ifsc,
    this.bankName,
    this.name,
    this.notes,
    this.accountNumber,
    this.bankIdentifier,
    this.identifierType,
  });

  factory AccountDetails.fromJson(Map<String, dynamic> json) => AccountDetails(
        ifsc: json["bene_ifsc"],
        bankName: json["bank_name"],
        name: json["bene_name"],
        notes: json["notes"] == null ? [] : List<dynamic>.from(json["notes"]!.map((x) => x)),
        accountNumber: json["account_number"],
        bankIdentifier: json["bank_identifier"],
        identifierType: json["identifier_type"],
      );

  Map<String, dynamic> toJson() => {
        "bene_ifsc": ifsc,
        "bank_name": bankName,
        "bene_name": name,
        "notes": notes == null ? [] : List<dynamic>.from(notes!.map((x) => x)),
        "account_number": accountNumber,
        "bank_identifier": bankIdentifier,
        "identifier_type": identifierType,
      };
}
