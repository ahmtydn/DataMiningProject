// To parse this JSON data, do
//
//     final surveyData = surveyDataFromJson(jsonString);

import 'dart:convert';

SurveyData surveyDataFromJson(String str) =>
    SurveyData.fromJson(json.decode(str));

String surveyDataToJson(SurveyData data) => json.encode(data.toJson());

class SurveyData {
  SurveyData({
    required this.surveyData,
  });

  List<SurveyDatum> surveyData;

  factory SurveyData.fromJson(Map<String, dynamic> json) => SurveyData(
        surveyData: List<SurveyDatum>.from(
            json["surveyData"].map((x) => SurveyDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "surveyData": List<dynamic>.from(surveyData.map((x) => x.toJson())),
      };
}

class SurveyDatum {
  SurveyDatum({
    required this.soruId,
    required this.soru,
    required this.answer,
  });

  String soruId;
  String soru;
  String answer;

  factory SurveyDatum.fromJson(Map<String, dynamic> json) => SurveyDatum(
        soruId: json["soruID"],
        soru: json["soru"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "soruID": soruId,
        "soru": soru,
        "answer": answer,
      };
}
