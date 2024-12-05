
/*class PanCardModel {
  final String? type;
  final int? referenceId;
  final String? nameProvided;
  final String? registeredName;
  final String? fatherName;
  final bool? valid;
  final String? message;
  final String? pan;
  final StateModel? stateModel;

  PanCardModel({
    this.type,
    this.referenceId,
    this.nameProvided,
    this.registeredName,
    this.fatherName,
    this.valid,
    this.message,
    this.pan,
    this.stateModel,
  });

  factory PanCardModel.fromJson(Map<String, dynamic> json) => PanCardModel(
        type: json["type"],
        referenceId: json["reference_id"],
        nameProvided: json["name_provided"],
        registeredName: json["registered_name"],
        fatherName: json["father_name"],
        valid: json["valid"],
        message: json["message"],
        pan: json["pan"],
        stateModel: StateModel.fromJson(json["state"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "reference_id": referenceId,
        "name_provided": nameProvided,
        "registered_name": registeredName,
        "father_name": fatherName,
        "valid": valid,
        "message": message,
        "pan": pan,
        "state": stateModel,
      };
}*/

// To parse this JSON data, do
//
//     final getPanCardModel = getPanCardModelFromJson(jsonString);

import 'dart:convert';

import '../common/get_state_model.dart';

GetPanCardModel getPanCardModelFromJson(String str) => GetPanCardModel.fromJson(json.decode(str));

String getPanCardModelToJson(GetPanCardModel data) => json.encode(data.toJson());

class GetPanCardModel {
  final bool? success;
  final String? message;
  final GetPanCardDataModel? data;

  GetPanCardModel({
    this.success,
    this.message,
    this.data,
  });

  factory GetPanCardModel.fromJson(Map<String, dynamic> json) => GetPanCardModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : GetPanCardDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class GetPanCardDataModel {
  final PanCardModel? panInfo;
  final StateModel? state;

  GetPanCardDataModel({
    this.panInfo,
    this.state,
  });

  factory GetPanCardDataModel.fromJson(Map<String, dynamic> json) => GetPanCardDataModel(
    panInfo: json["pan_info"] == null ? null : PanCardModel.fromJson(json["pan_info"]),
    state: json["state"] == null ? null : StateModel.fromJson(json["state"]),
  );

  Map<String, dynamic> toJson() => {
    "pan_info": panInfo?.toJson(),
    "state": state?.toJson(),
  };
}

class PanCardModel {
  final String? pan;
  final String? type;
  final int? referenceId;
  final String? nameProvided;
  final String? registeredName;
  final String? fatherName;
  final bool? valid;
  final String? message;

  PanCardModel({
    this.pan,
    this.type,
    this.referenceId,
    this.nameProvided,
    this.registeredName,
    this.fatherName,
    this.valid,
    this.message,
  });

  factory PanCardModel.fromJson(Map<String, dynamic> json) => PanCardModel(
    pan: json["pan"],
    type: json["type"],
    referenceId: json["reference_id"],
    nameProvided: json["name_provided"],
    registeredName: json["registered_name"],
    fatherName: json["father_name"],
    valid: json["valid"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "pan": pan,
    "type": type,
    "reference_id": referenceId,
    "name_provided": nameProvided,
    "registered_name": registeredName,
    "father_name": fatherName,
    "valid": valid,
    "message": message,
  };
}

// class StateModel {
//   final String? id;
//   final String? name;
//   final String? stateCode;
//   final String? latitude;
//   final String? longitude;
//   final String? type;
//   final DateTime? deletedAt;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   StateModel({
//     this.id,
//     this.name,
//     this.stateCode,
//     this.latitude,
//     this.longitude,
//     this.type,
//     this.deletedAt,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
//     id: json["_id"],
//     name: json["name"],
//     stateCode: json["state_code"],
//     latitude: json["latitude"],
//     longitude: json["longitude"],
//     type: json["type"],
//     deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
//     createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
//     updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "name": name,
//     "state_code": stateCode,
//     "latitude": latitude,
//     "longitude": longitude,
//     "type": type,
//     "deleted_at": deletedAt?.toIso8601String(),
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//   };
// }
