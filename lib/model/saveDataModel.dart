import 'package:app_usage/app_usage.dart';

class SaveDataModel {
  String age;

  SaveDataModel(
      {required this.age,
      required this.stepsTotal,
      required this.bodyMassIndex,
      required this.energyBurned,
      required this.gender,
      required this.height,
      required this.phoneModel,
      required this.saveTime,
      required this.weight,
      required this.infoAppUse});

  String stepsTotal;
  String bodyMassIndex;
  String energyBurned;
  String gender;
  String height;
  String phoneModel;
  DateTime saveTime;
  String weight;
  List<AppUsageInfo> infoAppUse;
}
