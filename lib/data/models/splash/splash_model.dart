// To parse this JSON data, do
//
//     final getSplashDataModel = getSplashDataModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

GetSplashDataModel getSplashDataModelFromJson(String str) => GetSplashDataModel.fromJson(json.decode(str));

String getSplashDataModelToJson(GetSplashDataModel data) => json.encode(data.toJson());

class GetSplashDataModel {
  bool? success;
  String? message;
  Data? data;

  GetSplashDataModel({
    this.success,
    this.message,
    this.data,
  });

  factory GetSplashDataModel.fromJson(Map<String, dynamic> json) => GetSplashDataModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  List<AppConfigModel>? appConfigs;
  List<VersionModel>? versions;
  String? howToPlayVideoLink;
  String? userGuideVideoLink;

  Data({
    this.appConfigs,
    this.versions,
    this.howToPlayVideoLink,
    this.userGuideVideoLink,
  });

  static String platformSlug = Platform.isAndroid ? "android" : "ios";

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        appConfigs: json["app_config"] == null ? [] : List<AppConfigModel>.from(json["app_config"]!.map((x) => AppConfigModel.fromJson(x))),
        versions: json[platformSlug] == null ? [] : List<VersionModel>.from(json[platformSlug]!.map((x) => VersionModel.fromJson(x))),
        howToPlayVideoLink: json["howToPlayVideoLink"],
        userGuideVideoLink: json["userGuideVideoLink"],
      );

  Map<String, dynamic> toJson() => {
        "app_config": appConfigs == null ? [] : List<dynamic>.from(appConfigs!.map((x) => x.toJson())),
        platformSlug: versions == null ? [] : List<dynamic>.from(versions!.map((x) => x.toJson())),
        "howToPlayVideoLink": howToPlayVideoLink,
        "userGuideVideoLink": userGuideVideoLink,
      };
}

class VersionModel {
  String? id;
  String? version;
  bool? forceUpdate;
  bool? softUpdate;
  bool? maintenance;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  VersionModel({
    this.id,
    this.version,
    this.forceUpdate,
    this.softUpdate,
    this.maintenance,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) => VersionModel(
        id: json["_id"],
        version: json["version"],
        forceUpdate: json["force_update"],
        softUpdate: json["soft_update"],
        maintenance: json["maintenance"],
        type: json["type"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "version": version,
        "force_update": forceUpdate,
        "soft_update": softUpdate,
        "maintenance": maintenance,
        "type": type,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class AppConfigModel {
  String? id;
  bool? defaultConfig;
  AppConfigDetails? appConfig;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  AppConfigModel({
    this.id,
    this.defaultConfig,
    this.appConfig,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) => AppConfigModel(
        id: json["_id"],
        defaultConfig: json["default_config"],
        appConfig: json["app_config"] == null ? null : AppConfigDetails.fromJson(json["app_config"]),
        type: json["type"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "default_config": defaultConfig,
        "app_config": appConfig?.toJson(),
        "type": type,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class AppConfigDetails {
  String? primary;
  String? themeMode;
  String? privacy;
  String? terms;
  String? communityGuidelines;
  String? aboutUs;
  String? responsiblePlay;
  String? legality;
  String? playStoreLink;
  String? appStoreLink;
  String? contactUs;
  String? howToPlay;
  String? pointsSystem;

  AppConfigDetails({
    this.primary,
    this.themeMode,
    this.privacy,
    this.terms,
    this.communityGuidelines,
    this.aboutUs,
    this.responsiblePlay,
    this.legality,
    this.playStoreLink,
    this.appStoreLink,
    this.contactUs,
    this.howToPlay,
    this.pointsSystem,
  });

  factory AppConfigDetails.fromJson(Map<String, dynamic> json) => AppConfigDetails(
        primary: json["primary"],
        themeMode: json["theme_mode"],
        privacy: json["privacy"],
        terms: json["terms"],
        communityGuidelines: json["community_guidelines"],
        aboutUs: json["about_us"],
        responsiblePlay: json["responsible_play"],
        legality: json["legality"],
        playStoreLink: json["play_store_link"],
        appStoreLink: json["app_store_link"],
        contactUs: json["contact_us"],
        howToPlay: json["how_to_play"],
        pointsSystem: json["points_system"],
      );

  Map<String, dynamic> toJson() => {
        "primary": primary,
        "theme_mode": themeMode,
        "privacy": privacy,
        "terms": terms,
        "community_guidelines": communityGuidelines,
        "about_us": aboutUs,
        "responsible_play": responsiblePlay,
        "legality": legality,
        "play_store_link": playStoreLink,
        "app_store_link": appStoreLink,
        "contact_us": contactUs,
        "how_to_play": howToPlay,
        "points_system": pointsSystem,
      };
}
