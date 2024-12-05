// To parse this JSON data, do
//
//     final getWinnersModel = getWinnersModelFromJson(jsonString);

import 'dart:convert';

GetWinnersModel getWinnersModelFromJson(String str) => GetWinnersModel.fromJson(json.decode(str));

String getWinnersModelToJson(GetWinnersModel data) => json.encode(data.toJson());

class GetWinnersModel {
  final bool? success;
  final WinnersModel? winnersModel;

  GetWinnersModel({
    this.success,
    this.winnersModel,
  });

  factory GetWinnersModel.fromJson(Map<String, dynamic> json) => GetWinnersModel(
        success: json["success"],
        winnersModel: json["data"] == null ? null : WinnersModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": winnersModel?.toJson(),
      };
}

class WinnersModel {
  List<Result>? results;
  final int? totalResults;
  final int? page;
  final int? limit;
  final int? totalPages;

  WinnersModel({
    this.results,
    this.totalResults,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory WinnersModel.fromJson(Map<String, dynamic> json) => WinnersModel(
        results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
        totalResults: json["totalResults"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
        "totalResults": totalResults,
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
      };
}

class Result {
  final String? id;
  final String? userName;
  final int? skillScore;
  final String? image;

  Result({
    this.id,
    this.userName,
    this.skillScore,
    this.image,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["_id"],
        userName: json["user_name"],
        skillScore: json["skill_score"]?.toInt(),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_name": userName,
        "skill_score": skillScore,
        "image": image,
      };
}
