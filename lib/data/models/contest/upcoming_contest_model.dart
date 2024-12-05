// To parse this JSON data, do
//
//     final getUpcomingContestDataModel = getUpcomingContestDataModelFromJson(jsonString);

import 'dart:convert';

GetUpcomingContestDataModel getUpcomingContestDataModelFromJson(String str) => GetUpcomingContestDataModel.fromJson(json.decode(str));

String getUpcomingContestDataModelToJson(GetUpcomingContestDataModel data) => json.encode(data.toJson());

class GetUpcomingContestDataModel {
  bool? success;
  Data? data;

  GetUpcomingContestDataModel({
    this.success,
    this.data,
  });

  factory GetUpcomingContestDataModel.fromJson(Map<String, dynamic> json) => GetUpcomingContestDataModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class Data {
  List<UpcomingContestModel>? upcomingContests;
  int? totalResults;
  int? page;
  int? limit;
  int? totalPages;

  Data({
    this.upcomingContests,
    this.totalResults,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        upcomingContests: json["results"] == null ? [] : List<UpcomingContestModel>.from(json["results"]!.map((x) => UpcomingContestModel.fromJson(x))),
        totalResults: json["totalResults"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "results": upcomingContests == null ? [] : List<dynamic>.from(upcomingContests!.map((x) => x.toJson())),
        "totalResults": totalResults,
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
      };
}

class UpcomingContestModel {
  String? id;
  int totalSpots;
  DateTime startTime;
  DateTime endTime;
  num entryFee;
  // int winner;
  // num distribution;
  num maxPricePool;
  String? recurring;
  String? contest_title;
  String? contest_image;
  String? brainImage;
  int availableSpots;
  int? upcomingRemainingMilliSeconds;
  int? liveRemainingMilliSeconds;
  bool? pin_to_top;
  int? top_position;

  UpcomingContestModel({
    this.id,
    required this.totalSpots,
    required this.startTime,
    required this.endTime,
    required this.entryFee,
    // required this.winner,
    // required this.distribution,
    required this.maxPricePool,
    this.recurring,
    this.contest_title,
    this.contest_image,
    this.brainImage,
    required this.availableSpots,
    this.pin_to_top,
    this.top_position,
    this.upcomingRemainingMilliSeconds,
    this.liveRemainingMilliSeconds,
  });

  factory UpcomingContestModel.fromJson(Map<String, dynamic> json) => UpcomingContestModel(
        id: json["_id"],
        totalSpots: json["total_spots"],
        startTime: DateTime.parse((json["start_time"] ?? "").toString()),
        endTime: DateTime.parse((json["end_time"] ?? "").toString()),
        entryFee: json["entry_fee"],
        // winner: json["winner"],
        // distribution: json["distribution"],
        maxPricePool: json["maxPricePool"] ?? 0,
        recurring: json["recurring"],
        contest_title: json["contest_title"],
        contest_image: json["contest_image"],
        availableSpots: json["available_spots"],
        upcomingRemainingMilliSeconds: json["upcoming_milliSeconds"],
        liveRemainingMilliSeconds: json["live_milliSeconds"],
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
        "recurring": recurring,
        "contest_title": contest_title,
        "contest_image": contest_image,
        "available_spots": availableSpots,
        "upcoming_milliSeconds": upcomingRemainingMilliSeconds,
        "live_milliSeconds": liveRemainingMilliSeconds,
        "pin_to_top": pin_to_top,
        "brainImage": brainImage,
        "top_position": top_position,
      };
}
