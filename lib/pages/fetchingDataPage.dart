import 'dart:convert';
import 'package:device_apps/device_apps.dart';
import 'package:http/http.dart' as http;
import 'package:app_usage/app_usage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verimadenciligi/fetchData/fetchData.dart';
import 'package:verimadenciligi/model/dataModel.dart';
import 'package:verimadenciligi/pages/HomePage.dart';

class FetchingDataPage extends StatefulWidget {
  const FetchingDataPage({Key? key}) : super(key: key);

  @override
  State<FetchingDataPage> createState() => _FetchingDataPageState();
}

class _FetchingDataPageState extends State<FetchingDataPage> {
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
  //#endregion

  //#region  Fetching
  Future<void> fetchsData() async {
    await fetchData().authorizationCheck();
    var _steps,
        _height,
        _weight,
        _energyBurned,
        _body_mass_index,
        _age,
        _genders,
        _phoneModel;

    await fetchData()
        .fetchStepData()
        .then((value) => _steps = value.toString());
    await fetchData()
        .fetchHeight()
        .then((value) => _height = value.toString().substring(0, 4));
    await fetchData().fetchWeight().then((value) => _weight = value.toString());
    await fetchData()
        .fetchEnergyBurned()
        .then((value) => _energyBurned = value.toString());
    await fetchData()
        .fetchBodyIndex()
        .then((value) => _body_mass_index = value.toString());
    await fetchData()
        .ageReadSharedPreferences()
        .then((value) => _age = value.toString());
    await fetchData()
        .genderReadSharedPreferences()
        .then((value) => _genders = value.toString());
    await deviceInfoGet().then((value) => _phoneModel = value.toString());
    DateTime time = DateTime.now();

    _dataModel = DataModel(
      stepsTotal: _steps,
      height: _height,
      weight: _weight,
      energyBurned: _energyBurned,
      bodyMassIndex: _body_mass_index,
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
    DateTime _time = DateTime.now();
    String nowTime="${_time.day}/${_time.month}/${_time.year}";
    print("Şimdiki zaman: $nowTime");
    bool sharedPermission=await checkSharedPrefences(nowTime);
    if(!sharedPermission){


      var jsonData = jsonEncode(_dataModel!);
      var url =
          "https://verimadenciligi-365117-default-rtdb.firebaseio.com/dataApps.json";
      var httpClient = http.Client();
      var response = await httpClient.post(Uri.parse(url), body: jsonData);
      var id=response.body.substring(9,29);
      await removeShared();
      saveSharedPrefences(dataID: id,time: nowTime);
      print("response id: ${id}");
    }
    else{
      var jsonData = jsonEncode(_dataModel!);
      print(dataID);
      var url =
          "https://verimadenciligi-365117-default-rtdb.firebaseio.com/dataApps/${dataID}.json";
      var httpClient = http.Client();
      await httpClient.put(Uri.parse(url), body: jsonData);
    }

  }

  Future<void>removeShared() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("time");
    sharedPreferences.remove("dataID");
  }

  Future<bool> checkSharedPrefences(String nowDate) async {
   var sharedPreferences = await SharedPreferences.getInstance();
   var time=sharedPreferences.getString("time");
   dataID=sharedPreferences.getString("dataID");
   if(time!=null&&dataID!=null&&time==nowDate){
     return true;
   }else{
     return false;
   }
  }

  Future<void> saveSharedPrefences({String? dataID,String? time}) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("time", time!);
    sharedPreferences.setString("dataID", dataID!);
  }

  void getUsageStats() async {
    try {
      final yesterday = DateTime.now().subtract(Duration(days:1));
      final yesterdayStart =DateTime(yesterday.year,yesterday.month,yesterday.day,00,00);
      final yesterdayEnd = DateTime(yesterdayStart.year, yesterdayStart.month, yesterdayStart.day,23,59,59);

      infoList = await AppUsage.getAppUsage(yesterdayStart, yesterdayEnd);
      List.generate(
          infoList.length,
          (index) => _infosApps.add(InfoAppUse(
              appName: infoList[index].appName.toString(),
              appUseTime: infoList[index].usage.toString())));
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }
//#endregion
  @override
  void initState() {
    getUsageStats();
    getCetogrys();
    fetchDataMain();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : HomePage());
  }
}


