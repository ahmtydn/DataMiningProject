// To parse this JSON data, do
//
//     final dataModel = dataModelFromJson(jsonString);

import 'dart:convert';

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
  DataModel({
    required this.age,
    required this.stepsTotal,
    required this.bodyMassIndex,
    required this.energyBurned,
    required this.gender,
    required this.height,
    required this.phoneModel,
    required this.saveTime,
    required this.weight,
    required this.infoAppUse,
    required this.appsCategory,
  });

  String age;
  String stepsTotal;
  String bodyMassIndex;
  String energyBurned;
  String gender;
  String height;
  String phoneModel;
  DateTime saveTime;
  String weight;
  List<InfoAppUse> infoAppUse;
  List<AppsCategory> appsCategory;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        age: json["age"],
        stepsTotal: json["stepsTotal"],
        bodyMassIndex: json["body_mass_index"],
        energyBurned: json["energyBurned"],
        gender: json["gender"],
        height: json["height"],
        phoneModel: json["phoneModel"],
        saveTime: DateTime.parse(json["saveTime"]),
        weight: json["weight"],
        infoAppUse: List<InfoAppUse>.from(
            json["infoAppUse"].map((x) => InfoAppUse.fromJson(x))),
        appsCategory: List<AppsCategory>.from(
            json["appsCategory"].map((x) => AppsCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "age": age,
        "stepsTotal": stepsTotal,
        "body_mass_index": bodyMassIndex,
        "energyBurned": energyBurned,
        "gender": gender,
        "height": height,
        "phoneModel": phoneModel,
        "saveTime": saveTime.toIso8601String(),
        "weight": weight,
        "infoAppUse": List<dynamic>.from(infoAppUse.map((x) => x.toJson())),
        "appsCategory": List<dynamic>.from(appsCategory.map((x) => x.toJson())),
      };
}

class AppsCategory {
  AppsCategory({
    required this.appName,
    required this.category,
  });

  String appName;
  String category;

  factory AppsCategory.fromJson(Map<String, dynamic> json) => AppsCategory(
        appName: json["appName"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "appName": appName,
        "category": category,
      };
}

class InfoAppUse {
  InfoAppUse({
    required this.appName,
    required this.appUseTime,
  });

  String appName;
  String appUseTime;

  factory InfoAppUse.fromJson(Map<String, dynamic> json) => InfoAppUse(
        appName: json["appName"],
        appUseTime: json["appUseTime"],
      );

  Map<String, dynamic> toJson() => {
        "appName": appName,
        "appUseTime": appUseTime,
      };
}
