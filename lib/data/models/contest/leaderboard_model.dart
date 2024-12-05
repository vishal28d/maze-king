// To parse this JSON data, do
//
//     final getLeaderboardDataModel = getLeaderboardDataModelFromJson(jsonString);

import 'dart:convert';

GetLeaderboardDataModel getLeaderboardDataModelFromJson(String str) => GetLeaderboardDataModel.fromJson(json.decode(str));

String getLeaderboardDataModelToJson(GetLeaderboardDataModel data) => json.encode(data.toJson());

class GetLeaderboardDataModel {
  bool? success;
  Data? data;

  GetLeaderboardDataModel({
    this.success,
    this.data,
  });

  factory GetLeaderboardDataModel.fromJson(Map<String, dynamic> json) => GetLeaderboardDataModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class Data {
  List<LeaderBoardModel>? leaderboardList;
  int? totalResults;
  int? page;
  int? limit;
  int? totalPages;
  LeaderBoardModel? myLeaderboardDetails;

  Data({
    this.leaderboardList,
    this.totalResults,
    this.page,
    this.limit,
    this.totalPages,
    this.myLeaderboardDetails,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        leaderboardList: json["results"] == null ? [] : List<LeaderBoardModel>.from(json["results"]!.map((x) => LeaderBoardModel.fromJson(x))),
        totalResults: json["totalResults"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        myLeaderboardDetails: json["userDetails"] == null ? null : LeaderBoardModel.fromJson(json["userDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "results": leaderboardList == null ? [] : List<dynamic>.from(leaderboardList!.map((x) => x.toJson())),
        "totalResults": totalResults,
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
        "userDetails": myLeaderboardDetails?.toJson(),
      };
}

class LeaderBoardModel {
  String? userName;
  String? userId;
  String? image;
  String? winningStatus;
  String? joinStatus;
  num? winningAmount;
  int? rank;
  num? point;
  bool isRefunded;
  num? totalPercentage;
  num? winningPercentage;
  num? winningTime;
  num? gameErrorRefund;

  LeaderBoardModel({
    this.userName,
    this.userId,
    this.image,
    this.winningStatus,
    this.joinStatus,
    this.winningAmount,
    this.rank,
    this.point,
    this.isRefunded = false,
    this.totalPercentage,
    this.winningPercentage,
    this.winningTime,
    this.gameErrorRefund,
  });

  factory LeaderBoardModel.fromJson(Map<String, dynamic> json) => LeaderBoardModel(
        userName: json["user_name"],
        userId: json["user_id"],
        image: json["image"],
        winningStatus: json["winning_status"],
        joinStatus: json["join_status"],
        winningAmount: json["winning_amount"],
        rank: json["rank"],
        point: json["point"],
        totalPercentage: json["total_percentage"],
        winningPercentage: json["winning_percentage"],
        winningTime: json["winning_time"],
        isRefunded: json["contest_cancel"] ?? false,
        gameErrorRefund: json["game_error_refund"],
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "user_id": userId,
        "image": image,
        "winning_status": winningStatus,
        "join_status": joinStatus,
        "winning_amount": winningAmount,
        "rank": rank,
        "point": point,
        "contest_cancel": isRefunded,
        "total_percentage": totalPercentage,
        "winning_percentage": winningPercentage,
        "winning_time": winningTime,
        "game_error_refund": gameErrorRefund,
      };
}
