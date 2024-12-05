// To parse this JSON data, do
//
//     final getBankModel = getBankModelFromJson(jsonString);

import 'dart:convert';

GetBankModel getBankModelFromJson(String str) => GetBankModel.fromJson(json.decode(str));

String getBankModelToJson(GetBankModel data) => json.encode(data.toJson());

class GetBankModel {
  final bool? success;
  final String? message;
  final BankModel? bankModel;

  GetBankModel({
    this.success,
    this.message,
    this.bankModel,
  });

  factory GetBankModel.fromJson(Map<String, dynamic> json) => GetBankModel(
        success: json["success"],
        message: json["message"],
        bankModel: json["BankModel"] == null ? null : BankModel.fromJson(json["BankModel"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "BankModel": bankModel?.toJson(),
      };
}

class BankModel {
  final String? ifsc;
  final String? name;
  final List<dynamic>? notes;
  final String? accountNumber;
  final dynamic bankIdentifier;
  final dynamic identifierType;
  final String? bankName;
  final String? branchName;
  final String? bankAddress;
  final int? accountNumberMin;
  final int? accountNumberMax;

  BankModel({
    this.ifsc,
    this.name,
    this.notes,
    this.accountNumber,
    this.bankIdentifier,
    this.identifierType,
    this.bankName,
    this.branchName,
    this.bankAddress,
    this.accountNumberMin,
    this.accountNumberMax,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
        ifsc: json["bene_ifsc"],
        name: json["bene_name"],
        notes: json["notes"] == null ? [] : List<dynamic>.from(json["notes"]!.map((x) => x)),
        accountNumber: json["account_number"],
        bankIdentifier: json["bank_identifier"],
        identifierType: json["identifier_type"],
        bankName: json["bank_name"],
        branchName: json["branch_name"],
        bankAddress: json["bene_address"],
        accountNumberMin: json["account_number_min"],
        accountNumberMax: json["account_number_max"],
      );

  Map<String, dynamic> toJson() => {
        "ifsc": ifsc,
        "name": name,
        "notes": notes == null ? [] : List<dynamic>.from(notes!.map((x) => x)),
        "account_number": accountNumber,
        "bank_identifier": bankIdentifier,
        "identifier_type": identifierType,
        "bank_name": bankName,
        "branch_name": branchName,
        "bene_address": bankAddress,
        "account_number_length": accountNumberMin,
        "account_number_max": accountNumberMax,
      };
}
