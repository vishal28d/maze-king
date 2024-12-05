// To parse this JSON data, do
//
//     final getComparisonModel = getComparisonModelFromJson(jsonString);

import 'dart:convert';

GetComparisonModel getComparisonModelFromJson(String str) => GetComparisonModel.fromJson(json.decode(str));

String getComparisonModelToJson(GetComparisonModel data) => json.encode(data.toJson());

class GetComparisonModel {
  final bool? success;
  final ComparisonModel? comparisonModel;

  GetComparisonModel({
    this.success,
    this.comparisonModel,
  });

  factory GetComparisonModel.fromJson(Map<String, dynamic> json) => GetComparisonModel(
        success: json["success"],
        comparisonModel: json["data"] == null ? null : ComparisonModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": comparisonModel?.toJson(),
      };
}

class ComparisonModel {
  final OtherUser? you;
  final OtherUser? otherUser;

  ComparisonModel({
    this.you,
    this.otherUser,
  });

  factory ComparisonModel.fromJson(Map<String, dynamic> json) => ComparisonModel(
        you: json["you"] == null ? null : OtherUser.fromJson(json["you"]),
        otherUser: json["otherUser"] == null ? null : OtherUser.fromJson(json["otherUser"]),
      );

  Map<String, dynamic> toJson() => {
        "you": you?.toJson(),
        "otherUser": otherUser?.toJson(),
      };
}

class OtherUser {
  final String? userName;
  final DateTime? createdAt;
  final int? skillScore;
  final double? winningRatio;
  final int? contest;
  final String? image;

  OtherUser({
    this.userName,
    this.createdAt,
    this.skillScore,
    this.winningRatio,
    this.contest,
    this.image,
  });

  factory OtherUser.fromJson(Map<String, dynamic> json) => OtherUser(
        userName: json["user_name"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        skillScore: json["skill_score"]?.toInt(),
        winningRatio: json["winning_ratio"]?.toDouble(),
        contest: json["contest"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "createdAt": createdAt?.toIso8601String(),
        "skill_score": skillScore,
        "winning_ratio": winningRatio,
        "contest": contest,
        "image": image,
      };
}
