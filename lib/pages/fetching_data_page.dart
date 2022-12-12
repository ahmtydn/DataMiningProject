import 'dart:convert';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:app_usage/app_usage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:package_usage_stats/package_usage_stats.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verimadenciligi/fetching/fetch_data.dart';
import 'package:verimadenciligi/model/data_model.dart';
import 'package:verimadenciligi/pages/quiz_page.dart';
import 'package:verimadenciligi/pages/home_page.dart';
import 'package:verimadenciligi/provider/provider.dart';

class FetchingDataPage extends StatefulWidget {
  const FetchingDataPage({Key? key}) : super(key: key);

  @override
  State<FetchingDataPage> createState() => _FetchingDataPageState();
}

class _FetchingDataPageState extends State<FetchingDataPage>
    with WidgetsBindingObserver {
  //#region definitions
  DataModel? _dataModel;
  bool isLoading = true;
  DatabaseReference? referenceData;
  DatabaseReference? referenceChild;
  List<InfoAppUse> _infosApps = [];
  List<AppsCategory> _categoryApps = [];
  List<AppUsageInfo> infoList = [];
  List<Application> apps = [];
  String? dataID;
  bool? isLoginShared;
  //#endregion

  //#region  Fetching
  Future<void> fetchsData() async {
    var _steps,
        _height,
        _weight,
        _energyBurned,
        BodyMassIndex,
        _age,
        _genders,
        _phoneModel;

    // ignore: use_build_context_synchronously
    await FetchData()
        .fetchStepData(context)
        .then((value) => _steps = value.toString());
    // ignore: use_build_context_synchronously
    await FetchData()
        .fetchHeight(context)
        .then((value) => _height = value.toString().substring(0, 4));
    // ignore: use_build_context_synchronously
    await FetchData()
        .fetchWeight(context)
        .then((value) => _weight = value.toString());
    // ignore: use_build_context_synchronously
    await FetchData()
        .fetchEnergyBurned(context)
        .then((value) => _energyBurned = value.toString());
    // ignore: use_build_context_synchronously
    await FetchData()
        .fetchBodyIndex(context)
        .then((value) => BodyMassIndex = value.toString());
    await FetchData()
        .ageReadSharedPreferences()
        .then((value) => _age = value.toString());
    await FetchData()
        .genderReadSharedPreferences()
        .then((value) => _genders = value.toString());
    await deviceInfoGet().then((value) => _phoneModel = value.toString());
    DateTime time = DateTime.now();

    _dataModel = DataModel(
      stepsTotal: _steps,
      height: _height,
      weight: _weight,
      energyBurned: _energyBurned,
      bodyMassIndex: BodyMassIndex,
      age: _age,
      gender: _genders,
      phoneModel: _phoneModel,
      infoAppUse: _infosApps,
      saveTime: time,
      appsCategory: _categoryApps,
    );

    save();
  }

  Future<void> fetchDataMain() async {
    await fetchsData();
    setState(() {
      isLoading = false;
    });
  }

  Future<String> deviceInfoGet() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    return androidInfo.model;
  }

  Future<void> getCetogrys() async {
    apps = await DeviceApps.getInstalledApplications();
    List.generate(
        apps.length,
        (index) => _categoryApps.add(AppsCategory(
            appName: apps[index].appName.toString(),
            category: apps[index].category.name.toString())));
  }

  Future<void> save() async {
    await dataSave();
  }

  Future<void> dataSave() async {
    var userID = FirebaseAuth.instance.currentUser!.uid;

    DateTime _time = DateTime.now();
    String nowTime = "${_time.day}/${_time.month}/${_time.year}";
    print("Şimdiki zaman: $nowTime");
    bool sharedPermission = await checkSharedPrefences(nowTime);
    if (!sharedPermission) {
      //the first data of the day is saved
      var jsonData = jsonEncode(_dataModel!);
      var url =
          "https://datamining-367013-default-rtdb.firebaseio.com/Data/${userID}/dailyData.json";
      var httpClient = http.Client();
      var response = await httpClient.post(Uri.parse(url), body: jsonData);
      var id = response.body.substring(9, 29);
      await removeShared();
      saveSharedPrefences(dataID: id, time: nowTime);
      print("response id: ${id}");
      print(jsonData);
    } else {
      //update data
      var jsonData = jsonEncode(_dataModel!);
      print(dataID);
      var url =
          "https://datamining-367013-default-rtdb.firebaseio.com/Data/${userID}/dailyData/${dataID}.json";
      var httpClient = http.Client();
      await httpClient.put(Uri.parse(url), body: jsonData);
      print(jsonData);
    }
  }

  Future<void> removeShared() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("time");
    sharedPreferences.remove("dataID");
  }

  Future<bool> checkSharedPrefences(String nowDate) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var time = sharedPreferences.getString("time");
    dataID = sharedPreferences.getString("dataID");
    if (time != null && dataID != null && time == nowDate) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveSharedPrefences({String? dataID, String? time}) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("time", time!);
    sharedPreferences.setString("dataID", dataID!);
  }

  Future<void> getUsageStats() async {
    final provider = Provider.of<DataMiningProvider>(context, listen: false);
    try {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayStart =
          DateTime(yesterday.year, yesterday.month, yesterday.day, 00, 00);
      final yesterdayEnd = DateTime(yesterdayStart.year, yesterdayStart.month,
          yesterdayStart.day, 23, 59, 59);
      if (kDebugMode) {
        print("Başlangıç Tarihi:$yesterdayStart");
      }
      if (kDebugMode) {
        print("Bitiş Tarihi:$yesterdayEnd");
      }

      if (provider.isGrantedAppUsage) {
        infoList = await AppUsage.getAppUsage(yesterdayStart, yesterdayEnd);

        List.generate(
            infoList.length,
            (index) => _infosApps.add(InfoAppUse(
                appName: infoList[index].appName.toString(),
                appUseTime: infoList[index].usage.toString())));
      } else {
        PackageUsageStats.openAppUsageSettings();
      }
    } on AppUsageException catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
    }
  }
//#endregion

  Future<void> getSharedIsLogin() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    isLoginShared = sharedPreferences.getBool("isLogin");
  }

  Future<void> getAllData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUsageStats();
    });
    await getCetogrys();
    await fetchDataMain();
  }

  void getAndSaveData() async {
    final provider = Provider.of<DataMiningProvider>(context, listen: false);
    await getSharedIsLogin();
    await provider.getAuthorizationAppUsage();
    if (provider.isGrantedAppUsage == false) {
      await PackageUsageStats.openAppUsageSettings();
    } else {
      await provider.getAuthorizationHealth();
      if (provider.requested == true &&
          await Permission.activityRecognition.status.isGranted) {
        getAllData();
      }
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    final provider = Provider.of<DataMiningProvider>(context, listen: false);
    if (state == AppLifecycleState.resumed) {
      await provider.getAuthorizationAppUsage();
      if (provider.isGrantedAppUsage == false) {
        await PackageUsageStats.openAppUsageSettings();
      } else {
        if (provider.requested == false) {
          await provider.getAuthorizationHealth();
        } else {
          if (await Permission.activityRecognition.status.isGranted) {
            getAllData();
          } else {
            if (await Permission.activityRecognition.request().isGranted) {
              provider.changeAdimIzin();
            }
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getAndSaveData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : isLoginShared == false || isLoginShared == null
                ? QuizPage(
                    data: _dataModel!,
                  )
                : HomePage(
                    data: _dataModel!,
                  ));
  }
}
