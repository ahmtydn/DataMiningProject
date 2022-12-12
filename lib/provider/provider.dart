import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:package_usage_stats/package_usage_stats.dart';
import 'package:permission_handler/permission_handler.dart';

class DataMiningProvider extends ChangeNotifier{
  bool _requested=false;
  bool get requested=>_requested;
  final HealthFactory _health = HealthFactory();
  HealthFactory get health =>_health;
  bool _isGrantedAppUsage =false;
  bool get isGrantedAppUsage=>_isGrantedAppUsage;
  bool _adimIzin=false;
  bool get adimIzin=>_adimIzin;

  void changeAdimIzin(){
    _adimIzin=true;
  }


  Future<void> getAuthorizationAppUsage() async {
    _isGrantedAppUsage=await PackageUsageStats.checkPermissionStatus();
    if (kDebugMode) {
      print("Provider Uygulama Erişim Yetkisi : $_isGrantedAppUsage");
    }

  }

  Future<void> getAuthorizationHealth() async {
    final types = [
      HealthDataType.HEIGHT,
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.BODY_MASS_INDEX,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];
    // with coresponsing permissions
    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    await Permission.activityRecognition.request();
    _requested = await health.requestAuthorization(types, permissions: permissions);
    if (kDebugMode) {
      print("Provider Sağlık Yetkisi : $_requested");
    }
  }
}