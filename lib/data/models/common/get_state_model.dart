// To parse this JSON data, do
//
//     final getStateModel = getStateModelFromJson(jsonString);

import 'dart:convert';

GetStateModel getStateModelFromJson(String str) => GetStateModel.fromJson(json.decode(str));

String getStateModelToJson(GetStateModel data) => json.encode(data.toJson());

class GetStateModel {
  final bool? success;
  final StateDataModel? data;

  GetStateModel({
    this.success,
    this.data,
  });

  factory GetStateModel.fromJson(Map<String, dynamic> json) => GetStateModel(
    success: json["success"],
    data: json["data"] == null ? null : StateDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class StateDataModel {
  final List<StateModel>? states;
  final int? totalResults;
  final int? page;
  final int? limit;
  final int? totalPages;

  StateDataModel({
    this.states,
    this.totalResults,
    this.page,
    this.limit,
    this.totalPages,
  });

  factory StateDataModel.fromJson(Map<String, dynamic> json) => StateDataModel(
    states: json["results"] == null ? [] : List<StateModel>.from(json["results"]!.map((x) => StateModel.fromJson(x))),
    totalResults: json["totalResults"],
    page: json["page"],
    limit: json["limit"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "results": states == null ? [] : List<dynamic>.from(states!.map((x) => x.toJson())),
    "totalResults": totalResults,
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
  };
}

class StateModel {
  final String? id;
  final String? name;
  final String? stateCode;
  final String? latitude;
  final String? longitude;
  final String? type;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StateModel({
    this.id,
    this.name,
    this.stateCode,
    this.latitude,
    this.longitude,
    this.type,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
    id: json["_id"],
    name: json["name"],
    stateCode: json["state_code"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    type: json["type"],
    deletedAt: json["deleted_at"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "state_code": stateCode,
    "latitude": latitude,
    "longitude": longitude,
    "type": type,
    "deleted_at": deletedAt,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
