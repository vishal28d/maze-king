// To parse this JSON data, do
//
//     final getContestDetailsDataModel = getContestDetailsDataModelFromJson(jsonString);

import 'dart:convert';

GetContestDetailsDataModel getContestDetailsDataModelFromJson(String str) => GetContestDetailsDataModel.fromJson(json.decode(str));

String getContestDetailsDataModelToJson(GetContestDetailsDataModel data) => json.encode(data.toJson());

class GetContestDetailsDataModel {
  bool? success;
  ContestDetailsModel? contestDetails;

  GetContestDetailsDataModel({
    this.success,
    this.contestDetails,
  });

  factory GetContestDetailsDataModel.fromJson(Map<String, dynamic> json) => GetContestDetailsDataModel(
        success: json["success"],
        contestDetails: ContestDetailsModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": contestDetails,
      };
}

class ContestDetailsModel {
  String? id;
  int totalSpots;
  DateTime startTime;
  DateTime endTime;
  num entryFee;
  // int winner;
  // num distribution;
  num maxPricePool;
  String? recurring;
  int availableSpots;

  String? participateStatus;
  String? joinStatus;
  String? winningStatus;
  bool? isRefunded;
  String? contestStatus;
  int? upcomingRemainingMilliSeconds;
  int? liveRemainingMilliSeconds;

  ContestDetailsModel({
    this.id,
    required this.totalSpots,
    required this.startTime,
    required this.endTime,
    required this.entryFee,
    // required this.winner,
    // required this.distribution,
    required this.maxPricePool,
    this.recurring,
    required this.availableSpots,
    this.participateStatus,
    this.joinStatus,
    this.winningStatus,
    this.isRefunded,
    this.contestStatus,
    this.upcomingRemainingMilliSeconds,
    this.liveRemainingMilliSeconds,
  });

  factory ContestDetailsModel.fromJson(Map<String, dynamic> json) => ContestDetailsModel(
        id: json["_id"],
        totalSpots: json["total_spots"],
        startTime: DateTime.parse((json["start_time"] ?? "").toString()),
        endTime: DateTime.parse((json["end_time"] ?? "").toString()),
        entryFee: json["entry_fee"],
        // winner: json["winner"],
        // distribution: json["distribution"],
        maxPricePool: json["maxPricePool"],
        recurring: json["recurring"],
        availableSpots: json["available_spots"],
        participateStatus: json["participate_status"],
        joinStatus: json["join_status"],
        winningStatus: json["winning_status"],
        isRefunded: json["contest_cancel"],
        contestStatus: json["result_status"],
        upcomingRemainingMilliSeconds: json["upcoming_milliSeconds"],
        liveRemainingMilliSeconds: json["live_milliSeconds"],
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
        "available_spots": availableSpots,
        "participate_status": participateStatus,
        "join_status": joinStatus,
        "winning_status": winningStatus,
        "contest_cancel": isRefunded,
        "result_status": contestStatus,
        "upcoming_milliSeconds": upcomingRemainingMilliSeconds,
        "live_milliSeconds": liveRemainingMilliSeconds,
      };
}
