// To parse this JSON data, do
//
//     final getUserDetailsModel = getUserDetailsModelFromJson(jsonString);

import 'dart:convert';

import '../common/get_state_model.dart';

GetUserDetailsModel getUserDetailsModelFromJson(String str) => GetUserDetailsModel.fromJson(json.decode(str));

String getUserDetailsModelToJson(GetUserDetailsModel data) => json.encode(data.toJson());

class GetUserDetailsModel {
  final bool? success;
  final UserDetailsModel? userDetailsModel;

  GetUserDetailsModel({
    this.success,
    this.userDetailsModel,
  });

  factory GetUserDetailsModel.fromJson(Map<String, dynamic> json) => GetUserDetailsModel(
        success: json["success"],
        userDetailsModel: json["data"] == null ? null : UserDetailsModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": userDetailsModel?.toJson(),
      };
}

class UserDetailsModel {
  final DeviceInfo? deviceInfo;
  final String? id;
  final String? mobile;
  final String? userName;
  final String? image;
  final String? referralCode;
  final String? role;
  final String? fundAccount;
  final bool? notification;
  final bool? isBlock;
  final bool? isActive;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? address;
  final String? gender;
  final String? city;
  final String? country;
  final String? pincode;
  final StateModel? state;
  final String? firstName;
  final String? lastName;
  final num? myBalance;

  UserDetailsModel({
    this.deviceInfo,
    this.id,
    this.mobile,
    this.userName,
    this.image,
    this.referralCode,
    this.role,
    this.fundAccount,
    this.notification,
    this.isBlock,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.address,
    this.gender,
    this.city,
    this.country,
    this.pincode,
    this.state,
    this.firstName,
    this.lastName,
    this.myBalance,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => UserDetailsModel(
        deviceInfo: json["device_info"] == null ? null : DeviceInfo.fromJson(json["device_info"]),
        id: json["_id"],
        mobile: json["mobile"],
        userName: json["user_name"],
        image: json["image"],
        referralCode: json["referral_code"],
        role: json["role"],
        fundAccount: json["fund_account"],
        notification: json["notification"],
        isBlock: json["is_block"],
        isActive: json["is_active"],
        deletedAt: json["deleted_at"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        address: json["address"],
        gender: json["gender"],
        city: json["city"],
        country: json["country"],
        pincode: json["pincode"],
        state: json["state"] == null ? null : StateModel.fromJson(json["state"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        myBalance: json["my_balance"],
      );

  Map<String, dynamic> toJson() => {
        "device_info": deviceInfo?.toJson(),
        "_id": id,
        "mobile": mobile,
        "user_name": userName,
        "image": image,
        "referral_code": referralCode,
        "role": role,
        "fund_account": fundAccount,
        "notification": notification,
        "is_block": isBlock,
        "is_active": isActive,
        "deleted_at": deletedAt,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "address": address,
        "gender": gender,
        "city": city,
        "country": country,
        "pincode": pincode,
        "state": state?.toJson(),
        "first_name": firstName,
        "last_name": lastName,
        "my_balance": myBalance,
      };
}

class DeviceInfo {
  final String? deviceName;
  final String? deviceId;
  final String? deviceType;
  final String? deviceToken;

  DeviceInfo({
    this.deviceName,
    this.deviceId,
    this.deviceType,
    this.deviceToken,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => DeviceInfo(
        deviceName: json["device_name"],
        deviceId: json["device_id"],
        deviceType: json["device_type"],
        deviceToken: json["device_token"],
      );

  Map<String, dynamic> toJson() => {
        "device_name": deviceName,
        "device_id": deviceId,
        "device_type": deviceType,
        "device_token": deviceToken,
      };
}
