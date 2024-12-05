// To parse this JSON data, do
//
//     final getGameDetailsDataModel = getGameDetailsDataModelFromJson(jsonString);

import 'dart:convert';

GetGameDetailsDataModel getGameDetailsDataModelFromJson(String str) => GetGameDetailsDataModel.fromJson(json.decode(str));

String getGameDetailsDataModelToJson(GetGameDetailsDataModel data) => json.encode(data.toJson());

class GetGameDetailsDataModel {
  bool? success;
  String? message;
  GameDetailsModel? gameDetails;

  GetGameDetailsDataModel({
    this.success,
    this.message,
    this.gameDetails,
  });

  factory GetGameDetailsDataModel.fromJson(Map<String, dynamic> json) => GetGameDetailsDataModel(
        success: json["success"],
        message: json["message"],
        gameDetails: json["data"] == null ? null : GameDetailsModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": gameDetails?.toJson(),
      };
}

class GameDetailsModel {
  String? id;
  int? totalSpots;
  DateTime? startTime;
  DateTime? endTime;
  num? entryFee;
  num? winner;
  num? distribution;
  bool? recurring;
  String? recurringId;
  num? recurringClose;
  String? recurringCloseType;
  int? row;
  int? column;
  List<List<bool>>? cells;
  List<List<int>>? winningPath;
  List<int>? start;
  List<int>? end;
  String? user;
  bool? isActive;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? contestReminder;
  bool? joinReminder;
  num? gst;
  String? joinStatus;
  int? upcomingRemainingMilliSeconds;
  int? liveRemainingMilliSeconds;

  GameDetailsModel({
    this.id,
    this.totalSpots,
    this.startTime,
    this.endTime,
    this.entryFee,
    this.winner,
    this.distribution,
    this.recurring,
    this.recurringId,
    this.recurringClose,
    this.recurringCloseType,
    this.row,
    this.column,
    this.cells,
    this.winningPath,
    this.start,
    this.end,
    this.user,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.contestReminder,
    this.joinReminder,
    this.gst,
    this.joinStatus,
    this.upcomingRemainingMilliSeconds,
    this.liveRemainingMilliSeconds,
  });

  factory GameDetailsModel.fromJson(Map<String, dynamic> json) => GameDetailsModel(
        id: json["_id"],
        totalSpots: json["total_spots"],
        startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
        endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
        entryFee: json["entry_fee"],
        winner: json["winner"],
        distribution: json["distribution"],
        recurring: json["recurring"],
        recurringId: json["recurringId"] ?? "",
        recurringClose: json["recurring_close"],
        recurringCloseType: json["recurring_close_type"],
        row: json["row"],
        column: json["column"],
        cells: json["cells"] == null ? [] : List<List<bool>>.from(json["cells"]!.map((x) => List<bool>.from(x.map((x) => x)))),
        winningPath: json["winning_path"] == null ? [] : List<List<int>>.from(json["winning_path"]!.map((x) => List<int>.from(x.map((x) => x)))),
        start: json["start"] == null ? [] : List<int>.from(json["start"]!.map((x) => x)),
        end: json["end"] == null ? [] : List<int>.from(json["end"]!.map((x) => x)),
        user: json["user"],
        isActive: json["is_active"],
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        contestReminder: json["contest_reminder"],
        joinReminder: json["join_reminder"],
        gst: json["gst"],
        joinStatus: json["join_status"],
        upcomingRemainingMilliSeconds: json["upcoming_milliSeconds"],
        liveRemainingMilliSeconds: json["live_milliSeconds"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "total_spots": totalSpots,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "entry_fee": entryFee,
        "winner": winner,
        "distribution": distribution,
        "recurring": recurring,
        "recurringId": recurringId,
        "recurring_close": recurringClose,
        "recurring_close_type": recurringCloseType,
        "row": row,
        "column": column,
        "cells": cells == null ? [] : List<dynamic>.from(cells!.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "winning_path": winningPath == null ? [] : List<dynamic>.from(winningPath!.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "start": start == null ? [] : List<dynamic>.from(start!.map((x) => x)),
        "end": end == null ? [] : List<dynamic>.from(end!.map((x) => x)),
        "user": user,
        "is_active": isActive,
        "deleted_at": deletedAt?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "contest_reminder": contestReminder,
        "join_reminder": joinReminder,
        "gst": gst,
        "join_status": joinStatus,
        "upcoming_milliSeconds": upcomingRemainingMilliSeconds,
        "live_milliSeconds": liveRemainingMilliSeconds,
      };
}
