import 'dart:convert';

GetCompletedContestDataModel getCompletedContestDataModelFromJson(String str) => GetCompletedContestDataModel.fromJson(json.decode(str));

String getCompletedContestDataModelToJson(GetCompletedContestDataModel data) => json.encode(data.toJson());

class GetCompletedContestDataModel {
  bool? success;
  Data? data;

  GetCompletedContestDataModel({
    this.success,
    this.data,
  });

  factory GetCompletedContestDataModel.fromJson(Map<String, dynamic> json) => GetCompletedContestDataModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class Data {
  List<CompletedContestModel>? completedContests;
  int? totalResults;
  int? page;
  int? limit;
  int? totalPages;

  Data({
    this.completedContests,
    this.totalResults,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        completedContests: json["results"] == null ? [] : List<CompletedContestModel>.from(json["results"]!.map((x) => CompletedContestModel.fromJson(x))),
        totalResults: json["totalResults"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "results": completedContests == null ? [] : List<dynamic>.from(completedContests!.map((x) => x.toJson())),
        "totalResults": totalResults,
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
      };
}

class CompletedContestModel {
  String? id;
  String? participateStatus;
  int totalSpots;
  DateTime startTime;
  DateTime endTime;
  num entryFee;
  int winner;
  num distribution;
  num maxPricePool;
  int rank;
  num point;
  String contestId;

  String? recurring;
  int availableSpots;
  String winningStatus;
  String? joinStatus;
  num? winningAmount;
  bool isRefunded;
  String? contestStatus;
  int? upcomingRemainingMilliSeconds;
  int? liveRemainingMilliSeconds;
  num? gameErrorRefund;

  CompletedContestModel({
    this.id,
    this.participateStatus,
    required this.totalSpots,
    required this.startTime,
    required this.endTime,
    required this.entryFee,
    required this.winner,
    required this.distribution,
    required this.maxPricePool,
    required this.rank,
    required this.point,
    required this.contestId,
    this.recurring,
    required this.availableSpots,
    required this.winningStatus,
    this.joinStatus,
    this.winningAmount,
    this.isRefunded = false,
    this.contestStatus,
    this.upcomingRemainingMilliSeconds,
    this.liveRemainingMilliSeconds,
    this.gameErrorRefund,
  });

  factory CompletedContestModel.fromJson(Map<String, dynamic> json) => CompletedContestModel(
        id: json["_id"],
        participateStatus: json["participate_status"],
        totalSpots: json["total_spots"] ?? 0,
        startTime: DateTime.parse((json["start_time"] ?? DateTime.now()).toString()),
        endTime: DateTime.parse((json["end_time"] ?? DateTime.now()).toString()),
        entryFee: json["entry_fee"] ?? 0,
        winner: json["winner"] ?? 0,
        distribution: json["distribution"] ?? 0,
        maxPricePool: json["maxPricePool"] ?? 0,
        point: json["point"] ?? 0,
        rank: json["rank"] ?? 0,
        contestId: json["contestId"] ?? "",
        recurring: json["recurring"] ?? "",
        availableSpots: json["available_spots"] ?? 0,
        winningStatus: json["winning_status"] ?? "",
        joinStatus: json["join_status"],
        winningAmount: json["winning_amount"] ?? 0,
        isRefunded: json["contest_cancel"] ?? false,
        contestStatus: json["result_status"],
        upcomingRemainingMilliSeconds: json["upcoming_milliSeconds"],
        liveRemainingMilliSeconds: json["live_milliSeconds"],
        gameErrorRefund: json["game_error_refund"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "participate_status": participateStatus,
        "total_spots": totalSpots,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "entry_fee": entryFee,
        "winner": winner,
        "distribution": distribution,
        "maxPricePool": maxPricePool,
        "point": point,
        "rank": rank,
        "contestId": contestId,
        "recurring": recurring,
        "available_spots": availableSpots,
        "winning_status": winningStatus,
        "winning_amount": winningAmount,
        "contest_cancel": isRefunded,
        "result_status": contestStatus,
        "upcoming_milliSeconds": upcomingRemainingMilliSeconds,
        "live_milliSeconds": liveRemainingMilliSeconds,
        "game_error_refund": gameErrorRefund,
      };
}
