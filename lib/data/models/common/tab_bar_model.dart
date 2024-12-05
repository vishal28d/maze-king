import 'dart:convert';

import 'package:get/get.dart';

TabBarModel tabBarModelFromJson(String str) => TabBarModel.fromJson(json.decode(str));

String tabBarModelToJson(TabBarModel data) => json.encode(data.toJson());

class TabBarModel {
  final String? title;
  RxBool? showBadge;
  RxInt? badgeLabel;

  TabBarModel({
    this.title,
    this.showBadge,
    this.badgeLabel,
  });

  factory TabBarModel.fromJson(Map<String, dynamic> json) => TabBarModel(
        title: json["title"],
        showBadge: RxBool(json["showBadge"]),
        badgeLabel: RxInt(json["badgeLabel"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "showBadge": showBadge?.value,
        "badgeLabel": badgeLabel?.value,
      };
}
