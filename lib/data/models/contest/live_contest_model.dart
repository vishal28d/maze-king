import 'dart:convert';

GetLiveContestDataModel getLiveContestDataModelFromJson(String str) => GetLiveContestDataModel.fromJson(json.decode(str));

String getLiveContestDataModelToJson(GetLiveContestDataModel data) => json.encode(data.toJson());

class GetLiveContestDataModel {
  bool? success;
  Data? data;

  GetLiveContestDataModel({
    this.success,
    this.data,
  });

  factory GetLiveContestDataModel.fromJson(Map<String, dynamic> json) => GetLiveContestDataModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class Data {
  List<LiveContestModel>? liveContests;
  int? totalResults;
  int? page;
  int? limit;
  int? totalPages;

  Data({
    this.liveContests,
    this.totalResults,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        liveContests: json["results"] == null ? [] : List<LiveContestModel>.from(json["results"]!.map((x) => LiveContestModel.fromJson(x))),
        totalResults: json["totalResults"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "results": liveContests == null ? [] : List<dynamic>.from(liveContests!.map((x) => x.toJson())),
        "totalResults": totalResults,
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
      };
}

class LiveContestModel {
  String? id;

  int totalSpots;
  DateTime startTime;
  DateTime endTime;
  num entryFee;
  int winner;
  num distribution;
  num maxPricePool;
  String contestId;

  String? recurring;
  int availableSpots;
  String participateStatus;
  String? joinStatus;
  int? upcomingRemainingMilliSeconds;
  int? liveRemainingMilliSeconds;

  LiveContestModel({
    this.id,
    required this.totalSpots,
    required this.startTime,
    required this.endTime,
    required this.entryFee,
    required this.winner,
    required this.distribution,
    required this.maxPricePool,
    required this.contestId,
    this.recurring,
    required this.availableSpots,
    required this.participateStatus,
    this.joinStatus,
    this.upcomingRemainingMilliSeconds,
    this.liveRemainingMilliSeconds,
  });

  factory LiveContestModel.fromJson(Map<String, dynamic> json) => LiveContestModel(
        id: json["_id"],
        totalSpots: json["total_spots"],
        startTime: DateTime.parse((json["start_time"] ?? "").toString()),
        endTime: DateTime.parse((json["end_time"] ?? "").toString()),
        entryFee: json["entry_fee"],
        winner: json["winner"],
        distribution: json["distribution"],
        maxPricePool: json["maxPricePool"] ?? 0,
        contestId: json["contestId"] ?? "",
        recurring: json["recurring"],
        availableSpots: json["available_spots"],
        participateStatus: json["participate_status"] ?? "",
        joinStatus: json["join_status"],
        upcomingRemainingMilliSeconds: json["upcoming_milliSeconds"],
        liveRemainingMilliSeconds: json["live_milliSeconds"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "total_spots": totalSpots,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "entry_fee": entryFee,
        "winner": winner,
        "distribution": distribution,
        "maxPricePool": maxPricePool,
        "contestId": contestId,
        "recurring": recurring,
        "available_spots": availableSpots,
        "participate_status": participateStatus,
        "join_status": joinStatus,
        "upcoming_milliSeconds": upcomingRemainingMilliSeconds,
        "live_milliSeconds": liveRemainingMilliSeconds,
      };
}
