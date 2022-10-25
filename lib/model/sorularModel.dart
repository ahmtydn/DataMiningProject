// To parse this JSON data, do
//
//     final sorularModel = sorularModelFromJson(jsonString);

import 'dart:convert';

SorularModel sorularModelFromJson(String str) =>
    SorularModel.fromJson(json.decode(str));

String sorularModelToJson(SorularModel data) => json.encode(data.toJson());

class SorularModel {
  SorularModel({
    required this.soruData,
  });

  List<SoruDatum> soruData;

  factory SorularModel.fromJson(Map<String, dynamic> json) => SorularModel(
        soruData: List<SoruDatum>.from(
            json["soruData"].map((x) => SoruDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "soruData": List<dynamic>.from(soruData.map((x) => x.toJson())),
      };
}

class SoruDatum {
  SoruDatum({
    required this.soru,
    required this.cevaplar,
  });

  String soru;
  List<Cevaplar> cevaplar;

  factory SoruDatum.fromJson(Map<String, dynamic> json) => SoruDatum(
        soru: json["soru"],
        cevaplar: List<Cevaplar>.from(
            json["cevaplar"].map((x) => Cevaplar.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "soru": soru,
        "cevaplar": List<dynamic>.from(cevaplar.map((x) => x.toJson())),
      };
}

class Cevaplar {
  Cevaplar({
    required this.cevap,
  });

  String cevap;

  factory Cevaplar.fromJson(Map<String, dynamic> json) => Cevaplar(
        cevap: json["cevap"],
      );

  Map<String, dynamic> toJson() => {
        "cevap": cevap,
      };
}
