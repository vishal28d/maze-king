// To parse this JSON data, do
//
//     final getUpcomingContestDataModel = getUpcomingContestDataModelFromJson(jsonString);

import 'dart:convert';

GetMyUpcomingContestDataModel getMyUpcomingContestDataModelFromJson(String str) => GetMyUpcomingContestDataModel.fromJson(json.decode(str));

String getMyUpcomingContestDataModelToJson(GetMyUpcomingContestDataModel data) => json.encode(data.toJson());

class GetMyUpcomingContestDataModel {
  bool? success;
  Data? data;

  GetMyUpcomingContestDataModel({
    this.success,
    this.data,
  });

  factory GetMyUpcomingContestDataModel.fromJson(Map<String, dynamic> json) => GetMyUpcomingContestDataModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class Data {
  List<MyUpcomingContestModel>? myUpcomingContests;
  int? totalResults;
  int? page;
  int? limit;
  int? totalPages;

  Data({
    this.myUpcomingContests,
    this.totalResults,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        myUpcomingContests: json["results"] == null ? [] : List<MyUpcomingContestModel>.from(json["results"]!.map((x) => MyUpcomingContestModel.fromJson(x))),
        totalResults: json["totalResults"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "results": myUpcomingContests == null ? [] : List<dynamic>.from(myUpcomingContests!.map((x) => x.toJson())),
        "totalResults": totalResults,
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
      };
}

class MyUpcomingContestModel {
  String? id;
  int totalSpots;
  DateTime startTime;
  DateTime endTime;
  num entryFee;

  // int winner;
  // num distribution;
  num maxPricePool;
  String contestId;
  String? recurring;
  int availableSpots;

  String participateStatus;
  String? joinStatus;
  int? upcomingRemainingMilliSeconds;
  int? liveRemainingMilliSeconds;
  String? contest_title;
  String? contest_image;
  String? brainImage;
  bool? pin_to_top;
  int? top_position;

  MyUpcomingContestModel({
    this.id,
    required this.totalSpots,
    required this.startTime,
    required this.endTime,
    required this.entryFee,
    // required this.winner,
    // required this.distribution,
    required this.maxPricePool,
    required this.contestId,
    this.recurring,
    required this.availableSpots,
    required this.participateStatus,
    this.joinStatus,
    this.upcomingRemainingMilliSeconds,
    this.liveRemainingMilliSeconds,
    this.contest_title,
    this.contest_image,
    this.brainImage,
    this.pin_to_top,
    this.top_position,
  });

  factory MyUpcomingContestModel.fromJson(Map<String, dynamic> json) => MyUpcomingContestModel(
        id: json["_id"],
        totalSpots: json["total_spots"],
        startTime: DateTime.parse((json["start_time"] ?? "").toString()),
        endTime: DateTime.parse((json["end_time"] ?? "").toString()),
        entryFee: json["entry_fee"],
        // winner: json["winner"],
        // distribution: json["distribution"],
        maxPricePool: json["maxPricePool"],
        contestId: json["contestId"] ?? "",
        recurring: json["recurring"],
        availableSpots: json["available_spots"],
        participateStatus: json["participate_status"] ?? "",
        joinStatus: json["join_status"],
        upcomingRemainingMilliSeconds: json["upcoming_milliSeconds"],
        liveRemainingMilliSeconds: json["live_milliSeconds"],
    contest_title: json["contest_title"],
    contest_image: json["contest_image"],
    pin_to_top: json["pin_to_top"],
    brainImage: json["brainImage"],
    top_position: json["top_position"],

      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "total_spots": totalSpots,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "entry_fee": entryFee,
        // "winner": winner,
        // "distribution": distribution,
        "maxPricePool": maxPricePool,
        "contestId": contestId,
        "recurring": recurring,
        "available_spots": availableSpots,
        "participate_status": participateStatus,
        "join_status": joinStatus,
        "upcoming_milliSeconds": upcomingRemainingMilliSeconds,
        "live_milliSeconds": liveRemainingMilliSeconds,
    "pin_to_top": pin_to_top,
    "brainImage": brainImage,
    "top_position": top_position,
    "contest_title": contest_title,
    "contest_image": contest_image,
      };
}
